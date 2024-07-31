
### Create the Kubernetes Cluster
`make eks-cluster-create`

The initial cluster setup closely resembles the [Cilium Quick Start guide][cilium quick start] if you'd rather start there, we'll highlight any differences here.

Compared to Cilium Quick Start:
* We assign a `desiredCapacity` of `3` instead of `2`
    * We run a few services with 3 replicas that dictated this change, more on those below.
* The quick start guide does not set a `instanceType` (so they use the default size of `m5.large`), we ended up bumping to `m5.xlarge`
    * We wanted to have a few more Pods per Node, for more information check out [this page from AWS on instance sizea][amazon ec2 instance types].
* We were explicit in our setting of a `minSize` (3) and `maxSize` (4) instead of relying on defaults

### Connect to Cluster
`make eks-cluster-kubeconfig`


<!-- ### Install Cilium -->



<!-- LINKS -->
[cilium quick start]: https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/
[amazon ec2 instance types]: https://aws.amazon.com/ec2/instance-types/