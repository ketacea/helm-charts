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

### Check Deployment Status and Logs
```bash
kubectl get pod -n keta
kubectl logs ketadb-0 -n keta
```

## Update
### Update Helm Chart from Repository
```bash
helm repo update keta-chart
```

### Update ketadb
```bash
helm upgrade ketadb keta-chart/ketadb -n keta
```

## Configure Ingress
```bash
helm install ketadb keta-chart/ketadb -n keta --set ketadb.ingress.enabled=true --set ketadb.ingress.hostsSuffix[0]=ketadb.example.com
```

## Other Parameters

| Parameter Name                                 | Type     | Description                                 |
|------------------------------------------------|----------|---------------------------------------------|
| ketadb.clusterName                             | string   | Name of the Ketadb cluster.                  |
| ketadb.replicas                                | integer  | Number of replicas for the Ketadb cluster.   |
| ketadb.podManagementPolicy                     | string   | Pod management policy, set to "Parallel" here.|
| ketadb.updateStrategy                          | string   | Update strategy, set to "RollingUpdate" here.|
| ketadb.image.repository                        | string   | Repository for the Ketadb image.             |
| ketadb.image.tag                               | string   | Tag for the Ketadb image.                    |
| ketadb.image.PullPolicy                        | string   | Image pull policy.                           |
| ketadb.pod.labels                              | object   | Labels for the Pod.                          |
| ketadb.pod.annotations                         | object   | Annotations for the Pod.                     |
| ketadb.service.labels                          | object   | Labels for the Service.                      |
| ketadb.service.type                            | string   | Type of the Service, set to "ClusterIP" here.|
| ketadb.service.nodePort                        | string   | NodePort for the Service.                    |
| ketadb.service.annotations                     | object   | Annotations for the Service.                 |
| ketadb.service.ports.http                      | string   | HTTP port.                                  |
| ketadb.service.ports.transport                 | string   | Transport port.                             |
| ketadb.service.ports.monitor                   | string   | Monitor port.                               |
| ketadb.service.ports.heartbeat                 | string   | Heartbeat port.                             |
| ketadb.service.ports.rpc                       | string   | RPC port.                                   |
| ketadb.service.ports.debug                     | string   | Debug port.                                 |
| ketadb.service.loadBalancerIP                  | string   | LoadBalancer IP.                            |
| ketadb.service.loadBalancerSourceRanges        | array    | LoadBalancer source IP ranges.               |
| ketadb.service.extraPorts                      | array    | Additional port configurations.              |
| ketadb.resources.requests.cpu                  | string   | CPU request.                                |
| ketadb.resources.requests.memory               | string   | Memory request.                             |
| ketadb.resources.limits.cpu                    | string   | CPU limit.                                  |
| ketadb.resources.limits.memory                 | string   | Memory limit.                               |
| ketadb.persistence.enabled                     | boolean  | Enable persistence storage.                  |
| ketadb.persistence.annotations                | object   | Annotations for the persistence storage.     |
| ketadb.volumeClaimTemplate.accessModes         | array    | Access modes for the volume claim, set to "ReadWriteOnce" here. |
| ketadb.volumeClaimTemplate.resources.requests.storage | string | Storage request configuration.        |
| ketadb.podSecurityContext.fsGroup              | integer  | Filesystem group for the Pod.                |
| ketadb.podSecurityContext.runAsUser             | integer  | User ID for the Pod.                         |
| ketadb.securityContext.privileged              | boolean  | Run the container in privileged mode.        |
| ketadb.securityContext.capabilities.drop       | array    | Capabilities to drop from the container's capability list. |
| ketadb.securityContext.capabilities.add        | array    | Capabilities to add to the container's capability list.    |
| ketadb.securityContext.runAsNonRoot            | boolean  | Run the container as a non-root user.         |
| ketadb.securityContext.runAsUser               | integer  | User ID for the container.                    |
| ketadb.ingress.enabled                         | boolean  | Enable Ingress.                              |
| ketadb.ingress.annotations                     | object   | Annotations for the Ingress.                  |
| ketadb.ingress.path                            | string   | Path for the Ingress.                         |
| ketadb.ingress.hostsSuffix                     | array    | Host suffixes for the Ingress.                |
| ketadb.nodeSelector                            | object   | Node selector.                               |
| ketadb.tolerations                             | array    | Tolerations configuration.                    |
| ketadb.antiAffinity                            | string   | Pod anti-affinity configuration.              |
| ketadb.nodeAffinity                            | object   | Node affinity configuration.                  |
| ketadb.priorityClassName                       | string   | Priority class name for the Pod.              |
| ketadb.terminationGracePeriod                  | integer  | Termination grace period in seconds.          |
| ketadb.sysctlInitContainer.enabled             | boolean  | Enable sysctl init container.                 |
| ketadb.sysctlInitContainer.sysctlVmMaxMapCount | integer  | sysctl vm.max_map_count configuration.        |
| ketadb.sysctlInitContainer.resources            | object   | Resource configuration for the sysctl init container. |
| ketadb.extraInitContainers                     | array    | Additional init container configuration.      |
| ketadb.readinessProbe.failureThreshold         | integer  | Failure threshold for the readiness probe.    |
| ketadb.readinessProbe.initialDelaySeconds      | integer  | Initial delay in seconds for the readiness probe.   |
| ketadb.readinessProbe.periodSeconds            | integer  | Interval in seconds between readiness probes.       |
| ketadb.readinessProbe.successThreshold         | integer  | Success threshold for the readiness probe.    |
| ketadb.readinessProbe.timeoutSeconds           | integer  | Timeout in seconds for the readiness probe.   |
| ketadb.livenessProbe.failureThreshold          | integer  | Failure threshold for the liveness probe.     |
| ketadb.livenessProbe.initialDelaySeconds       | integer  | Initial delay in seconds for the liveness probe.    |
| ketadb.livenessProbe.periodSeconds             | integer  | Interval in seconds between liveness probes.        |
| ketadb.livenessProbe.timeoutSeconds            | integer  | Timeout in seconds for the liveness probe.    |
| ketadb.dcServerUrl                             | string   | URL of the data center server.                |
| ketadb.dcServerHeartbeats                      | string   | Heartbeat configuration for the data center server. |
| ketadb.dcDataTransUrls                         | string   | Data transfer URL configuration for the data center. |
| ketadb.alertHost                               | string   | Alert host.                                  |
| ketadb.licenseCheckInterval                    | string   | Interval for license check.                   |
| ketadb.unicast                                 | string   | Unicast configuration.                        |
| ketadb.roles.master                            | boolean  | Whether it is a master role.                  |
| ketadb.roles.web                               | boolean  | Whether it is a web role.                     |
| ketadb.roles.data                              | boolean  | Whether it is a data role.                    |
| ketadb.roles.ingest                            | string   | Ingest role configuration.                     |
| ketadb.env                                     | object   | Environment variable configuration.           |
| ketadb.envFrom                                 | array    | Import environment variables from Secret or ConfigMap. |
| ketadb.secretMounts                            | array    | Secret mount configuration.                   |
| ketadb.extraVolumeMounts                       | array    | Additional volume mount configuration.         |
| ketadb.extraContainers                         | array    | Additional container configuration.           |
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

