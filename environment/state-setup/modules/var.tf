variable "cluster_name" {
  type        = string
  default     = "kubernetes.dev-environment.cognigy.abc"
  description = "The name of the cluster. Should be equal to the main domain of the cluster prefixed with kubernetes (e.g kubernetes.dev.cognigy.abc)"
}

variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "The region in AWS where the cluster should be spawned"
}