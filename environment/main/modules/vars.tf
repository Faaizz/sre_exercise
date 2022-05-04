variable "cluster_name" {
	type = string
	default = "kubernetes.dev-environment.cognigy.abc"
	description = "The name of the cluster. Should be equal to the main domain of the cluster prefixed with kubernetes (e.g kubernetes.dev.cognigy.abc)"
}

variable "region" {
	type = string
	default = "eu-central-1"
	description = "The region in AWS where the cluster should be spawned"
}

variable "subnet_availability_zones" {
	type = list(string)
	default = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
	description = "The availability zones to create subnets in. If you use a region other than eu-central-1, then you should change this variable"
}
