package omadaController

import corev1 "k8s.io/api/core/v1"

#defaultName: "omada-controller"

#selector: {
	app: string | *#defaultName
}

#labels: {
	#selector
	...
}

#metadata: {
	name:       string | *#defaultName
	namespace?: string
	labels:     #labels
	annotations?: [string]: string
}

#port: corev1.#ContainerPort & {
	protocol: string | *"TCP"
}

#webPorts: [
	#port & {
		containerPort: 80
		name:          "http"
	},
	#port & {
		containerPort: 443
		name:          "managehttps"
	},
	#port & {
		containerPort: 8843
		name:          "portalhttps"
	},
]

#ports: [
	#port & {
		containerPort: 29810
		protocol:      "UDP"
	},
	#port & {
		containerPort: 29811
	},
	#port & {
		containerPort: 29812
	},
	#port & {
		containerPort: 29813
	},
	#port & {
		containerPort: 29814
	},
]
