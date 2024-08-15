
## Create the Kubernetes Cluster
### `make eks-cluster-create`

Tools: `eksctl`, `envsubst`, `aws cli`
<!-- todo add links -->

The easiest way to create a cluster progammatically in EKS is with [eksctl][eksctl docs]. The initial cluster config closely resembles the one from the [Cilium Quick Start guide][cilium quick start], but there are a few differences.

Compared to Cilium Quick Start:
* We assign a `desiredCapacity` of `3` instead of `2`, because we run a few services (Opensearch) with 3 replicas that dictated this change, more on that later.
* The quick start guide does not set a `instanceType` so they use the default size from eksctl `m5.large`, we ended up bumping to `m5.xlarge` because we wanted to have more Pods per Node, instead of more nodes at a lower cost per ndoe, for more information check out [this page from AWS on instance sizea][amazon ec2 instance types] to make your own judgements.
* We were explicit in our setting of a `minSize` (3) and `maxSize` (4) instead of relying on defaults

## Connect to Cluster
### `make eks-cluster-kubeconfig`

With the cluster up and running the next thing we need to do is update our local [kubeconfig][kubeconfig docs], so we can connect to the cluster when we use `kubectl` (and `k9s` if you choose to).

With you should be able to run kubectl commands, like `kubectl get pods --all-namespaces` to see what's already there. CoreDNS and potentially a few other Pods will be in the `Pending` state within the `kube-system` namespace.

The Pods will remain in the `Pending` state till Cilium is installed and its agent starts on each Node, this is because of the [Kubernetes Node Taint] `NoExecute` we included when we created the Cluster.

```shell
# Example
% kubectl get pods --all-namespaces
NAMESPACE     NAME                       READY   STATUS    RESTARTS   AGE
kube-system   coredns-5b8cc885bc-r65xs   0/1     Pending   0          9m7s
kube-system   coredns-5b8cc885bc-rxps6   0/1     Pending   0          9m7s
```

## Install Cilium

### `make eks-transition-cni`

Now that we're connected to the cluster, we can start managing its resources from our local machine. The first thing to do, as brought up in the [Cilium guide][cilium quick start], is to patch the [Daemonset] for EKS's default Cluster Network Interface (CNI) plugin.

Functionally, what we are doing is making sure that [AWS's CNI][eks default cni] does not conflict with signCilium. Without this we could end up in a situation where both CNIs attempt manage the networking for a Cluster Node.

### `make helm-cilium-setup`

The [Cilium Quick Start guide][cilium quick start] recommends that people install Cilium using their cli, which will produce a fully functioning installation, but for this guide we are going to install Cilium directly using Helm. Doing the installation with Helm means we can leverage the [Chart's values][cilium chart] to have more direct control over how Cilium is configured.


Before installing though, the first thing to do when using a new Helm Chart is [register the Chart Repository][helm repo add] in your local Helm config.

### `make helm-cilium-upgrade`





<!-- LINKS -->
[cilium quick start]: https://docs.cilium.io/en/stable/gettingstarted/k8s-install-default/
[amazon ec2 instance types]: https://aws.amazon.com/ec2/instance-types/
[kubeconfig docs]: https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/
[helm site]: https://helm.sh/
[eksctl docs]: https://eksctl.io/getting-started/
[helm repo add]: https://helm.sh/docs/helm/helm_repo_add/
[Kubernetes Node Taint]: https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/
[IaC]: https://www.redhat.com/en/topics/automation/what-is-infrastructure-as-code-iac
[Daemonset]: https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/
[eks default cni]: https://docs.aws.amazon.com/eks/latest/userguide/managing-vpc-cni.html
[cilium chart]: https://github.com/cilium/cilium/tree/v1.16.0/install/kubernetes/cilium