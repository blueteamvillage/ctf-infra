CLUSTER_NAME := walkthrough
CLUSTER_VERSION := 1.30

eks-cluster-create:
	export CLUSTER_NAME=${CLUSTER_NAME}
	export CLUSTER_VERSION=${CLUSTER_VERSION}
	cat eksctl-cluster-template.yaml | envsubst  > eksctl-cluster-config.yaml
	eksctl create cluster -f ./eksctl-cluster-config.yaml
	unset CLUSTER_NAME
	unset CLUSTER_VERSION

eks-cluster-kubeconfig:
	aws eks update-kubeconfig --name ${CLUSTER_NAME}

eks-transition-cni:
	kubectl -n kube-system patch daemonset aws-node --type='strategic' -p='{"spec":{"template":{"spec":{"nodeSelector":{"io.cilium/aws-node-enabled":"true"}}}}}'

eks-asdf:
	eksctl utils associate-iam-oidc-provider --cluster ${CLUSTER_NAME} --approve
	aws eks create-addon --cluster-name ${CLUSTER_NAME} --addon-name eks-pod-identity-agent --addon-version v1.2.0-eksbuild.1


CILIUM_VERSION := 1.60.0

helm-cilium-setup:
	helm repo add cilium https://helm.cilium.io/ --force-update
	# We are using "--force-update" so that the command can be run repeatedly without failing
	helm repo update


helm-cilium-initial:
	helm upgrade --install cilium cilium/cilium --version ${CILIUM_VERSION} \
	--namespace kube-system \
	--values values/cilium-initial.yaml
