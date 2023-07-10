package omadaController

import (
	networkingv1 "k8s.io/api/networking/v1"
)

ingress: [string]: networkingv1.#Ingress

let defaultHostName = "omada.nickalbury.pizza"
let omadaService = service."omada-controller-web"

#rules: [
	networkingv1.#IngressRule & {
		host: string | *defaultHostName
		http: {
			paths: [
				{
					path:     "/"
					pathType: "Prefix"
					backend: {
						service: {
							name: omadaService.metadata.name
							port: name: string | *"managehttps"
						}
					}
				},
			]
		}
	},
]

ingress: "omada-controller-web": {
	apiVersion: "networking.k8s.io/v1"
	kind:       "Ingress"
	metadata:   #metadata & {
		name: "omada-controller-web"
		annotations: {
			"traefik.ingress.kubernetes.io/router.tls":                "true"
			"traefik.ingress.kubernetes.io/router.tls.certresolver":   "pizzaResolver"
			"traefik.ingress.kubernetes.io/router.tls.domains.0.main": string | *defaultHostName
		}
	}
	spec: {
		ingressClassName?: string
		rules:             #rules
	}
}
