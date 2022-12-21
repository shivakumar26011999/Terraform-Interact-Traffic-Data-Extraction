locals {
  az_names = data.aws_availability_zones.avl_zones.names
}
resource "aws_subnet" "ECS_vpc_subnet" {
    count             = length(local.az_names)                              #length(data.aws_availability_zones.avl_zones.names)
    vpc_id            = aws_vpc.ECS_vpc.id
    cidr_block        = cidrsubnet(var.vpc_cidr,8,count.index)              #"10.0.1.0/24" "10.0.2.0/24" ...
    availability_zone = local.az_names[count.index]                         #data.aws_availability_zones.avl_zones.names[count.index]
    map_public_ip_on_launch = true                                          #assigns the public ip automatically when aa task or an instance is launched.
    tags = {
        Name = "public_subnet-count.index"
    }
}