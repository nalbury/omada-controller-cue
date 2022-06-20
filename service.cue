package omadaController

import (
	corev1 "k8s.io/api/core/v1"
	"strconv"
)

service: [string]: corev1.#Service

#servicePortsWeb: [
	for _, p in #webPorts {
		port:       p.containerPort
		protocol:   "TCP"
		name:       *p.name | strconv.FormatInt(p.containerPort, 10)
		targetPort: *p.name | p.containerPort
	},
]

#servicePortsTcp: [
	for _, p in #ports if p.protocol != "UDP" {
		port:       p.containerPort
		protocol:   "TCP"
		name:       *p.name | strconv.FormatInt(p.containerPort, 10)
		targetPort: *p.name | p.containerPort
	},
]

#servicePortsUdp: [
	for _, p in #ports if p.protocol == "UDP" {
		port:       p.containerPort
		protocol:   "UDP"
		name:       *p.name | strconv.FormatInt(p.containerPort, 10)
		targetPort: *p.name | p.containerPort
	},
]

service: "omada-controller-web": {
	apiVersion: "v1"
	kind:       "Service"
	metadata:   #metadata & {
		name: "omada-controller-web"
	}
	spec: {
		type:     "ClusterIP"
		ports:    #servicePortsWeb
		selector: #selector
	}
}

service: "omada-controller-tcp": {
	apiVersion: "v1"
	kind:       "Service"
	metadata:   #metadata
	spec: {
		type:     "LoadBalancer"
		ports:    #servicePortsTcp
		selector: #selector
	}
}

service: "omada-controller-udp": {
	apiVersion: "v1"
	kind:       "Service"
	metadata:   #metadata & {
		name: "omada-controller-udp"
	}
	spec: {
		type:     "LoadBalancer"
		ports:    #servicePortsUdp
		selector: #selector
	}
}
