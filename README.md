# CTF-Infra

A walkthrough of the Blue Team Village's CTF contest infrastructure. _If you came here looking for the answers sorry._

## Purpose

This project started as the system configuration for [Blue Team Village][btv]'s [DefCon32][defcon] Capture the Flag event.

**We needed to build a system that even after poking a few intentional holes in the services hosted within our Kubernetes Cluster, still allowed us thorough insight into how the system had been compromised and what the attacker had done after gaining access.**

For more information on the CTF event itself, feel free to join the [Blue Team Village Discord][btv-discord].

This repository represents the culmination of that work, so that others can replicate it within their own organizations in order to secure their systems as they either expand their Kubernetes footprint or start using it for the first time.

## Related Technologies

|   Tool   | Purpose                                              |                                    Links |
| :------: | :--------------------------------------------------- | ---------------------------------------: |
|  Cilium  | e-BPF Container Network Interface                    | [Site][cilium site], [Docs][cilium docs] |
| Tetragon | e-BPF Security observability and runtime enforcement |                    [Docs][tetragon docs] |

| Local Tools | Purpose                                                          |                                       Link |
| :---------: | :--------------------------------------------------------------- | -----------------------------------------: |
|   AWS CLI   | AWS Authentication and connecting to the created cluster         | [Site][aws cli site], [Docs][aws cli docs] |
|   eksctl    | Initial cluster creation                                         |                        [Docs][eksctl docs] |
|   kubectl   | Kubernetes CLI                                                   |                       [Docs][kubectl docs] |
|     k9s     | (Optional) Kubernetes CLI wrapper, improves usability of kubectl |                           [Docs][k9s docs] |
|     helm     | Kubernetes package manager |                           [Docs][helm site] |

## Guide

The guide leverages the [Makefile][repo-makefile] in this repository to simplify how the commands are being presented. The Makefile is in order of the commands being run, to get an in-depth walkthrough of the setup go ahead and checkout the [Guide][repo-guide].

## Known limitations

The project was primarily put together by a small team and thus there are few limitations to be aware of if you chose to follow in its footsteps.

- **Clouds** - The implementation here is not explicitly AWS based, since most of the configuration resides within Kubernetes itself with non-specific resources, it has however not been tested on providers besides [EKS][eks].
- **Autoscaling** - Ideally [Karpenter][karpenter] or another cluster autoscaler would be implemented on the cluster so that as more nodes are required the cluster scales up without manual intervention. This was skipped during the initial implementation due to time constraints.
- **Continuous Deployment** - The implementation here is done with a series of manually run commands. In a long term production environment, it is recommended that these kinds of actions are managed by automation. This was skipped since the cluster we were working on, we knew had an expiration date and speed of operations was a higher priority than a fully functioning
  - Using [ArgoCD][argocd docs] to manage the cluster's deployments would provide some more generalized observability and change tracking with [GitOps][what is gitops], especially if regularly updated services are going to be included in the cluster.
- **Infrastructure as Code (IaC)** - While this repository is arguably Infrastructure as Code, a series of Makefile scripts does not maintain state like [Terraform][terraform site] or reconcile to correct drift like [Crossplane][crossplane site], making infrastructure created in this way vulnerable to impatient engineers changing things in a cloud provider's UI.
  - In an organization where clusters are being created frequently, or across different cloud providers, a tool like [ClusterAPI][cluster api docs] could prove useful as well.

<!-- LINKS -->

[btv]: https://blueteamvillage.org/
[defcon]: https://defcon.org/
[btv-discord]: https://discord.gg/DnJTCZcT
[repo-makefile]: ./Makefile
[repo-guide]: ./GUIDE.md
[kubernetes node taints]: https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/
[karpenter]: https://karpenter.sh/
[eks]: https://aws.amazon.com/eks/
[aws cli site]: https://aws.amazon.com/cli/
[aws cli docs]: https://awscli.amazonaws.com/v2/documentation/api/latest/reference/index.html
[eksctl docs]: https://eksctl.io/getting-started/
[cilium site]: https://cilium.io/
[cilium docs]: https://docs.cilium.io/en/stable/
[tetragon docs]: https://tetragon.io/docs/
[kubectl docs]: https://kubernetes.io/docs/tasks/tools/
[k9s docs]: https://k9scli.io/
[argocd docs]: https://argo-cd.readthedocs.io/en/stable/
[cluster api docs]: https://cluster-api.sigs.k8s.io/
[what is gitops]: https://about.gitlab.com/topics/gitops/
[terraform site]: https://www.terraform.io/
[crossplane site]: https://www.crossplane.io/
[helm site]: https://helm.sh/