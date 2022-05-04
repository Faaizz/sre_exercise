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

variable "master_size" {
    type = string
    default = "t2.medium"
    description = "The size of master node EC2 instance"
}

variable "master_count" {
    type = number
    default = 1
    description = "The number of cluster master nodes"
}

variable "node_size" {
    type = string
    default = "c5.2xlarge"
    description = "The size of node node EC2 instance"
}

variable "node_count" {
    type = number
    default = 3
    description = "The number of cluster nodes"
}

locals {
    vpc = {
        cidr_block = "172.0.0.0/12"
    }

    subnet_availability_zones = {
        eu-central-1a = {
            cidr_block = "172.1.0.0/16"
        }
        eu-central-1b = {
            cidr_block = "172.2.0.0/16"
        }
        eu-central-1c = {
            cidr_block = "172.3.0.0/16"
        }
    }
    
    subnets = [ for sn in aws_subnet.saz : {
        id = saz.id
    } ]
}
