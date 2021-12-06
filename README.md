# SPAICER Platform

This project defines a blueprint for a SPACIER platform based on cloud native application bundles.

Service instance providers can use the platform as-is or customize it by adding/removing components or changing the configuration.

## Build
porter build

## Install
To use this bundle, you will need an existing Kubernetes cluster and a kubeconfig file for use as a credential.

##### Generate a Credential
Before installing the bundle, a credential must be generated. To achieve this, the command `porter credentials generate` can be used:

```
porter credentials generate
```

As a result, a guided dialog for building a credential will be launched, which could look like this:

```
Generating new credential spaicer-platform-edge from bundle spaicer-platform-edge
==> 1 credentials required for bundle spaicer-platform-edge
? How would you like to set credential "do_access_token"  [Use arrows to move, space to select, type to filter]
  specific value
  environment variable
> file path
  shell command
```

For the `kubeconfig`, the option `file path` should be selected and the location of the config file should be specified:

```
? How would you like to set credential "kubeconfig"  [Use arrows to move, space to select, type to filter]
  specific value
  environment variable
> file path
  shell command
Enter the path that will be used to set credential "kubeconfig" $HOME/.kube/config
```

As a result, a credential named like the bundle is created. 

##### Install the platform

To install the platform, the `porter install` command can be used. At this point, value for several parameters must be specified:

```
porter install --tag spaicer/spaicer:v0.0.1 -c spaicer-credentials --param namespace=<SOME VALUE> --param helm_release=<SOME VALUE>
```

Example

```
porter install -c spaicer-platform-edge --param namespace=spaicer-platform --param helm_release=spaicer.py1agu99yn.shoot.canary.k8s-hana.ondemand.com
```

Also execute the command `helm dependency update` from within the umbrella chart directory to avoid errors such as `Error: found in Chart.yaml, but missing in charts/ directory: ingress-nginx, dataspaceconnector-v6.4.0`
