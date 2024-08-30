_There will be a circling back to provide more detail, but there's been quite a bit of interest so we're pushing forward with the cleaned up configuration and minimal instructions. Thank you for your patience_

## Kind Guide

This guide is here to walk you through the commands being run to setup the environment in a local kind cluster. 

Steps:

1. `make kind-cluster-create`

2. `make helm-repos`

3. `make cilium-helm-install`

4. (Optional) `make cilium-test` (cleanup `make cilium-test-delete`)
* If all the pods enter the `Running` state, things are all working as expected. 
* If you port forward the hubble ui (`make cilium-hubble-ui`), you will see the pods and connections build up as the tests are started. 
![hubble ui during cilium-test](cilium-test-hubble.png)

Alternatively you can run `cilium connectivity test` if you have installed the Cilium cli, note that you will need to clean up the resources at the end of the connectivity test as well. 

5. 
