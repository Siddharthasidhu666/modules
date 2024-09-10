resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  enable_dns_hostnames = "true"

  tags = merge(var.common_tags, 
    var.vpc_tags,
    {
        Name = local.name
    }
    )
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.main.id
  count = length(var.cidr)
  cidr_block = var.cidr[count.index]
  availability_zone = local.az_names[count.index]

  map_public_ip_on_launch = true
  tags = merge(var.common_tags, 
    var.public_subnets_tags,
    {
        Name = "${local.name}-public-${local.az_names[count.index]}"
    }
    )
 
}


resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main.id
  count = length(var.cidr_private)
  cidr_block = var.cidr_private[count.index]
  availability_zone = local.az_names[count.index]

  tags = merge(var.common_tags, 
    var.private_subnets_tags,
    {
        Name = "${local.name}-private-${local.az_names[count.index]}"
    }
    )
 
}


resource "aws_subnet" "database_subnet" {
  vpc_id     = aws_vpc.main.id
  count = length(var.cidr_database)
  cidr_block = var.cidr_database[count.index]
  availability_zone = local.az_names[count.index]

  tags = merge(var.common_tags, 
    var.database_subnets_tags,
    {
        Name = "${local.name}-database-${local.az_names[count.index]}"
    }
    )
 
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.common_tags, 
    var.igw_tags,
    {
        Name = "${local.name}-igw-public"
    }
    )
  
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
      Name = "${local.name}-publicroutetable"
  }
}


resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.main.id

   route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example.id
  }

  tags = {
      Name = "${local.name}-privateroutetable"
  }
}

resource "aws_route_table" "database_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.example.id
  }

  tags = {
      Name = "${local.name}-databaseroutetable"
  }
}


resource "aws_route_table_association" "public_subnet_asso" {
  count = length(var.cidr)
  subnet_id = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_subnet_asso" {
  count = length(var.cidr_private)
  subnet_id = element(aws_subnet.private_subnet[*].id, count.index)
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "database_subnet_asso" {
  count = length(var.cidr_database)
  subnet_id = element(aws_subnet.database_subnet[*].id, count.index)
  route_table_id = aws_route_table.database_route.id
}


resource "aws_eip" "lb" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.public_subnet[0].id

  depends_on = [aws_internet_gateway.igw]
}