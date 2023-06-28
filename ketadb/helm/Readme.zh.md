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

### 安装ketadb

```bash
helm install --create-namespace ketadb keta-chart/ketadb -n keta
```

### 查看部署状态和日志
```bash
kubectl get pod -n keta
kubectl logs ketadb -n keta
```

## 更新
### 从仓库更新helm chart
```bash
helm repo update keta-chart
```

### 更新ketadb
```bash
helm upgrade ketadb keta-chart/ketadb -n keta
```

## 设置ingress
```bash
helm install ketadb keta-chart/ketadb -n keta --set ingress.enabled=true --set ingress.hostsSuffix[0]=example.com
```

## 其它参数

| 参数名称                                       | 类型     | 描述                                       |
|------------------------------------------------|----------|--------------------------------------------|
| clusterName                             | string   | Ketadb 集群的名称。                          |
| replicas                                | integer  | Ketadb 集群的副本数量。                      |
| podManagementPolicy                     | string   | Pod 的管理策略，此处为并发部署。              |
| updateStrategy                          | string   | 更新策略，此处为滚动升级。                    |
| image.repository                        | string   | Ketadb 镜像的仓库。                          |
| image.tag                               | string   | Ketadb 镜像的标签。                          |
| image.PullPolicy                        | string   | 镜像拉取策略。                               |
| pod.labels                              | object   | 为 Pod 添加标签。                             |
| pod.annotations                         | object   | 为 Pod 添加注释。                             |
| service.labels                          | object   | Service 的标签。                              |
| service.type                            | string   | Service 的类型，此处为 ClusterIP。            |
| service.nodePort                        | string   | Service 的 NodePort。                         |
| service.annotations                     | object   | Service 的注释。                              |
| service.ports.http                      | string   | HTTP 端口。                                  |
| service.ports.transport                 | string   | Transport 端口。                             |
| service.ports.monitor                   | string   | Monitor 端口。                               |
| service.ports.heartbeat                 | string   | Heartbeat 端口。                             |
| service.ports.rpc                       | string   | RPC 端口。                                   |
| service.ports.debug                     | string   | Debug 端口。                                 |
| service.loadBalancerIP                  | string   | LoadBalancer 的 IP。                          |
| service.loadBalancerSourceRanges        | array    | LoadBalancer 的源 IP 范围。                   |
| service.extraPorts                      | array    | 额外的端口配置。                              |
| resources.requests.cpu                  | string   | CPU 请求量。                                 |
| resources.requests.memory               | string   | 内存请求量。                                 |
| resources.limits.cpu                    | string   | CPU 限制量。                                 |
| resources.limits.memory                 | string   | 内存限制量。                                 |
| persistence.enabled                     | boolean  | 是否启用持久化存储。                         |
| persistence.annotations                | object   | 持久化存储的注释。                           |
| volumeClaimTemplate.accessModes         | array    | 存储卷访问模式，此处为 ReadWriteOnce。        |
| volumeClaimTemplate.resources.requests.storage | string | 存储请求量配置。                      |
| podSecurityContext.fsGroup              | integer  | Pod 的文件系统组。                           |
| podSecurityContext.runAsUser             | integer  | Pod 的用户 ID。                              |
| securityContext.privileged              | boolean  | 是否以特权模式运行容器。                      |
| securityContext.capabilities.drop       | array    | 从容器的能力列表中移除的能力。                |
| securityContext.capabilities.add        | array    | 添加到容器的能力列表中的能力。                |
| securityContext.runAsNonRoot            | boolean  | 是否以非 root 用户身份运行容器。              |
| securityContext.runAsUser               | integer  | 容器的用户 ID。                              |
| ingress.enabled                         | boolean  | 是否启用 Ingress。                           |
| ingress.annotations                     | object   | Ingress 的注释。                             |
| ingress.path                            | string   | Ingress 的路径。                             |
| ingress.hostsSuffix                     | array    | Ingress 的主机后缀。                         |
| nodeSelector                            | object   | Node 的选择器。                              |
| tolerations                             | array    | 容忍性配置。                                 |
| antiAffinity                            | string   | Pod 的反亲和性配置。                          |
| nodeAffinity                            | object   | Node 的亲和性配置。                           |
| priorityClassName                       | string   | Pod 的优先级类名称。                          |
| terminationGracePeriod                  | integer  | 优雅停止的等待时间。                          |
| sysctlInitContainer.enabled             | boolean  | 是否启用 sysctl 初始化容器。                  |
| sysctlInitContainer.sysctlVmMaxMapCount | integer  | sysctl 的 vm.max_map_count 配置。             |
| sysctlInitContainer.resources            | object   | sysctl 初始化容器的资源配置。                 |
| extraInitContainers                     | array    | 额外的 Init 容器配置。                        |
| readinessProbe.failureThreshold         | integer  | 就绪探针的失败阈值。                          |
| readinessProbe.initialDelaySeconds      | integer  | 就绪探针的初始延迟时间。                      |
| readinessProbe.periodSeconds            | integer  | 就绪探针的间隔时间。                          |
| readinessProbe.successThreshold         | integer  | 就绪探针的成功阈值。                          |
| readinessProbe.timeoutSeconds           | integer  | 就绪探针的超时时间。                          |
| livenessProbe.failureThreshold          | integer  | 存活探针的失败阈值。                          |
| livenessProbe.initialDelaySeconds       | integer  | 存活探针的初始延迟时间。                      |
| livenessProbe.periodSeconds             | integer  | 存活探针的间隔时间。                          |
| livenessProbe.timeoutSeconds            | integer  | 存活探针的超时时间。                          |
| dcServerUrl                             | string   | 数据中心服务器的 URL。                        |
| dcServerHeartbeats                      | string   | 数据中心服务器的心跳配置。                    |
| dcDataTransUrls                         | string   | 数据中心数据传输 URL 配置。                   |
| alertHost                               | string   | 告警主机。                                   |
| licenseCheckInterval                    | string   | 许可证检查的间隔时间。                        |
| unicast                                 | string   | Unicast 配置。                               |
| roles.master                            | boolean  | 是否为主节点角色。                           |
| roles.web                               | boolean  | 是否为 Web 角色。                            |
| roles.data                              | boolean  | 是否为数据角色。                             |
| roles.ingest                            | string   | Ingest 角色配置。                             |
| env                                     | object   | 环境变量配置。                               |
| envFrom                                 | array    | 从 Secret 或 ConfigMap 引入环境变量。         |
| secretMounts                            | array    | Secret 挂载配置。                            |
| extraVolumeMounts                       | array    | 额外的 Volume 挂载配置。                      |
| extraContainers                         | array    | 额外的容器配置。                              |
| mysql.image.repository               | "mysql"                          | 镜像仓库名称                                             |
| mysql.image.pullPolicy               | "Always"                         | 镜像拉取策略                                             |
| mysql.image.tag                      | "8.0.32"                         | 镜像标签                                                 |
| mysql.imagePullSecrets               |                                  | 镜像拉取凭据                                             |
| mysql.nameOverride                   |                                  | 名称覆盖                                                 |
| mysql.fullnameOverride               | "mysql"                          | 完整名称覆盖                                             |
| mysql.serviceAccount.create           | false                            | 是否创建服务账号                                         |
| mysql.serviceAccount.annotations      | {}                               | 服务账号的注解                                           |
| mysql.serviceAccount.name             |                                  | 使用的服务账号名称                                       |
| mysql.podAnnotations                 |                                  | Pod的注解                                                |
| mysql.podSecurityContext             | {}                               | Pod的安全上下文                                          |
| mysql.securityContext                | {}                               | 安全上下文                                               |
| mysql.service.type                   | NodePort                         | 服务类型                                                 |
| mysql.service.port                   | 3306                             | 服务端口                                                 |
| mysql.resources                      | {}                               | 资源配额                                                 |
| mysql.nodeSelector                   |                                  | 节点选择器                                               |
| mysql.tolerations                    |                                  | 容忍性设置                                               |
| mysql.affinity                       |                                  | 亲和性设置                                               |
| mysql.extraVolumes.name              | mysql-data                       | 额外卷的名称                                             |
| mysql.extraVolumes.persistentVolumeClaimName | mysql-data-pvc           | 持久卷声明名称                                           |
| mysql.extraVolumes.size              | 8Gi                              | 额外卷的大小                                             |
| mysql.configurationFilesPath         | /etc/mysql/conf.d/              | 自定义mysql配置文件的路径                                 |
| mysql.configurationFiles             |                                  | 自定义mysql配置文件，用于覆盖默认的mysql设置              |

