CLUSTER_NAME := btv-dc32

#################################################
# Kind
kind-cluster-create:
	kind create cluster --name ${CLUSTER_NAME} --config=kind-config.yaml

kind-cluster-delete:
	kind delete cluster --name ${CLUSTER_NAME}

#################################################
# Helm
helm-repos:
	helm repo add cilium https://helm.cilium.io/

#################################################
# Cilium Actions
CILIUM_VERSION := 1.16.1

cilium-helm-install:
	helm upgrade --install cilium cilium/cilium --version ${CILIUM_VERSION} \
	--namespace kube-system \
	--values ../supporting-files/cilium.yaml \
	--set hubble.metrics.enabled="{dns,drop,tcp,flow,port-distribution,icmp,httpV2:exemplars=true;labelsContext=source_ip\,source_namespace\,source_workload\,destination_ip\,destination_namespace\,destination_workload\,traffic_direction}"

	kubectl rollout status -n kube-system ds/cilium -w

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

#################################################
# Tetragon Actions
TETRAGON_VERSION := 1.1.2

tetragon-helm-install:
	helm upgrade --install tetragon cilium/tetragon --version ${TETRAGON_VERSION} \
	--namespace kube-system \
	--values ../supporting-files/tetragon.yaml

	kubectl rollout status -n kube-system ds/tetragon -w

### Tetragon as a Pod runs with 2 containers and processes are logged in the "export-stdout" container (the "tetragon" container does management of the functionality)
tetragon-logs:
	kubectl logs -f -n kube-system ds/tetragon -c export-stdout

#################################################
# Alpine debug pod
DEBUG_NAMESPACE := default

## These commands are to help pick the Tetragon daemonset pod that is running on the same Kubernetes node as the alpine pod
#### First we need to pick out the pod, since the deployment will generate a semi-random name for it (we could have created a Pod directly, but this is a more realistic scenario)
ALPINE_POD_NAME := $(shell kubectl get pods -o=jsonpath='{.items[0].metadata.name}' -n ${DEBUG_NAMESPACE} --selector=app=debug --field-selector=status.phase=Running)
#### Now that we know the name of the Alpine debugging pod, we can fetch the node that it is running on
NODE_NAME := $(shell kubectl get pod ${ALPINE_POD_NAME} -o=jsonpath='{.spec.nodeName}' -n ${DEBUG_NAMESPACE})
#### With the node name we can look for the pod with the tetragon label that was assigned when we deployed it as apart of the Tetragon helm chart
#### and we also filter the pods based on the node name which should give us just a single result
TETRAGON_POD := $(shell kubectl get pods -n kube-system -l app.kubernetes.io/name=tetragon -o=jsonpath='{range .items[?(@.spec.nodeName=="'${NODE_NAME}'")]}{.metadata.name}{"\n"}{end}')
#### We do this since the Tetragon pod on each node is responsible for monitoring the other pods on that node. 

#### We could follow all logs on the daemonset as well, as if we do when we execute "make tetragon-logs", 
#### the disadvantage of following the whole daemonset is cognitive overload as we try to find the relevant 
#### pod/container to compare with our activity. 

#### A further refinement could be to pipe the output through a tool like "jq" and further 
#### craft how the output appears to reduce duplicate information across log entries.

alpine-apply:
	kubectl apply -f ../supporting-files/alpine-debug.yaml

alpine-bash:
	kubectl rollout status deploy/debug -w
	kubectl exec --stdin --tty ${ALPINE_POD_NAME}  -- /bin/bash

alpine-tetragon-watch:
	kubectl rollout status deploy/debug -w
	kubectl logs -f -n kube-system ${TETRAGON_POD} -c export-stdout

