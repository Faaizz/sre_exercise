resource "aws_security_group" "default" {
	vpc_id = aws_vpc.cluster_vpc.id

	# Whitelist all incoming traffic from this security group
	ingress {
		from_port = 22
		to_port = 22
		protocol = "TCP"
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
		description = ""
	}

	tags = {
		KubernetesCluster = "${var.cluster_name}"
		Name = "${var.cluster_name}"
	}
}
