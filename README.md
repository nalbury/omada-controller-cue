# omada-controller-cue

Cue configs for running the omada controller container as a stateful set in kube.

Deploys:

- A statefulset with two PVCs for data/log mounts
- 3 Kube services
  - LoadBalancer svc for TCP ports
  - LoadBalancer svc for UDP ports
  - ClusterIP svc for HTTP ports
- An ingress pointed at the HTTP ClusterIP svc

## Usage

```
cue print |kubectl apply -f
```
