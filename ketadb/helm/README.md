# ketadb Helm Deployment Instructions

## Limitations
* k8s >= 1.18
* Install [helm](https://helm.sh/docs/intro/install/)


## Quick Deployment
### Add Helm Repository
```bash
helm repo add keta-chart http://chart-prod.ketaops.cc
helm repo update keta-chart
```

### Install ketadb
```bash
helm install --create-namespace ketadb keta-chart/ketadb -n keta

```


## Other Parameters

| Parameter Name                                 | Type     | Description                                 |
|------------------------------------------------|----------|---------------------------------------------|
| clusterName                             | string   | Name of the Ketadb cluster.                  |
| replicas                                | integer  | Number of replicas for the Ketadb cluster.   |
| podManagementPolicy                     | string   | Pod management policy, set to "Parallel" here.|
| updateStrategy                          | string   | Update strategy, set to "RollingUpdate" here.|
| image.repository                        | string   | Repository for the Ketadb image.             |
| image.tag                               | string   | Tag for the Ketadb image.                    |
| image.PullPolicy                        | string   | Image pull policy.                           |
| pod.labels                              | object   | Labels for the Pod.                          |
| pod.annotations                         | object   | Annotations for the Pod.                     |
| service.labels                          | object   | Labels for the Service.                      |
| service.type                            | string   | Type of the Service, set to "ClusterIP" here.|
| service.nodePort                        | string   | NodePort for the Service.                    |
| service.annotations                     | object   | Annotations for the Service.                 |
| service.ports.http                      | string   | HTTP port.                                  |
| service.ports.transport                 | string   | Transport port.                             |
| service.ports.monitor                   | string   | Monitor port.                               |
| service.ports.heartbeat                 | string   | Heartbeat port.                             |
| service.ports.rpc                       | string   | RPC port.                                   |
| service.ports.debug                     | string   | Debug port.                                 |
| service.loadBalancerIP                  | string   | LoadBalancer IP.                            |
| service.loadBalancerSourceRanges        | array    | LoadBalancer source IP ranges.               |
| service.extraPorts                      | array    | Additional port configurations.              |
| resources.requests.cpu                  | string   | CPU request.                                |
| resources.requests.memory               | string   | Memory request.                             |
| resources.limits.cpu                    | string   | CPU limit.                                  |
| resources.limits.memory                 | string   | Memory limit.                               |
| persistence.enabled                     | boolean  | Enable persistence storage.                  |
| persistence.annotations                | object   | Annotations for the persistence storage.     |
| volumeClaimTemplate.accessModes         | array    | Access modes for the volume claim, set to "ReadWriteOnce" here. |
| volumeClaimTemplate.resources.requests.storage | string | Storage request configuration.        |
| podSecurityContext.fsGroup              | integer  | Filesystem group for the Pod.                |
| podSecurityContext.runAsUser             | integer  | User ID for the Pod.                         |
| securityContext.privileged              | boolean  | Run the container in privileged mode.        |
| securityContext.capabilities.drop       | array    | Capabilities to drop from the container's capability list. |
| securityContext.capabilities.add        | array    | Capabilities to add to the container's capability list.    |
| securityContext.runAsNonRoot            | boolean  | Run the container as a non-root user.         |
| securityContext.runAsUser               | integer  | User ID for the container.                    |
| ingress.enabled                         | boolean  | Enable Ingress.                              |
| ingress.annotations                     | object   | Annotations for the Ingress.                  |
| ingress.path                            | string   | Path for the Ingress.                         |
| ingress.hostsSuffix                     | array    | Host suffixes for the Ingress.                |
| nodeSelector                            | object   | Node selector.                               |
| tolerations                             | array    | Tolerations configuration.                    |
| antiAffinity                            | string   | Pod anti-affinity configuration.              |
| nodeAffinity                            | object   | Node affinity configuration.                  |
| priorityClassName                       | string   | Priority class name for the Pod.              |
| terminationGracePeriod                  | integer  | Termination grace period in seconds.          |
| sysctlInitContainer.enabled             | boolean  | Enable sysctl init container.                 |
| sysctlInitContainer.sysctlVmMaxMapCount | integer  | sysctl vm.max_map_count configuration.        |
| sysctlInitContainer.resources            | object   | Resource configuration for the sysctl init container. |
| extraInitContainers                     | array    | Additional init container configuration.      |
| readinessProbe.failureThreshold         | integer  | Failure threshold for the readiness probe.    |
| readinessProbe.initialDelaySeconds      | integer  | Initial delay in seconds for the readiness probe.   |
| readinessProbe.periodSeconds            | integer  | Interval in seconds between readiness probes.       |
| readinessProbe.successThreshold         | integer  | Success threshold for the readiness probe.    |
| readinessProbe.timeoutSeconds           | integer  | Timeout in seconds for the readiness probe.   |
| livenessProbe.failureThreshold          | integer  | Failure threshold for the liveness probe.     |
| livenessProbe.initialDelaySeconds       | integer  | Initial delay in seconds for the liveness probe.    |
| livenessProbe.periodSeconds             | integer  | Interval in seconds between liveness probes.        |
| livenessProbe.timeoutSeconds            | integer  | Timeout in seconds for the liveness probe.    |
| dcServerUrl                             | string   | URL of the data center server.                |
| dcServerHeartbeats                      | string   | Heartbeat configuration for the data center server. |
| dcDataTransUrls                         | string   | Data transfer URL configuration for the data center. |
| alertHost                               | string   | Alert host.                                  |
| licenseCheckInterval                    | string   | Interval for license check.                   |
| unicast                                 | string   | Unicast configuration.                        |
| roles.master                            | boolean  | Whether it is a master role.                  |
| roles.web                               | boolean  | Whether it is a web role.                     |
| roles.data                              | boolean  | Whether it is a data role.                    |
| roles.ingest                            | string   | Ingest role configuration.                     |
| env                                     | object   | Environment variable configuration.           |
| envFrom                                 | array    | Import environment variables from Secret or ConfigMap. |
| secretMounts                            | array    | Secret mount configuration.                   |
| extraVolumeMounts                       | array    | Additional volume mount configuration.         |
| extraContainers                         | array    | Additional container configuration.           |
| mysql.replicaCount                | 1                                | Number of replicas                                       |
| mysql.image.repository            | "mysql"                          | Image repository name                                    |
| mysql.image.pullPolicy            | "Always"                         | Image pull policy                                        |
| mysql.image.tag                   | "8.0.32"                         | Image tag                                                |
| mysql.imagePullSecrets            |                                  | Image pull secrets                                       |
| mysql.nameOverride                |                                  | Name override                                            |
| mysql.fullnameOverride            | "mysql"                          | Full name override                                       |
| mysql.serviceAccount.create        | false                            | Whether to create a service account                       |
| mysql.serviceAccount.annotations   | {}                               | Annotations for the service account                       |
| mysql.serviceAccount.name          |                                  | Name of the service account to use                        |
| mysql.podAnnotations              |                                  | Annotations for the Pod                                  |
| mysql.podSecurityContext          | {}                               | Security context for the Pod                             |
| mysql.securityContext             | {}                               | Security context for the container                       |
| mysql.service.type                | NodePort                         | Service type                                             |
| mysql.service.port                | 3306                             | Service port                                             |
| mysql.resources                   | {}                               | Resource limits                                          |
| mysql.nodeSelector                |                                  | Node selector                                            |
| mysql.tolerations                 |                                  | Tolerations                                              |
| mysql.affinity                    |                                  | Affinity settings                                        |
| mysql.extraVolumes.name           | mysql-data                       | Extra volume name                                        |
| mysql.extraVolumes.persistentVolumeClaimName | mysql-data-pvc           | Persistent volume claim name                             |
| mysql.extraVolumes.size           | 8Gi                              | Extra volume size                                        |
| mysql.configurationFilesPath      | /etc/mysql/conf.d/              | Custom MySQL configuration files path                     |
| mysql.configurationFiles          |                                  | Custom MySQL configuration files to override default settings |                                     |

## FAQ
### Common deployment scenarios.
* [Default](./examples/default)
* [Docker For Mac](./examples/docker-for-mac)

