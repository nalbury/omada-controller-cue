package omadaController

import (
	appsv1 "k8s.io/api/apps/v1"
	corev1 "k8s.io/api/core/v1"
)

statefulset: [string]: appsv1.#StatefulSet

let defaultImage = "mbentley/omada-controller:latest"
let baseMountPath = "/opt/tplink/EAPController"

#envVars: [
	corev1.#EnvVar & {
		name:  "MANAGE_HTTP_PORT"
		value: "80"
	},
	corev1.#EnvVar & {
		name:  "MANAGE_HTTPS_PORT"
		value: "443"
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
				name:            string | *#defaultName
				image:           string | *defaultImage
				imagePullPolicy: string | *"Always"
				ports:           #ports + #webPorts
				env:             #envVars
				volumeMounts:    #volumeMounts
			},
		]
		volumes: #volumes
		securityContext: sysctls: [
			{
				name:  "net.ipv4.ip_unprivileged_port_start"
				value: "0"
			},
		]
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
		serviceName:          string | *"omada-controller-web"
		replicas:             int | *1
		template:             #podTemplate
		volumeClaimTemplates: #volumeClaimTemplates
	}
}
