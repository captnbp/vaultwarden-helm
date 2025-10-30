# Helm chart for Vaultwarden

[![Helm Release](https://img.shields.io/docker/v/vaultwarden/server/1.26.0)](https://img.shields.io/docker/v/vaultwarden/server/1.26.0)

[Vaultwarden](https://github.com/dani-garcia/vaultwarden), formerly known as **Bitwarden_RS**, is an "alternative implementation of the Bitwarden server API written in Rust and compatible with [upstream Bitwarden clients](https://bitwarden.com/download/), perfect for self-hosted deployment where running the official resource-heavy service might not be ideal."

## TL;DR

```console
$ helm install my-release oci://registry-1.docker.io/captnbp/vaultwarden
```

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- PV provisioner support in the underlying infrastructure
- [cert-manager](docs/projects/csi-driver/#supported-volume-attributes)

## Installing the Chart

To install the chart with the release name `my-release`:

```console
$ helm install my-release oci://registry-1.docker.io/captnbp/vaultwarden
```

These commands deploy Vaultwarden on the Kubernetes cluster in the default configuration. The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` release:

```console
$ helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release. Remove also the chart using `--purge` option:

```console
$ helm delete --purge my-release
```


## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |


### Common parameters

| Name                     | Description                                                                             | Value           |
| ------------------------ | --------------------------------------------------------------------------------------- | --------------- |
| `kubeVersion`            | Force target Kubernetes version (using Helm capabilities if not set)                    | `""`            |
| `nameOverride`           | String to partially override common.names.fullname                                      | `""`            |
| `fullnameOverride`       | String to fully override common.names.fullname                                          | `""`            |
| `namespaceOverride`      | String to fully override common.names.namespace                                         | `""`            |
| `commonLabels`           | Labels to add to all deployed objects                                                   | `{}`            |
| `commonAnnotations`      | Annotations to add to all deployed objects                                              | `{}`            |
| `clusterDomain`          | Default Kubernetes cluster domain                                                       | `cluster.local` |
| `extraDeploy`            | Array of extra objects to deploy with the release                                       | `[]`            |
| `diagnosticMode.enabled` | Enable diagnostic mode (all probes will be disabled and the command will be overridden) | `false`         |
| `diagnosticMode.command` | Command to override all containers in the the statefulset                               | `["sleep"]`     |
| `diagnosticMode.args`    | Args to override all containers in the the statefulset                                  | `["infinity"]`  |


### Vaultwarden parameters

| Name                | Description                                                                                                 | Value                |
| ------------------- | ----------------------------------------------------------------------------------------------------------- | -------------------- |
| `image.registry`    | Vaultwarden image registry                                                                                  | `docker.io`          |
| `image.repository`  | Vaultwarden image repository                                                                                | `vaultwarden/server` |
| `image.tag`         | Vaultwarden image tag (immutable tags are recommended)                                                      | `1.30.0-alpine`      |
| `image.digest`      | Vaultwarden image digest in the way sha256:aa.... Please note this parameter, if set, will override the tag | `""`                 |
| `image.pullPolicy`  | Vaultwarden image pull policy                                                                               | `IfNotPresent`       |
| `image.pullSecrets` | Specify docker-registry secret names as an array                                                            | `[]`                 |
| `image.debug`       | Enable %%MAIN_CONTAINER%% image debug mode                                                                  | `false`              |
| `rocket.workers`    | Rocket number of workers                                                                                    | `10`                 |
| `webVaultEnabled`   | Enable Web Vault                                                                                            | `true`               |


### Security settings

| Name                 | Description                                                                     | Value         |
| -------------------- | ------------------------------------------------------------------------------- | ------------- |
| `adminToken`         | The admin token used for /admin                                                 | `""`          |
| `signupsAllowed`     | By default, anyone who can access your instance can register for a new account. | `true`        |
| `invitationsAllowed` | Even when registration is disabled, organization administrators or owners can   | `true`        |
| `signupDomains`      | List of domain names for users allowed to register                              | `example.com` |
| `signupsVerify`      | Whether to require account verification for newly-registered users.             | `true`        |
| `showPassHint`       | Whether a password hint should be shown in the page.                            | `false`       |
| `command`            | Override default container command (useful when using custom images)            | `[]`          |
| `args`               | Override default container args (useful when using custom images)               | `[]`          |
| `extraEnvVars`       | Extra environment variables to be set on vaultwarden container                  | `[]`          |
| `extraEnvVarsCM`     | Name of existing ConfigMap containing extra env vars                            | `""`          |
| `extraEnvVarsSecret` | Name of existing Secret containing extra env vars                               | `""`          |


### vaultwarden statefulset parameters

| Name                                    | Description                                                                                                              | Value               |
| --------------------------------------- | ------------------------------------------------------------------------------------------------------------------------ | ------------------- |
| `replicaCount`                          | Number of vaultwarden replicas to deploy                                                                                 | `1`                 |
| `containerPorts.http`                   | vaultwarden HTTP container port                                                                                          | `8080`              |
| `extraContainerPorts`                   | Optionally specify extra list of additional port-mappings for vaultwarden container                                      | `[]`                |
| `podSecurityContext.enabled`            | Enabled vaultwarden pods' Security Context                                                                               | `true`              |
| `podSecurityContext.fsGroup`            | Set vaultwarden pod's Security Context fsGroup                                                                           | `1000`              |
| `containerSecurityContext.enabled`      | Enabled vaultwarden containers' Security Context                                                                         | `true`              |
| `containerSecurityContext.runAsUser`    | Set vaultwarden container's Security Context runAsUser                                                                   | `1000`              |
| `containerSecurityContext.runAsNonRoot` | Set vaultwarden container's Security Context runAsNonRoot                                                                | `true`              |
| `resources.limits`                      | The resources limits for the vaultwarden containers                                                                      | `{}`                |
| `resources.requests`                    | The requested resources for the vaultwarden containers                                                                   | `{}`                |
| `livenessProbe.enabled`                 | Enable livenessProbe on vaultwarden containers                                                                           | `false`             |
| `livenessProbe.initialDelaySeconds`     | Initial delay seconds for livenessProbe                                                                                  | `300`               |
| `livenessProbe.periodSeconds`           | Period seconds for livenessProbe                                                                                         | `1`                 |
| `livenessProbe.timeoutSeconds`          | Timeout seconds for livenessProbe                                                                                        | `5`                 |
| `livenessProbe.failureThreshold`        | Failure threshold for livenessProbe                                                                                      | `3`                 |
| `livenessProbe.successThreshold`        | Success threshold for livenessProbe                                                                                      | `1`                 |
| `readinessProbe.enabled`                | Enable readinessProbe on vaultwarden containers                                                                          | `false`             |
| `readinessProbe.initialDelaySeconds`    | Initial delay seconds for readinessProbe                                                                                 | `30`                |
| `readinessProbe.periodSeconds`          | Period seconds for readinessProbe                                                                                        | `10`                |
| `readinessProbe.timeoutSeconds`         | Timeout seconds for readinessProbe                                                                                       | `1`                 |
| `readinessProbe.failureThreshold`       | Failure threshold for readinessProbe                                                                                     | `3`                 |
| `readinessProbe.successThreshold`       | Success threshold for readinessProbe                                                                                     | `1`                 |
| `startupProbe.enabled`                  | Enable startupProbe on vaultwarden containers                                                                            | `false`             |
| `startupProbe.initialDelaySeconds`      | Initial delay seconds for startupProbe                                                                                   | `30`                |
| `startupProbe.periodSeconds`            | Period seconds for startupProbe                                                                                          | `5`                 |
| `startupProbe.timeoutSeconds`           | Timeout seconds for startupProbe                                                                                         | `1`                 |
| `startupProbe.failureThreshold`         | Failure threshold for startupProbe                                                                                       | `60`                |
| `startupProbe.successThreshold`         | Success threshold for startupProbe                                                                                       | `1`                 |
| `customLivenessProbe`                   | Custom Liveness probes for vaultwarden                                                                                   | `{}`                |
| `customReadinessProbe`                  | Custom Rediness probes vaultwarden                                                                                       | `{}`                |
| `customStartupProbe`                    | Custom Startup probes for vaultwarden                                                                                    | `{}`                |
| `lifecycleHooks`                        | LifecycleHooks to set additional configuration at startup                                                                | `{}`                |
| `hostAliases`                           | Deployment pod host aliases                                                                                              | `[]`                |
| `podLabels`                             | Extra labels for vaultwarden pods                                                                                        | `{}`                |
| `podAnnotations`                        | Annotations for vaultwarden pods                                                                                         | `{}`                |
| `podAffinityPreset`                     | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                      | `""`                |
| `podAntiAffinityPreset`                 | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                 | `soft`              |
| `nodeAffinityPreset.type`               | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard`                                | `""`                |
| `nodeAffinityPreset.key`                | Node label key to match. Ignored if `affinity` is set.                                                                   | `""`                |
| `nodeAffinityPreset.values`             | Node label values to match. Ignored if `affinity` is set.                                                                | `[]`                |
| `affinity`                              | Affinity for pod assignment                                                                                              | `{}`                |
| `nodeSelector`                          | Node labels for pod assignment                                                                                           | `{}`                |
| `tolerations`                           | Tolerations for pod assignment                                                                                           | `[]`                |
| `topologySpreadConstraints`             | Topology Spread Constraints for pod assignment spread across your cluster among failure-domains. Evaluated as a template | `[]`                |
| `podManagementPolicy`                   | Pod management policy for the vaultwarden statefulset                                                                    | `Parallel`          |
| `priorityClassName`                     | vaultwarden pods' Priority Class Name                                                                                    | `""`                |
| `schedulerName`                         | Use an alternate scheduler, e.g. "stork".                                                                                | `""`                |
| `terminationGracePeriodSeconds`         | Seconds vaultwarden pod needs to terminate gracefully                                                                    | `""`                |
| `updateStrategy.type`                   | vaultwarden statefulset strategy type                                                                                    | `RollingUpdate`     |
| `updateStrategy.rollingUpdate`          | vaultwarden statefulset rolling update configuration parameters                                                          | `{}`                |
| `extraVolumes`                          | Optionally specify extra list of additional volumes for vaultwarden pods                                                 | `[]`                |
| `extraVolumeMounts`                     | Optionally specify extra list of additional volumeMounts for vaultwarden container(s)                                    | `[]`                |
| `initContainers`                        | Add additional init containers to the vaultwarden pods                                                                   | `[]`                |
| `sidecars`                              | Add additional sidecar containers to the vaultwarden pods                                                                | `[]`                |
| `persistence.enabled`                   | Enable persistence                                                                                                       | `true`              |
| `persistence.storageClass`              | data Persistent Volume Storage Class                                                                                     | `""`                |
| `persistence.existingClaim`             | Provide an existing `PersistentVolumeClaim`                                                                              | `""`                |
| `persistence.accessModes`               | Persistent Volume access modes                                                                                           | `["ReadWriteOnce"]` |
| `persistence.size`                      | Size for the PV                                                                                                          | `10Gi`              |
| `persistence.annotations`               | Persistent Volume Claim annotations                                                                                      | `{}`                |
| `persistence.subPath`                   | The subdirectory of the volume to mount to, useful in dev environments and one PV for multiple services                  | `""`                |
| `persistence.selector`                  | Selector to match an existing Persistent Volume for WordPress data PVC                                                   | `{}`                |
| `persistence.dataSource`                | Custom PVC data source                                                                                                   | `{}`                |


### Exposure parameters

| Name                               | Description                                                                                                                      | Value                    |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| `service.type`                     | Kubernetes service type                                                                                                          | `ClusterIP`              |
| `service.ports.http`               | vaultwarden service HTTP port                                                                                                    | `8080`                   |
| `service.nodePorts`                | Specify the nodePort values for the LoadBalancer and NodePort service types.                                                     | `{}`                     |
| `service.sessionAffinity`          | Control where client requests go, to the same pod or round-robin                                                                 | `None`                   |
| `service.sessionAffinityConfig`    | Additional settings for the sessionAffinity                                                                                      | `{}`                     |
| `service.clusterIP`                | vaultwarden service clusterIP IP                                                                                                 | `""`                     |
| `service.loadBalancerIP`           | loadBalancerIP for the SuiteCRM Service (optional, cloud specific)                                                               | `""`                     |
| `service.loadBalancerSourceRanges` | Address that are allowed when service is LoadBalancer                                                                            | `[]`                     |
| `service.externalTrafficPolicy`    | Enable client source IP preservation                                                                                             | `Cluster`                |
| `service.annotations`              | Additional custom annotations for vaultwarden service                                                                            | `{}`                     |
| `service.extraPorts`               | Extra port to expose on vaultwarden service                                                                                      | `[]`                     |
| `service.extraHeadlessPorts`       | Extra ports to expose on vaultwarden headless service                                                                            | `[]`                     |
| `ingress.enabled`                  | Enable ingress record generation for vaultwarden                                                                                 | `false`                  |
| `ingress.ingressClassName`         | IngressClass that will be be used to implement the Ingress (Kubernetes 1.18+)                                                    | `""`                     |
| `ingress.pathType`                 | Ingress path type                                                                                                                | `ImplementationSpecific` |
| `ingress.apiVersion`               | Force Ingress API version (automatically detected if not set)                                                                    | `""`                     |
| `ingress.hostname`                 | Default host for the ingress record (evaluated as template)                                                                      | `vaultwarden.local`      |
| `ingress.path`                     | Default path for the ingress record                                                                                              | `/`                      |
| `ingress.servicePort`              | Backend service port to use                                                                                                      | `http`                   |
| `ingress.annotations`              | Additional annotations for the Ingress resource. To enable certificate autogeneration, place here your cert-manager annotations. | `{}`                     |
| `ingress.tls`                      | Enable TLS configuration for the host defined at `ingress.hostname` parameter                                                    | `false`                  |
| `ingress.selfSigned`               | Create a TLS secret for this ingress record using self-signed certificates generated by Helm                                     | `false`                  |
| `ingress.extraHosts`               | An array with additional hostname(s) to be covered with the ingress record                                                       | `[]`                     |
| `ingress.extraPaths`               | Any additional arbitrary paths that may need to be added to the ingress under the main host.                                     | `[]`                     |
| `ingress.extraTls`                 | The tls configuration for additional hostnames to be covered with this ingress record.                                           | `[]`                     |
| `ingress.secrets`                  | If you're providing your own certificates, please use this to add the certificates as secrets                                    | `[]`                     |
| `ingress.extraRules`               | Additional rules to be covered with this ingress record                                                                          | `[]`                     |
| `ingress.nginxAllowList`           | Comma-separated list of IP addresses and subnets to allow.                                                                       | `""`                     |


### RBAC parameter

| Name                                          | Description                                                  | Value   |
| --------------------------------------------- | ------------------------------------------------------------ | ------- |
| `serviceAccount.create`                       | Enable the creation of a ServiceAccount for vaultwarden pods | `true`  |
| `serviceAccount.name`                         | Name of the created ServiceAccount                           | `""`    |
| `serviceAccount.automountServiceAccountToken` | Auto-mount the service account token in the pod              | `false` |
| `serviceAccount.annotations`                  | Additional custom annotations for the ServiceAccount         | `{}`    |


### Database Configuration

| Name            | Description                                 | Value        |
| --------------- | ------------------------------------------- | ------------ |
| `database.type` | Database type, either default or postgresql | `postgresql` |


### Database parameters

| Name                                         | Description                                                             | Value                 |
| -------------------------------------------- | ----------------------------------------------------------------------- | --------------------- |
| `postgresql.enabled`                         | Switch to enable or disable the PostgreSQL helm chart                   | `true`                |
| `postgresql.auth.username`                   | Name for a custom user to create                                        | `bn_vaultwarden`      |
| `postgresql.auth.password`                   | Password for the custom user to create                                  | `""`                  |
| `postgresql.auth.database`                   | Name for a custom database to create                                    | `bitnami_vaultwarden` |
| `postgresql.auth.existingSecret`             | Name of existing secret to use for PostgreSQL credentials               | `""`                  |
| `postgresql.architecture`                    | PostgreSQL architecture (`standalone` or `replication`)                 | `standalone`          |
| `externalDatabase.host`                      | Database host                                                           | `""`                  |
| `externalDatabase.port`                      | Database port number                                                    | `5432`                |
| `externalDatabase.user`                      | Non-root username for vaultwarden                                       | `bn_vaultwarden`      |
| `externalDatabase.password`                  | Password for the non-root username for vaultwarden                      | `""`                  |
| `externalDatabase.database`                  | vaultwarden database name                                               | `bitnami_vaultwarden` |
| `externalDatabase.existingSecret`            | Name of an existing secret resource containing the database credentials | `""`                  |
| `externalDatabase.existingSecretPasswordKey` | Name of an existing secret key containing the database credentials      | `""`                  |


### SMTP Configuration

| Name                          | Description                           | Value      |
| ----------------------------- | ------------------------------------- | ---------- |
| `smtp.host`                   | SMTP host                             | `""`       |
| `smtp.security`               | SMTP Encryption method                | `starttls` |
| `smtp.port`                   | SMTP port                             | `587`      |
| `smtp.from`                   | SMTP sender email address             | `""`       |
| `smtp.username`               | Username for the SMTP authentication. | `""`       |
| `smtp.password`               | Password for the SMTP service.        | `""`       |
| `smtp.authMechanism`          | SMTP authentication mechanism         | `Login`    |
| `smtp.acceptInvalidHostnames` | Accept Invalid Hostnames              | `false`    |
| `smtp.acceptInvalidCerts`     | Accept Invalid Certificates           | `false`    |
| `smtp.debug`                  | SMTP debugging                        | `false`    |

## License

[MIT](./LICENSE).

## Author

This Helm chart was created and is being maintained by @captnbp.

### Credits

- The `vaultwarden` project can be found [here](https://github.com/dani-garcia/vaultwarden)
- Further information about `Bitwarden` and 8bit Solutions LLC can be found [here](https://bitwarden.com/)
