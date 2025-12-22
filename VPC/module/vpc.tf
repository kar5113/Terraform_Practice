resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  tags= merge(
    var.vpc_tags,
    local.common_tags,{
        Name= local.common_name_suffix
    }
  )
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.igw_tags,
    local.common_tags,{
        Name= local.common_name_suffix
    }
  )
}

resource "aws_subnet" "public" {
  count= length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidrs[count.index]

  map_public_ip_on_launch  = true

  availability_zone =  local.availability_zones[count.index]

  tags = merge(
    var.public_subnet_tags,
    local.common_tags,{
        Name= "${local.common_name_suffix}-public-${local.availability_zones[count.index]}" #roboshop-dev-public-us-east-1a
    }
  )
}


resource "aws_subnet" "private" {
  count= length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidrs[count.index]

  map_public_ip_on_launch  = false

  availability_zone =  local.availability_zones[count.index]  #By default this is false so can be removed.

  tags = merge(
    var.private_subnet_tags,
    local.common_tags,{
        Name= "${local.common_name_suffix}-private-${local.availability_zones[count.index]}" #roboshop-dev-private-us-east-1a
    }
  )
}

resource "aws_subnet" "database" {
  count= length(var.database_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidrs[count.index]

  map_public_ip_on_launch  = false

  availability_zone =  local.availability_zones[count.index]  #By default this is false so can be removed.

  tags = merge(
    var.database_subnet_tags,
    local.common_tags,{
        Name= "${local.common_name_suffix}-database-${local.availability_zones[count.index]}" #roboshop-dev-private-us-east-1a
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.public_route_table_tags,
    local.common_tags,{
        Name= "${local.common_name_suffix}-public" #roboshop-dev-public
    }
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.private_route_table_tags,
    local.common_tags,{
        Name= "${local.common_name_suffix}-private" #roboshop-dev-private
    }
  )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.database_route_table_tags,
    local.common_tags,{
        Name= "${local.common_name_suffix}-database" #roboshop-dev-database
    }
  )
}

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main.id
}


# Elastic Ip for NAT Gateway
resource "aws_eip" "elastic_ip"{
    domain= "vpc"

    tags= merge(
        local.common_tags,{
            Name= "${local.common_name_suffix}-nat-eip"
        }
    )
}

resource "aws_nat_gateway" "nat"{
    allocation_id= aws_eip.elastic_ip.id
    subnet_id= aws_subnet.public[0].id

    tags= merge(
        var.nat_gateway_tags,
        local.common_tags,{
            Name= "${local.common_name_suffix}-nat-gateway"
        }
    )
    # Ensure the NAT Gateway is created after the Internet Gateway
    depends_on = [aws_internet_gateway.main]
}

resource "aws_route" "private" {
  route_table_id = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
}

resource "aws_route" "database" {
  route_table_id = aws_route_table.database.id
      destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id

}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidrs)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}
