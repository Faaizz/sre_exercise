module "main" {
    source = "./modules"
}

output "file_system_id_flow_modules" {
	value = "${module.main.file_system_id_flow_modules}"
}

output "file_system_id_functions" {
	value = "${module.main.file_system_id_functions}"
}
output "ns_records" {
	value = "${module.main.ns_records}"
}

output "kops_create_cluster" {
	value = "${module.main.kops_create_cluster}"
}

terraform {
  backend "s3" {
      bucket = "state.${var.cluster_name}"
      region = "${var.region}"
      key = "eks.tfstate"
  }
}
