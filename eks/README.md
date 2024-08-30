
### Create the Kubernetes Cluster
`make eks-cluster-create`

The initial cluster setup closely resembles the [Cilium Quick Start guide][cilium quick start] if you'd rather start there, we'll highlight any differences here. Note that this guide will be using [Helm][helm site] instead of the cilium cli, more information in the [Install Cilium](#install-cilium).

Compared to Cilium Quick Start:
* We assign a `desiredCapacity` of `3` instead of `2`
    * We run a few services with 3 replicas that dictated this change, more on those below.
* The quick start guide does not set a `instanceType` (so they use the default size of `m5.large`), we ended up bumping to `m5.xlarge`
    * We wanted to have a few more Pods per Node, for more information check out [this page from AWS on instance sizea][amazon ec2 instance types].
* We were explicit in our setting of a `minSize` (3) and `maxSize` (4) instead of relying on defaults

### Connect to Cluster
`make eks-cluster-kubeconfig`

With the cluster up and running the next thing we need to do is update our local [kubeconfig][kubeconfig docs], so we can connect to the cluster when we use `kubectl` (and `k9s` if you choose to).

### Install Cilium

_life has gotten busy, so in order to push to get the code out there, the guides will not be as detailed as above and the [Kind](../kind/README.md) guide has been prioritized, expect updates in the future to this guide so that it is completed_

<!-- LINKS -->
[cilium quick start]: https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/
[amazon ec2 instance types]: https://aws.amazon.com/ec2/instance-types/
[kubeconfig docs]: https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/
[helm site]: https://helm.sh/