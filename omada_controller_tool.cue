package omadaController

import (
	"encoding/yaml"
	"text/tabwriter"
	"tool/cli"
)

resources: [ for r in kubeResources for k in r {k}]

kubeResources: [
	service,
	statefulset,
]

command: ls: {
	task: print: cli.Print & {
		text: tabwriter.Write([
			"Kind\tApp\tName",
			for r in resources {
				"\(r.kind)  \t\(r.metadata.labels.app)  \t\(r.metadata.name)"
			},
		])
	}
}

command: print: {
	task: print: cli.Print & {
		text: yaml.MarshalStream(resources)
	}
}
