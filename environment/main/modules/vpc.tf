### ROUTE 53
resource "aws_route53_zone" "cluster_route53" {
  name = var.cluster_name
}

### VPC
resource "aws_vpc" "cluster_vpc" {
	cidr_block           = local.vpc.cidr_block
	enable_dns_hostnames = true
	enable_dns_support   = true
	tags = {
		KubernetesCluster = "${var.cluster_name}"
		Name = "${var.cluster_name}"
	}
}

resource "aws_internet_gateway" "cluster_gateway" {
	vpc_id = aws_vpc.cluster_vpc.id

	tags = {
		Name = "${var.cluster_name}"
	}
}

### SUBNETS
resource "aws_subnet" "sn" {
	# Use a loop
    for_each = local.subnet_availability_zones

	availability_zone = each.key
	cidr_block = each.value.cidr_block
	depends_on = [aws_vpc.cluster_vpc]
	vpc_id = aws_vpc.cluster_vpc.id

	tags = {
		KubernetesCluster = "${var.cluster_name}"
		Name = "${var.cluster_name}-${each.value}",
		SubnetType = "Public"
		"kubernetes.io/cluster/${var.cluster_name}" = "shared"
		"kubernetes.io/role/elb" = "1"
	}
}

### ROUTE TABLE & ASSOCIATION
resource "aws_route_table" "cluster_route_table" {
	vpc_id = aws_vpc.cluster_vpc.id

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.cluster_gateway.id
	}

	tags = {
		Name = "${var.cluster_name}"
	}
}

resource "aws_route_table_association" "sn_rt_assoc" {
    for_each = local.subnets

	subnet_id = each.value.id
	route_table_id = aws_route_table.cluster_route_table.id
}
