# ketadb helm部署说明

## 限制条件
* k8s >= 1.18
* 安装[helm](https://helm.sh/docs/intro/install/)


## 快速部署
### 添加helm仓库
```bash
helm repo add keta-chart http://chart-prod.ketaops.cc
helm repo update keta-chart
```

### 安装mysql
```bash
# 为了您的数据安全，请修改下面的密码
helm install --create-namespace mysql keta-chart/mysql -n keta --set auth.createDatabase=true --set auth.database=ketadb --set auth.username=keta --set auth.password="changeThisPassword" 
```

### 安装ketadb

```bash
# 这里设置的mysql用户和密码与mysql的用户密码一致
helm install --create-namespace ketadb keta-chart/ketadb -n keta --set mysql.host=mysql --set mysql.password="changeThisPassword" --set mysql.user=keta --set mysql.database=ketadb 
```

您可以用k8s forword 的方式访问 web 服务:

``` bash
kubectl port-forward svc/ketadb 9200 -n keta

# visit for web
open http://localhost:9200
```

### 查看部署状态和日志
```bash
kubectl get pod -n keta
kubectl logs ketadb -n keta
```

## 使用说明
* 此chart包括几个可以使用的配置[示例](./ketadb/examples/)作为参考
    * [Default](./ketadb/examples/default/Readme.md)  默认部署方式，将会启动1个节点，同时拥有master、data、web角色
    * [Docker For Mac](./ketadb/examples/docker-for-mac/Readme.md) 测试方案，将启动一个节点，后端数据库使用本地数据库（h2）
    * [mutil](./ketadb/examples/multi/Readme.md)  多节点部署方案，将包括三个角色(master、data、web)，每个角色1个节点
    * [replica-mysql](./ketadb/examples/replica-mysql/Readme.md)  mysql高可用方案，包含两个mysql节点，ketadb为默认方案（1个节点）
    * *todo: 更多场景*
* 您可能需要为你的集群设置合理的资源配置
    * JVM: `ketaJavaOptions`，修改此参数调整java jvm内存大小，默认为`-Xmx1g -Xms1g`
    * CPU and Memory: `resources`, 调整cpu和内存的request以及limit，调整方式请参考[数据量与资源对应关系][ *todo: 补充数据量级推荐资源*]
    * Storage: `volumeClaimTemplate`，您需要预估您集群大致的存储用量，具体参考[数据量与资源对应关系][ *todo: 补充数据量级推荐资源*] 
* 在生产部署时，建议对节点的类型做划分，当前支持`master`, `data`, `web`，在[example/multi](./ketadb/examples/multi/)目录中有此示例，可以查看其如何工作的。值得说明的是，集群中只能包含一个master角色的release。在master角色的workload下，你可以部署多个Pod。
* 关于节点角色说明：todo
    * master：
    * data：
    * web：
* 关于storage选择，从高可用角度推荐使用网络存储，比如ceph，nfs等；从高性能角度讲，可以使用本地存储，比如hostPath、carina等
* 关于节点分层存储，你可以在部署时指定data节点的存储类型`roles.dataStorageType`, 可以选择`hot`, `cold`, `warm` *todo: 补充冷热温的存储策略*
* 关于扩容
    * 存储扩容，能否进行存储扩容主要决定因素是storage class提供商是否支持该功能，当它支持时，您可以通过如下命令修改pvc来扩容；
        ```bash
        kubectl patch pvc ketadb-ketadb-0 -n keta --patch '{"spec":{"resources":{"requests":{"storage": "30Gi"}}}}'
        ```
        需要注意的是，某些storage class提供商修改后，需要重启Pod来生效。具体的要求可以参考您的storage class提供商的说明
    * CPU/Memory扩容，当遇到节点资源不满足需求时，你可以修改container的资源：
        ```bash
        helm upgrade ketadb keta-chart/ketadb -n keta --set resources.requests.cpu="4" --set resources.requests.memory="8Gi" --set resources.limit.cpu="8" --set resources.limit.memory="16Gi"
        ```
    * 节点扩容，您可以通过动态增加Pod来实现节点扩容，假设您之前statefulset下有1个Pod，可以执行下面语句扩展为3个节点：`kubectl scale statefulsets ketadb --replicas=3`
* 关于缩容，您可以通过减少Pod数量来对集群缩容，需要注意的是，当您的集群数据不能都存在副本的情况下，您可能使用第一种方案，否则您可以使用第二种方案
    * 方案1: *todo:需要描述节点标记为驱逐的方式*
    * 方案2: 缩容需要数据仓库的副本数量不能低于2，针对data节点，缩容需要循序渐进，不能用力过猛，否则会导致数据丢失。比如，当前有3个数据节点，需要缩减为1个，您需要先缩减为2个，等到集群的状态变成绿色时，再设置为1个，并继续等待其变成绿色。缩容并不会删除pvc，所以当您发现数据丢失，您可以重新将Pod数量调整回来，并检查数据设置是否存在问题。如您某些仓库副本数量低于2，则需要采用第一种方案。
* 关于数据迁移
    * *todo：补充数据迁移相关步骤*

## 其它参数

| 参数名称                                       | 默认值     | 描述                                       |
|------------------------------------------------|----------|--------------------------------------------|
| clusterName                             | ketadb   | Ketadb 集群的名称，使用helm部署多个release时，clusterName参数需要相同      |
| replicas                                | 1  | Ketadb 集群的副本数量，您可以调整这个参数来实现节点扩容                      |
| podManagementPolicy                     | OrderedReady   | Pod 的管理策略，默认为滚动部署，可选Parallel              |
| updateStrategy                          | updateStrategy   | updateStrategy用于定义Kubernetes中Pod更新策略，可选值有Recreate、RollingUpdate、OnDelete。                    |
| image.repository                        | docker.ketaops.cc   | image.repository用于指定容器镜像的仓库名称。                          |
| image.tag                               | latest   | Ketadb 镜像的标签。                          |
| image.PullPolicy                        | IfNotPresent   | 指定镜像拉取策略，可选Always、IfNotPresent、Never。                               |
| pod.labels                              | {}   | pod.labels用于在Kubernetes中为Pod添加标签。它是一个键值对的集合，用于为Pod提供自定义的元数据。标签可以用于标识和组织Pod，方便进行筛选、选择和操作。                             |
| pod.annotations                         | {}   | pod.annotations用于为Pod添加附加描述信息，提供详细文档或其他辅助信息。                             |
| service.labels                          | {}   | service.labels用于为Service添加标签，用于标识和组织Service。                              |
| service.type                            | ClusterIP   | service.type定义Service的类型，可选ClusterIP、NodePort、LoadBalancer、ExternalName。            |
| service.nodePort                        | ""   | service.nodePort指定NodePort类型的Service暴露的端口号。仅service.type选择为NodePort时适用                        |
| service.annotations                     | {}   | service.annotations用于为Service添加注解，提供关于Service的附加信息或元数据。   |
| service.ports.http                      | 9200   | 对外提供的http服务，包括web页面以及api接口                              |
| service.ports.transport                 | 9300   | 此端口定义节点间服务发现的端口                          |
| service.ports.monitor                   | 10005   | 应用内的数据收集端口，应用内的"配置->监听采集"功能使用                             |
| service.ports.heartbeat                 | 9400   | Heartbeat 端口。                             |
| service.ports.rpc                       | 9500   | RPC 端口。用来调用SPL查询语句                                 |
| service.ports.otlp                     | 4317   | opentelemetric的端口，用来收集链路数据            |
| service.loadBalancerIP                  | ""   | service.loadBalancerIP用于指定LoadBalancer类型的Service所使用的负载均衡器的IP地址。当创建LoadBalancer类型的Service时，可以通过该参数指定要使用的特定IP地址，以便外部客户端可以通过该IP访问Service。                          |
| service.loadBalancerSourceRanges        | []    | service.loadBalancerSourceRanges用于限制访问LoadBalancer类型的Service的源IP范围。通过设置这个参数，可以指定允许访问该Service的源IP地址范围。只有源IP在指定范围内的请求才能访问Service，其他IP将被拒绝访问。这可以增加对Service的安全性和访问控制。                   |
| service.extraPorts                      | []    | 额外的端口配置。如需暴露其它service，可在此定义                              |
| resources.requests.cpu                  | 2   | resources.requests.cpu指定Pod或容器对CPU资源的请求量。                                 |
| resources.requests.memory               | 4Gi   | resources.requests.cpu指定Pod或容器对内存资源的请求量。                                 |
| resources.limits.cpu                    | 2   | resources.limits.cpu是Kubernetes中用于指定Pod或容器对CPU资源的限制量。它定义了Pod或容器允许使用的最大CPU资源数量。这个值用于限制Pod或容器在节点上消耗的CPU资源，超过限制将导致Pod或容器被限制或终止。限制的CPU值可以是整数或小数，通常以CPU单位（如"0.5"表示半个CPU核心）进行指定。                                |
| resources.limits.memory                 | 4Gi   | resources.limits.memory是Kubernetes中用于指定Pod或容器对内存资源的限制量。它定义了Pod或容器允许使用的最大内存资源数量。这个值用于限制Pod或容器在节点上消耗的内存资源，超过限制将导致Pod或容器被限制或终止。限制的内存值通常以字节（如"1Gi"表示1GB）或其他合适的单位进行指定。                                 |
| persistence.enabled                     | true  | 是否启用持久化存储。                         |
| persistence.annotations                | {}   | persistence.annotations用于为持久化存储添加附加信息或元数据。                           |
| volumeClaimTemplate.accessModes         | [ReadWriteOnce]    | volumeClaimTemplate.accessModes用于指定持久化存储声明的访问模式。可选值为ReadWriteOnce、ReadOnlyMany、ReadWriteMany。        |
| volumeClaimTemplate.resources.requests.storage | 30Gi | volumeClaimTemplate.resources.requests.storage用于指定持久化存储声明（PersistentVolumeClaim）的存储容量需求。它定义了对存储卷的最低容量要求。通过设置这个值，可以告诉Kubernetes调度器需要为该持久化存储声明分配多少存储空间。存储容量通常以字节（如"1Gi"表示1GB）或其他适当的单位进行指定。                      |
| podSecurityContext.fsGroup              | 0  | podSecurityContext.fsGroup用于指定容器内进程的文件系统组ID。默认为0（root）                        |
| podSecurityContext.runAsUser             | integer  | podSecurityContext.runAsUser用于指定容器内进程的用户ID。默认为0（root）                              |
| securityContext.privileged              | boolean  | securityContext.privileged用于指定容器是否具有特权模式。默认为true                      |
| securityContext.capabilities.drop       | []    | securityContext.capabilities.drop用于指定容器运行时需丢弃的特权能力               |
| securityContext.capabilities.add        | [SYS_ADMIN,NET_RAW,NET_ADMIN]    | 用于指定容器运行时额外添加的特权能力                |
| securityContext.runAsNonRoot            | false  | 是否以非 root 用户身份运行容器。              |
| securityContext.runAsUser               | 0  | 容器的用户 ID。默认为0（root）                              |
| ingress.enabled                         | false  | 是否启用 Ingress。启用后可通过外部域名访问服务                         |
| ingress.annotations                     | {}   | Ingress 的注释。                             |
| ingress.path                            | "/"   | Ingress 匹配路径。默认是/                    |
| ingress.hosts                     | [example.com]    | Ingress 域名地址，开启ingress时务必填写正确这个路径           |
| nodeSelector                            | {}   | nodeSelector用于指定Pod所需的节点标签选择器，实现有针对性的调度。                              |
| tolerations                             | []    | tolerations用于定义Pod对节点上特定条件或污点的容忍性，允许Pod在不匹配的节点上运行。                                 |
| antiAffinity                            | hard   | antiAffinity用于指定Pod的反亲和性规则，避免将相关的Pod调度到同一拓扑域内的节点，可选设置hard和soft，当选择hard时，会强制保证pod不被调度到同一台机器上，如果系统不能提供足够机器，则会停止调度。设置为soft会尽量保证不被调度到同一台机器，满足条件机器不足时会将pod调度到同一台机器                          |
| nodeAffinity                            | {}   | nodeAffinity用于指定Pod的节点亲和性规则，控制Pod应该调度到哪些节点上运行。                           |
| priorityClassName                       | ""   | [priorityClassName](https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass)用于指定Pod的优先级类别，影响Pod的调度顺序。                          |
| terminationGracePeriod                  | 30  | terminationGracePeriod用于指定Pod的优雅终止期，给予Pod在终止前完成任务和清理工作的额外时间。                          |
| sysctlInitContainer.enabled             | boolean  | 是否启用 sysctl 初始化容器。您如果可以通过其他方式设置vm.max_map_count,则可以关闭此选项                |
| sysctlInitContainer.sysctlVmMaxMapCount | 262144  | sysctl 的 vm.max_map_count 配置。             |
| sysctlInitContainer.resources            | {}   | sysctl 初始化容器的资源配置。                 |
| extraInitContainers                     | []    | 额外的 Init 容器配置。                        |
| readinessProbe.failureThreshold         | 10  | 就绪探针的失败阈值。                          |
| readinessProbe.initialDelaySeconds      | 30  | 就绪探针的初始延迟时间。                      |
| readinessProbe.periodSeconds            | 10  | 就绪探针的间隔时间。                          |
| readinessProbe.successThreshold         | 3  | 就绪探针的成功阈值。                          |
| readinessProbe.timeoutSeconds           | 10  | 就绪探针的超时时间。                          |
| livenessProbe.failureThreshold          | 10  | 存活探针的失败阈值。                          |
| livenessProbe.initialDelaySeconds       | 30  | 存活探针的初始延迟时间。                      |
| livenessProbe.periodSeconds             | 10  | 存活探针的间隔时间。                          |
| livenessProbe.timeoutSeconds            | 10  | 存活探针的超时时间。                          |
| dcServerUrl                             | ""   | agent从ketadb获取配置的地址，默认为ingress地址，如果ingress未开启，则使用service地址，对应service.ports.http                       |
| dcServerHeartbeats                      | ""   | agent与ketadb通信地址，对应service.ports.heartbeat                    |
| dcDataTransUrls                         | ""   | agent打点到ketadb的服务地址，默认为ingress地址，如果ingress未开启，则使用service地址，对应service.ports.http                   |
| alertHost                               | ""   | 告警通知信息中显示的地址，默认为ingress地址，如果ingress未开启，则使用service地址，对应service.ports.http                                  |
| licenseCheckInterval                    | 300s   | 许可证检查的间隔时间。                        |
| roles.master                            | true  | 是否为主节点角色。                           |
| roles.web                               | true  | 是否为 Web 角色。                            |
| roles.data                              | true  | 是否为数据角色。                             |
| roles.ingest                            | true   | 当ingest为true时，则此节点可启用“监听采集”功能          |
| env                                     | {}   | 可设置环境变量来注入ketadb配置                               |
| envFrom                                 | []    | 从 Secret 或 ConfigMap 引入环境变量。         |
| secretMounts                            |    [] | Secret 挂载配置。                            |
| extraVolumeMounts                       |  []   | 额外的 Volume 挂载配置。                      |
| extraContainers                         | []    | 额外的容器配置。                              |



## 数据量与资源
[数据量与资源对应关系]: 