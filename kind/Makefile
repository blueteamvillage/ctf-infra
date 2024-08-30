CLUSTER_NAME := btv-dc32
CILIUM_VERSION := 1.16.1

kind-cluster-create:
	kind create cluster --name ${CLUSTER_NAME} --config=kind-config.yaml

kind-cluster-delete:
	kind delete cluster --name ${CLUSTER_NAME}

helm-repos:
	helm repo add cilium https://helm.cilium.io/

# Cilium Actions
cilium-helm-install:
	helm upgrade --install cilium cilium/cilium --version ${CILIUM_VERSION} \
	--namespace kube-system \
	--values ../supporting-files/cilium.yaml \
	--set hubble.metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,httpV2:exemplars=true;labelsContext=source_ip\,source_namespace\,source_workload\,destination_ip\,destination_namespace\,destination_workload\,traffic_direction}"
	
	echo "\n=====\nWhen the cilium pods are all in the running state you can cancel the watch and continue...\n=====\n"
	
	kubectl -n kube-system get pods --watch

# In the frontend container the frontend is hosted on port 8081 but when targeting the
# service we need to target the port described in the service (port 80 -> target port 8081)
cilium-hubble-ui:
	open http://localhost:8081 
	kubectl port-forward service/hubble-ui -n kube-system 8081:80

cilium-test:
	kubectl create namespace cilium-test --dry-run=client -o yaml | kubectl apply -f -
	kubectl apply -n cilium-test -f ../supporting-files/cilium-test.yaml

cilium-test-delete:
	kubectl delete namespace cilium-test

