package omadaController

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
