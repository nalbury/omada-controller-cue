# omada-controller-cue

Cue configs for running the omada controller container as a stateful set in kube.

Deploys:

➜  omada-controller-cue git:(main) cue ls              
Kind          App                Name
Service       omada-controller   omada-controller-web
Service       omada-controller   omada-controller-tcp
Service       omada-controller   omada-controller-udp
StatefulSet   omada-controller   omada-controller
Ingress       omada-controller   omada-controller-web


## Usage

`cue print` will dump all the raw YAML to stdout for inspection or deployment, for example:

```
cue print |kubectl apply -n omada-controller -f -
```
