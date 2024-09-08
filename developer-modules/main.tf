resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  enable_dns_hostnames = "True"

  tags = merge(var.common_tags, 
    var.vpc_tags,
    {
        Name = local.name
    }
    )
}