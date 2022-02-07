# SPAICER Platform

This project defines a blueprint for a SPACIER platform based on cloud native application bundles.

Service instance providers can use the platform as-is or customize it by adding/removing components or changing the configuration.

## Getting Started

### Prerequisites

* Install [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
* Install [kubectl](https://kubernetes.io/docs/tasks/tools/)
* Configure access to kubernetes cluster based on [kubeconfig](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/)
* Install [Helm](https://helm.sh/docs/intro/install/)
* Install [porter.sh](https://porter.sh/install/)

### Clone

```
git clone https://github.com/spaicer/spaicer-platform.git
```

### Build

For building the cloud native application bundle execute the following command:

```
porter build
```

### Installation

To use this bundle, you will need an existing Kubernetes cluster and a kubeconfig file for use as a credential.

#### Generate a Credential

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

#### Install the Platform

To install the platform, the `porter install` command can be used. At this point, values for several parameters must be specified:

```
porter install --tag spaicer/spaicer:v0.0.1 -c generated_credential_name  \
--param domain='<CLUSTER DOMAIN>' \
--param github-spaicer-user='<GH USERNAME>' \
--param github-spaicer-token='<GH ACCESS TOKEN>' \
--param oauth_client_id='<OAUTH CLIENT ID>' \
--param oauth_client_secret='<OAUTH CLIENT SECRET>'
```

Also execute the command `helm dependency update` from within the umbrella chart directory to avoid errors such as `Error: found in Chart.yaml, but missing in charts/ directory: ingress-nginx, dataspaceconnector-v6.4.0`

### Customization

#### Kubernetes Namespace

The default namespace used for deploying the SPAICER platform is *spaicerns1*.
Due to the limited possibility of referencing parameters within the Helm values files, the namespace must be specified in several locations within the porter.yaml
and the umbrella chart values.yaml.

### Operations

#### API Gateway

The platform deploys a Kong API Gateway in DB-less mode (as open-source edition, excl. Kong Portal and Kong Manager).

SPAICER AI module API endpoints are integrated as Kong services and exposed as Kong routes.
Services, routes and consumers are maintained in the *kong.dbless.yaml* file of the umbrella chart.
Corresponding [API keys](https://docs.konghq.com/hub/kong-inc/key-auth/) are generated and assigned to consumers (i.e., users) automatically after installation.

Requests to exposed API endpoints must include an api key:

```
curl https://kong-proxy.<namespace>.<domain>:443/<module path>?apikey=<some_key>
```

As Kong is used in the DB-less mode, the [decK](https://docs.konghq.com/deck/) CLI is not really needed.
Nevertheless, decK can be used to query the auto-generated api keys of consumers:

```
deck dump --kong-addr https://kong-admin.<namespace>.<domain>:443
```