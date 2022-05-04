output "file_system_id_flow_modules" {
	value = "${aws_efs_file_system.flow_modules.id}"
}

output "file_system_id_functions" {
	value = "${aws_efs_file_system.functions.id}"
}

output "ns_records" {
	value = "${aws_route53_zone.cluster_route53.name_servers}"
}

output "kops_create_cluster" {
	value = <<-EOT
		kops create cluster \
			--state "s3://state.${var.cluster_name}/kops" \
			--zones "${join(",", var.subnet_availability_zones)}"  \
			--master-count ${var.master_count} \
			--master-size= "${var.master_size}"\
			--node-count ${var.node_count} \
			--node-size= "${var.node_size}" \
			--name "${var.cluster_name}" \
			--vpc "${aws_vpc.cluster_vpc.id}" \
			--subnets "${local.subnets}" \
			--node-security-groups "${aws_security_group.default.id}" \
			--networking flannel-vxlan \
			--ssh-public-key ~/.ssh/dev-environment.pub \
			--ssh-access "0.0.0.0/0" \
			--admin-access "0.0.0.0/0" \
			--yes
	EOT
}
