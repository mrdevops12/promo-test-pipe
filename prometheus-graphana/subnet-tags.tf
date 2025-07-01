data "aws_subnets" "all_in_vpc" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_subnet" "details" {
  for_each = toset(data.aws_subnets.all_in_vpc.ids)
  id       = each.value
}

locals {
  private_subnet_ids = [
    for subnet_id, subnet in data.aws_subnet.details : subnet_id
    if subnet.map_public_ip_on_launch == false
  ]
}

resource "aws_ec2_tag" "internal_elb_tag" {
  for_each = toset(local.private_subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
}

resource "aws_ec2_tag" "cluster_tag" {
  for_each = toset(local.private_subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/cluster/${var.eks_cluster_name}"
  value       = "owned"
}

