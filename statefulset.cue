package omadaController

import (
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
)

statefulset: [string]: appsv1.#StatefulSet

let defaultImage = "mbently/omada-controller:latest"
let baseMountPath = "/opt/tplink/EAPController"

#ports: [
	corev1.#ContainerPort & {
		containerPort: 8088
		name:          "http"
	},
	corev1.#ContainerPort & {
		containerPort: 8043
		name:          "manageHttps"
	},
	corev1.#ContainerPort & {
		containerPort: 8843
		name:          "portalHttps"
	},
	corev1.#ContainerPort & {
		containerPort: 29810
		protocol:      "UDP"
	},
	corev1.#ContainerPort & {
		containerPort: 29811
	},
	corev1.#ContainerPort & {
		containerPort: 29812
	},
	corev1.#ContainerPort & {
		containerPort: 29813
	},
	corev1.#ContainerPort & {
		containerPort: 29814
	},
]

#envVars: [
	corev1.#EnvVar & {
		name:  "MANAGE_HTTP_PORT"
		value: "8088"
	},
	corev1.#EnvVar & {
		name:  "MANAGE_HTTPS_PORT"
		value: "8043"
	},
	corev1.#EnvVar & {
		name:  "PORTAL_HTTP_PORT"
		value: "8088"
	},
	corev1.#EnvVar & {
		name:  "PORTAL_HTTPS_PORT"
		value: "8843"
	},
	corev1.#EnvVar & {
		name:  "SHOW_SERVER_LOGS"
		value: "true"
	},
	corev1.#EnvVar & {
		name:  "SHOW_MONGODB_LOGS"
		value: "false"
	},
	corev1.#EnvVar & {
		name:  "TZ"
		value: "America/NewYork"
	},
]

#volumeClaimTemplates: [
	corev1.#PersistentVolumeClaim & {
		metadata: {
			name: "data"
		}
		spec: {
			accessModes: ["ReadWriteOnce"]
			resources: requests: storage: "32Gi"
		}
	},
	corev1.#PersistentVolumeClaim & {
		metadata: {
			name: "logs"
		}
		spec: {
			accessModes: ["ReadWriteOnce"]
			resources: requests: storage: "8Gi"
		}
	},
]

#volumes: [
	corev1.#Volume & {
		name: "work"
		emptyDir: {}
	},
]

#volumeMounts: [
	for _, v in #volumeClaimTemplates {
		corev1.#VolumeMount & {
			name:      v.metadata.name
			mountPath: "\(baseMountPath)/\(v.metadata.name)"
		}
	},
	for _, v in #volumes {
		corev1.#VolumeMount & {
			name:      v.name
			mountPath: "\(baseMountPath)/\(v.name)"
		}
	},
]

#podTemplate: corev1.#Pod & {
	metadata: {
		labels: #labels
	}
	spec: corev1.#PodSpec & {
		containers: [
			{
				name:         string | *#defaultName
				image:        string | *defaultImage
				ports:        #ports
				env:          #envVars
				volumeMounts: #volumeMounts
			},
		]
		volumes: #volumes
	}
}

statefulset: "omada-controller": {
	apiVersion: "apps/v1"
	kind:       "StatefulSet"
	metadata:   #metadata
	spec: {
		selector: {
			matchLabels: #selector
		}
		serviceName:          string | *#defaultName
		replicas:             int | *1
		template:             #podTemplate
		volumeClaimTemplates: #volumeClaimTemplates
	}
}
