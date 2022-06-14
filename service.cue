package omadaController

import corev1 "k8s.io/api/core/v1"

service: [string]: corev1.#Service

#servicePorts: [
	for p in #ports {
		port:       p.containerPort
		protocol:   p.protocol | *"TCP"
		targetPort: p.name | *p.containerPort
	},
]

service: "omada-controller": {
	apiVersion: "v1"
	kind:       "Service"
	metadata:   #metadata
	spec: {
		type:     "LoadBalancer"
		ports:    #servicePorts
		selector: #selector
	}
}
