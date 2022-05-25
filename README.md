# Elastiflow

[Elastiflow](https://elastiflow.com) is a closed-source network flow collector and enrichment engine

## TL;DR

```console
git clone https://github.com/imc-network/elastiflow-helm; cd elastiflow-helm
helm install my-release .
```

## Introduction

This chart was created from the template provided by [Bitnami](https://github.com/bitnami/charts/tree/master/template).
It bootstraps a Elastiflow deployment on a Kubernetes cluster using Helm

## Scaling and limitations

Please note that the current (5.4.1) release of Elastiflow does not have a shared cache.  You should not scale the
deployment past a single pod unless you are using a proxy mode that supports deterministic hashing (IPVS or eBPF), so
that devices that send IPFIX templates only send their flow records to the collector that received the template.

If your flow records are being generated outside the kubernetes cluster, be aware of the effect of SNAT on the
records being ingressed.  While sFlow stores the collector address in the record itself, IPFIX and NetFlow use
the source IP of the UDP packet to determine the collector.  Refer to the documentation for your provider for
methods of preserving source address if necessary (eBPF, externalTrafficPolicy, etc)

An Ingress template is not included with this chart, as UDP Ingresses are not directly supported by Kubernetes.
Consider using an ingress controller that supports custom UDP Ingress like
[Nginx](https://kubernetes.github.io/ingress-nginx/user-guide/exposing-tcp-udp-services/)

## Prerequisites

- Kubernetes 1.12+
- Helm 3.1.0

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release .
```

The command deploys Elastiflow on the Kubernetes cluster in the default configuration.
The [Parameters](#parameters) section lists the parameters that can be configured during installation.

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Global parameters

| Name                      | Description                                     | Value |
| ------------------------- | ----------------------------------------------- | ----- |
| `global.imageRegistry`    | Global Docker image registry                    | `""`  |
| `global.imagePullSecrets` | Global Docker registry secret names as an array | `[]`  |
| `global.storageClass`     | Global StorageClass for Persistent Volume(s)    | `""`  |

### Common parameters

| Name                | Description                                        | Value           |
| ------------------- | -------------------------------------------------- | --------------- |
| `kubeVersion`       | Override Kubernetes version                        | `""`            |
| `nameOverride`      | String to partially override common.names.fullname | `""`            |
| `fullnameOverride`  | String to fully override common.names.fullname     | `""`            |
| `commonLabels`      | Labels to add to all deployed objects              | `{}`            |
| `commonAnnotations` | Annotations to add to all deployed objects         | `{}`            |
| `clusterDomain`     | Kubernetes cluster domain name                     | `cluster.local` |
| `extraDeploy`       | Array of extra objects to deploy with the release  | `[]`            |

### Elastiflow Parameters

| Name                                 | Description                                                                               | Value                       |
| ------------------------------------ | ----------------------------------------------------------------------------------------- | --------------------------- |
| `config`                             | Elastiflow environment variable config                                                    | [See docs](https://docs.Elastiflow.com/docs/config_ref) |
| `image.registry`                     | Elastiflow image registry                                                                 | `docker.io`                 |
| `image.repository`                   | Elastiflow image repository                                                               | `elastiflow/flow-collector` |
| `image.tag`                          | Elastiflow image tag (immutable tags are recommended)                                     | `5.4.1`                     |
| `image.pullPolicy`                   | Elastiflow image pull policy                                                              | `IfNotPresent`              |
| `image.pullSecrets`                  | Elastiflow image pull secrets                                                             | `[]`                        |
| `hostNetwork`                        | Enable/disable host network mode in pod                                                   | `false`                     |
| `replicaCount`                       | Number of Elastiflow replicas to deploy                                                   | `1`                         |
| `containerPorts.elastiflow`          | Elastiflow port                                                                           | `9995`                      |
| `customLivenessProbe`                | Custom livenessProbe that overrides the default one                                       | `{}`                        |
| `customReadinessProbe`               | Custom readinessProbe that overrides the default one                                      | `{}`                        |
| `customStartupProbe`                 | Custom startupProbe that overrides the default one                                        | `{}`                        |
| `resources.limits`                   | The resources limits for the Elastiflow containers                                        | `{}`                        |
| `resources.requests`                 | The requested resources for the Elastiflow containers                                     | `{}`                        |
| `existingConfigmap`                  | The name of an existing ConfigMap with your custom configuration for Elastiflow           | `nil`                       |
| `command`                            | Override default container command (useful when using custom images)                      | `[]`                        |
| `args`                               | Override default container args (useful when using custom images)                         | `[]`                        |
| `hostAliases`                        | Elastiflow pods host aliases                                                              | `[]`                        |
| `podLabels`                          | Extra labels for Elastiflow pods                                                          | `{}`                        |
| `podAnnotations`                     | Annotations for Elastiflow pods                                                           | `{}`                        |
| `podAffinityPreset`                  | Pod affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`       | `""`                        |
| `podAntiAffinityPreset`              | Pod anti-affinity preset. Ignored if `affinity` is set. Allowed values: `soft` or `hard`  | `soft`                      |
| `nodeAffinityPreset.type`            | Node affinity preset type. Ignored if `affinity` is set. Allowed values: `soft` or `hard` | `""`                        |
| `nodeAffinityPreset.key`             | Node label key to match. Ignored if `affinity` is set                                     | `""`                        |
| `nodeAffinityPreset.values`          | Node label values to match. Ignored if `affinity` is set                                  | `[]`                        |
| `affinity`                           | Affinity for Elastiflow pods assignment                                                   | `{}`                        |
| `nodeSelector`                       | Node labels for Elastiflow pods assignment                                                | `{}`                        |
| `tolerations`                        | Tolerations for Elastiflow pods assignment                                                | `[]`                        |
| `updateStrategy.type`                | Elastiflow statefulset strategy type                                                      | `RollingUpdate`             |
| `priorityClassName`                  | Elastiflow pods" priorityClassName                                                        | `""`                        |
| `schedulerName`                      | Name of the k8s scheduler (other than default) for Elastiflow pods                        | `""`                        |
| `lifecycleHooks`                     | for the Elastiflow container(s) to automate configuration before or after startup         | `{}`                        |
| `extraEnvVars`                       | Array with extra environment variables to add to Elastiflow nodes                         | `[]`                        |
| `extraEnvVarsCM`                     | Name of existing ConfigMap containing extra env vars for Elastiflow nodes                 | `nil`                       |
| `extraEnvVarsSecret`                 | Name of existing Secret containing extra env vars for Elastiflow nodes                    | `nil`                       |
| `extraVolumes`                       | Optionally specify extra list of additional volumes for the Elastiflow pod(s)             | `[]`                        |
| `extraVolumeMounts`                  | Optionally specify extra list of additional volumeMounts for the Elastiflow container(s)  | `[]`                        |
| `sidecars`                           | Add additional sidecar containers to the Elastiflow pod(s)                                | `{}`                        |
| `initContainers`                     | Add additional init containers to the Elastiflow pod(s)                                   | `{}`                        |
| `service.type`                       | Elastiflow service type                                                                   | `ClusterIP`                 |
| `service.ports.elastiflow`           | Elastiflow service UDP port                                                               | `9995`                      |
| `service.nodePorts.http`             | Node port for HTTP                                                                        | `nil`                       |
| `service.nodePorts.https`            | Node port for HTTPS                                                                       | `nil`                       |
| `service.clusterIP`                  | Elastiflow service Cluster IP                                                             | `nil`                       |
| `service.loadBalancerIP`             | Elastiflow service Load Balancer IP                                                       | `nil`                       |
| `service.loadBalancerSourceRanges`   | Elastiflow service Load Balancer sources                                                  | `[]`                        |
| `service.externalTrafficPolicy`      | Elastiflow service external traffic policy                                                | `Cluster`                   |
| `service.annotations`                | Additional custom annotations for Elastiflow service                                      | `{}`                        |
| `service.extraPorts`                 | Extra ports to expose in Elastiflow service (normally used with the `sidecars` value)     | `[]`                        |

### Other Parameters

| Name                    | Description                                          | Value   |
| ----------------------- | ---------------------------------------------------- | ------- |
| `rbac.create`           | Specifies whether RBAC resources should be created   | `false` |
| `serviceAccount.create` | Specifies whether a ServiceAccount should be created | `false` |
| `serviceAccount.name`   | The name of the ServiceAccount to use.               | `""`    |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,

```console
helm install my-release \
  --set config.EF_FLOW_ACCOUNT_ID=foo \
  --set config.EF_FLOW_ACCOUNT_KEY=bar \
  . 
```

The above command sets the Elastiflow account ID and license key to `foo` and `bar` respectively.

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml .
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Configuration and installation details

### [Rolling VS Immutable tags](https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/)

It is strongly recommended to use immutable tags in a production environment. This ensures your deployment does not change automatically if the same tag is updated with a different image.

### Additional environment variables

In case you want to add extra environment variables (useful for advanced operations like custom init scripts), you can use the `extraEnvVars` property.

```yaml
extraEnvVars:
  - name: LOG_LEVEL
    value: error
```

Alternatively, you can use a ConfigMap or a Secret with the environment variables. To do so, use the `extraEnvVarsCM` or the `extraEnvVarsSecret` values.

### Sidecars

If additional containers are needed in the same pod as Elastiflow (such as additional metrics or logging exporters), they can be defined using the `sidecars` parameter. If these sidecars export extra ports, extra port definitions can be added using the `service.extraPorts` parameter. [Learn more about configuring and using sidecar containers](https://docs.bitnami.com/kubernetes/apps/Elastiflow/administration/configure-use-sidecars/).

### Pod affinity

This chart allows you to set your custom affinity using the `affinity` parameter. Find more information about Pod affinity in the [kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity).

As an alternative, use one of the preset configurations for pod affinity, pod anti-affinity, and node affinity available at the [bitnami/common](https://github.com/bitnami/charts/tree/master/bitnami/common#affinities) chart. To do so, set the `podAffinityPreset`, `podAntiAffinityPreset`, or `nodeAffinityPreset` parameters.

## Troubleshooting

Find more information about how to deal with common errors related to Bitnami's Helm charts in [this troubleshooting guide](https://docs.bitnami.com/general/how-to/troubleshoot-helm-chart-issues).
