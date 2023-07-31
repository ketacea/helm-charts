# ketadb Helm Deployment Guide

## Limitations
* k8s >= 1.18
* Install [Helm](https://helm.sh/docs/intro/install/)


## Quick Deployment
### Add Helm Repository
```bash
helm repo add keta-chart http://chart-prod.ketaops.cc
helm repo update keta-chart
```

### Install MySQL
```bash
# For data safety, please modify the password below
helm install --create-namespace mysql keta-chart/mysql -n keta --set auth.createDatabase=true --set auth.database=ketadb --set auth.username=keta --set auth.password="changeThisPassword" 
```

### Install ketadb
```bash
# Set the same MySQL user and password as MySQL for ketadb here
helm install --create-namespace ketadb keta-chart/ketadb -n keta --set mysql.host=mysql --set mysql.password="changeThisPassword" --set mysql.user=keta --set mysql.database=ketadb 
```

### Check Deployment Status and Logs
```bash
kubectl get pod -n keta
kubectl logs ketadb -n keta
```

## Usage Instructions
* This chart includes several available configurations [examples](./examples/) for reference:
    * [Default](./examples/default/Readme.md): Default deployment, starts 1 node with master, data, and web roles.
    * [Docker For Mac](./examples/docker-for-mac/Readme.md): Testing scenario, starts 1 node using local database (h2) as the backend.
    * [Multi-node](./examples/multi/Readme.md): Multi-node deployment, includes three roles (master, data, web) with one node each.
    * [Replica-mysql](./examples/replica-mysql/Readme.md): MySQL high availability scenario, contains two MySQL nodes, and ketadb as the default scenario with one node.
    * *todo: More scenarios*
* You may need to set reasonable resource configurations for your cluster:
    * JVM: `ketaJavaOptions`, modify this parameter to adjust the Java JVM memory size, defaults to `-Xmx1g -Xms1g`.
    * CPU and Memory: `resources`, adjust CPU and memory request and limit values, refer to [Data Volume vs. Resources]( *todo: Add data volume to resource recommendations*].
    * Storage: `volumeClaimTemplate`, estimate the approximate storage usage for your cluster, refer to [Data Volume vs. Resources]( *todo: Add data volume to resource recommendations*]. 
* For production deployments, it's recommended to categorize node types. Currently, the supported types are `master`, `data`, and `web`. In the [example/multi](./examples/multi/) directory, you can find an example of how this works. It's important to note that the cluster can only include one release with the master role. Under the master role workload, you can deploy multiple Pods.
* About Node Role Explanation: *todo*
    * master:
    * data:
    * web:
* Regarding storage selection, for high availability, it's recommended to use network storage like Ceph, NFS, etc. For high performance, you can use local storage like hostPath, Carina, etc.
* For node-tiered storage, you can specify the data node's storage type at deployment time with `roles.dataStorageType`, choosing between `hot`, `cold`, `warm`. *todo: Add cold, warm storage strategies*
* Regarding scaling:
    * Storage scaling: Whether storage scaling is possible mainly depends on whether the storage class provider supports this feature. When it's supported, you can expand PVC as follows:
        \```bash
        kubectl patch pvc ketadb-ketadb-0 -n keta --patch '{"spec":{"resources":{"requests":{"storage": "30Gi"}}}}'
        \```
        Note that after modifying certain storage class providers, you might need to restart Pods for changes to take effect. Refer to the specific requirements of your storage class provider for more information.
    * CPU/Memory scaling: When node resources are insufficient, you can modify container resources as follows:
        \```bash
        helm upgrade ketadb keta-chart/ketadb -n keta --set resources.requests.cpu="4" --set resources.requests.memory="8Gi" --set resources.limit.cpu="8" --set resources.limit.memory="16Gi"
        \```
    * Node scaling: You can achieve node scaling by dynamically increasing the number of Pods. Suppose you had 1 Pod under the statefulset previously; you can execute the following command to scale to 3 nodes: `kubectl scale statefulsets ketadb --replicas=3`
* Regarding scaling down, you can achieve cluster downsizing by reducing the number of Pods. It's important to note that if your cluster data cannot exist in replicas, you may use the first method; otherwise, you can use the second method.
    * Method 1: *todo: Describe the method of marking nodes for eviction*
    * Method 2: Downsizing requires the number of replicas for data repositories not to be less than 2. For data nodes, downsizing needs to be done gradually and not too aggressively, as it may result in data loss. For example, if you have 3 data nodes and need to reduce it to 1, you need to first reduce it to 2, wait for the cluster's status to turn green, then set it to 1, and continue to wait for it to turn green. Downsizing will not delete PVC, so if you find data loss, you can adjust the number of Pods back and check if there are any issues with the data settings. If some of your repositories have a replica count less than 2, you will need to use the first method.
* Regarding data migration: *todo: Add data migration steps*

## Other Parameters

| Parameter Name | Default Value | Description |
| --- | --- | --- |
| clusterName | ketadb | The name of the Ketadb cluster. When deploying multiple releases with Helm, the `clusterName` parameter must be the same. |
| replicas | 1 | The number of replicas for the Ketadb cluster. You can adjust this parameter to achieve node scaling. |
| podManagementPolicy | OrderedReady | The Pod management policy. The default is rolling deployment, but you can choose `Parallel`. |
| updateStrategy | updateStrategy | The update strategy for Pods in Kubernetes. Possible values are `Recreate`, `RollingUpdate`, `OnDelete`. |
| image.repository | docker.ketaops.cc | The container image repository name. |
| image.tag | latest | The tag for the Ketadb image. |
| image.PullPolicy | IfNotPresent | The image pull policy. Possible values are `Always`, `IfNotPresent`, `Never`. |
| pod.labels | {} | Labels to add to Pods in Kubernetes. It's a collection of key-value pairs used to provide custom metadata for Pods. Labels can be used to identify and organize Pods, facilitating filtering, selection, and operations. |
| pod.annotations | {} | Annotations to add additional descriptive information to Pods, providing detailed documentation or other auxiliary information. |
| service.labels                          | {}   | service.labels is used to add labels to the Service to identify and organize it.                              |
| service.type                            | ClusterIP   | service.type defines the type of Service, which can be ClusterIP, NodePort, LoadBalancer, or ExternalName.            |
| service.nodePort                        | ""   | service.nodePort specifies the port number for the NodePort type of Service. It only applies when service.type is set to NodePort.                        |
| service.annotations                     | {}   | service.annotations is used to add annotations to the Service, providing additional information or metadata about the Service.   |
| service.ports.http                      | 9200   | Exposes the HTTP service, including web pages and API interfaces, to the outside world.                              |
| service.ports.transport                 | 9300   | This port defines the port for inter-node service discovery.                          |
| service.ports.monitor                   | 10005   | Data collection port within the application, used by the "Configuration -> Listener Collection" feature.                             |
| service.ports.heartbeat                 | 9400   | Heartbeat port.                             |
| service.ports.rpc                       | 9500   | RPC port used to invoke SPL query statements.                                 |
| service.ports.otlp                     | 4317   | Port for opentelemetric used to collect tracing data.            |
| service.loadBalancerIP                  | ""   | service.loadBalancerIP is used to specify the IP address of the LoadBalancer type Service's load balancer. When creating a LoadBalancer type Service, this parameter can be used to specify a specific IP address to allow external clients to access the Service.                          |
| service.loadBalancerSourceRanges        | []    | service.loadBalancerSourceRanges is used to restrict the source IP range that can access the LoadBalancer type Service. By setting this parameter, you can specify the allowed source IP address range to access the Service, and requests from other IPs will be denied. This can enhance the security and access control of the Service.                   |
| service.extraPorts                      | []    | Additional port configurations. Use this to expose other services.                              |
| resources.requests.cpu                  | 2   | resources.requests.cpu specifies the amount of CPU resources requested by the Pod or container.                                 |
| resources.requests.memory               | 4Gi   | resources.requests.memory specifies the amount of memory resources requested by the Pod or container.                                 |
| resources.limits.cpu                    | 2   | resources.limits.cpu is used to specify the maximum CPU resource limit for the Pod or container in Kubernetes. It defines the maximum CPU resource quantity that the Pod or container is allowed to use on a node. Exceeding this limit may result in the Pod or container being restricted or terminated. The CPU limit can be specified as an integer or a decimal, usually denoted in CPU units (e.g., "0.5" represents half of a CPU core).                                |
| resources.limits.memory                 | 4Gi   | resources.limits.memory is used to specify the maximum memory resource limit for the Pod or container in Kubernetes. It defines the maximum memory resource quantity that the Pod or container is allowed to use on a node. Exceeding this limit may result in the Pod or container being restricted or terminated. The memory limit is usually denoted in bytes (e.g., "1Gi" represents 1GB) or other appropriate units.                                 |
| persistence.enabled                     | true  | Whether to enable persistent storage.                         |
| persistence.annotations                | {}   | persistence.annotations is used to add additional information or metadata to the persistent storage.                           |
| volumeClaimTemplate.accessModes         | [ReadWriteOnce]    | volumeClaimTemplate.accessModes is used to specify the access modes of the persistent storage claim. The options are ReadWriteOnce, ReadOnlyMany, and ReadWriteMany.        |
| volumeClaimTemplate.resources.requests.storage | 30Gi | volumeClaimTemplate.resources.requests.storage is used to specify the storage capacity requirement of the PersistentVolumeClaim. It defines the minimum capacity required for the storage volume. By setting this value, you can tell the Kubernetes scheduler how much storage space to allocate for the persistent storage claim. The storage capacity is usually denoted in bytes (e.g., "1Gi" represents 1GB) or other appropriate units.                      |
| podSecurityContext.fsGroup              | 0  | podSecurityContext.fsGroup is used to specify the filesystem group ID for processes inside the container. The default is 0 (root).                        |
| podSecurityContext.runAsUser             | integer  | podSecurityContext.runAsUser is used to specify the user ID for processes inside the container. The default is 0 (root).                              |
| securityContext.privileged              | boolean  | securityContext.privileged is used to specify whether the container has privileged mode. The default is true.                      |
| securityContext.capabilities.drop       | []    | securityContext.capabilities.drop is used to specify the capabilities that the container runtime should drop.               |
| securityContext.capabilities.add        | [SYS_ADMIN,NET_RAW,NET_ADMIN]    | Used to specify additional capabilities that should be added to the container at runtime.                |
| securityContext.runAsNonRoot            | false  | Whether to run the container with a non-root user identity.              |
| securityContext.runAsUser               | 0  | User ID for the container. The default is 0 (root).                              |
| ingress.enabled                         | false  | Whether to enable Ingress. If enabled, the service can be accessed through an external domain name.                         |
| ingress.annotations                     | {}   | Annotations for Ingress.                             |
| ingress.path                            | "/"   | Ingress matching path. The default is "/".                    |
| ingress.hosts                     | [example.com]    | Ingress domain addresses. Be sure to fill in the correct path when enabling Ingress.           |
| nodeSelector                            | {}   | nodeSelector is used to specify the node label selector for the Pod, enabling targeted scheduling.                              |
| tolerations                             | []    | tolerations are used to define the toleration of Pods to specific conditions or taints on nodes, allowing Pods to run on non-matching nodes.                                 |
| antiAffinity                            | hard   | antiAffinity is used to specify the anti-affinity rule for Pods, avoiding scheduling related Pods on nodes in the same topology domain. It can be set to "hard" or "soft". When set to "hard", it will forcefully ensure that Pods are not scheduled on the same machine. If the system cannot provide enough machines, scheduling will stop. When set to "soft", it will try to ensure that Pods are not scheduled on the same machine, and if there are not enough machines that meet the conditions, the Pod will be scheduled on the same machine.                          |
| nodeAffinity                            | {}   | nodeAffinity is used to specify the node affinity rule for Pods, controlling which nodes the Pod should be scheduled on.                           |
| priorityClassName                       | ""   | [priorityClassName](https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/#priorityclass) is used to specify the priority class for Pods, affecting the scheduling order of Pods.                          |
| terminationGracePeriod                  | 30  | terminationGracePeriod is used to specify the graceful termination period for the Pod, giving the Pod additional time to finish tasks and cleanup before termination.                          |
| sysctlInitContainer.enabled             | boolean  | Whether to enable the sysctl init container. You can disable this option if you can set vm.max_map_count through other means.                |
| sysctlInitContainer.sysctlVmMaxMapCount | 262144  | sysctl vm.max_map_count configuration.             |
| sysctlInitContainer.resources            | {}   | Resource configuration for the sysctl init container.                 |
| extraInitContainers                     | []    | Additional Init container configuration.                        |
| readinessProbe.failureThreshold         | 10  | The failure threshold for the readiness probe.                          |
| readinessProbe.initialDelaySeconds      | 30  | The initial delay time for the readiness probe.                      |
| readinessProbe.periodSeconds            | 10  | The interval time for the readiness probe.                          |
| readinessProbe.successThreshold         | 3  | The success threshold for the readiness probe.                          |
| readinessProbe.timeoutSeconds           | 10  | The timeout for the readiness probe.                          |
| livenessProbe.failureThreshold          | 10  | The failure threshold for the liveness probe.                          |
| livenessProbe.initialDelaySeconds       | 30  | The initial delay time for the liveness probe.                      |
| livenessProbe.periodSeconds             | 10  | The interval time for the liveness probe.                          |
| livenessProbe.timeoutSeconds            | 10  | The timeout for the liveness probe.                          |
| dcServerUrl                             | ""   | The address where the agent gets the configuration from Ketadb. The default is the ingress address, and if Ingress is not enabled, it uses the service address, corresponding to service.ports.http.                       |
| dcServerHeartbeats                      | ""   | The address used by the agent to communicate with Ketadb, corresponding to service.ports.heartbeat.                    |
| dcDataTransUrls                         | ""   | The service address for the agent to send data points to Ketadb. The default is the ingress address, and if Ingress is not enabled, it uses the service address, corresponding to service.ports.http.                   |
| alertHost                               | ""   | The address displayed in the alert notification information. The default is the ingress address, and if Ingress is not enabled, it uses the service address, corresponding to service.ports.http.                                  |
| licenseCheckInterval                    | 300s   | The interval time for license checks.                        |
| roles.master                            | true  | Whether this node is the master role.                           |
| roles.web                               | true  | Whether this node is the web role.                            |
| roles.data                              | true  | Whether this node is the data role.                             |
| roles.ingest                            | true   | When ingest is true, this node can enable the "Listener Collection" feature.          |
| env                                     | {}   | Environment variables can be set to inject Ketadb configuration.                               |
| envFrom                                 | []    | Import environment variables from Secret or ConfigMap.         |
| secretMounts                            |    [] | Secret mount configuration.                            |
| extraVolumeMounts                       |  []   | Additional Volume mount configuration.                      |
| extraContainers                         | []    | Additional container configuration.                              |

