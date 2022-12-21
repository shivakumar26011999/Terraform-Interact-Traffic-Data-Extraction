resource "aws_vpc" "ECS_vpc" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"

    tags = {
        Environment = terraform.workspace
    }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ECS_vpc.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "vpc_route" {
  vpc_id = aws_vpc.ECS_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "ECS_vpc_route"
  }
}

resource "aws_route_table_association" "subnet_association" {
    count = length(data.aws_availability_zones.avl_zones.names)
    subnet_id      = aws_subnet.ECS_vpc_subnet.*.id[count.index]
    route_table_id = aws_route_table.vpc_route.id
}


