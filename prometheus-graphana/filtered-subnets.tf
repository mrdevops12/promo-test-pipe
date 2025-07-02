data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_subnet" "private_details" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}

locals {
  unique_az_subnets = {
    for subnet in data.aws_subnet.private_details :
    subnet.availability_zone => subnet.id
  }

  private_subnet_ids = values(local.unique_az_subnets)
}
