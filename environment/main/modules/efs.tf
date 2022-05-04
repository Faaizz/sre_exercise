### FLOW MODULES EFS
resource "aws_efs_file_system" "flow_modules" {
	creation_token = "${var.cluster_name}_flow_modules"

	tags = {
	Name = "${var.cluster_name}_flow_modules"
	}
}

resource "aws_efs_mount_target" "fm_mt_sn" {
	for_each = locals.subnets

	file_system_id  = aws_efs_file_system.flow_modules.id
	subnet_id       = local.value.id
	security_groups = ["${aws_default_security_group.default.id}"]
}

### Functions EFS
resource "aws_efs_file_system" "functions" {
	creation_token = "${var.cluster_name}_functions"

	tags = {
	Name = "${var.cluster_name}_functions"
	}
}

resource "aws_efs_mount_target" "f_mt_sn" {
	for_each = locals.subnets

	file_system_id  = aws_efs_file_system.functions.id
	subnet_id       = each.value.id
	security_groups = ["${aws_default_security_group.default.id}"]
}
