resource "aws_vpc_peering_connection" "this" {
  # if this is set to true then peering connection is created.
  count= var.is_peering_required ? 1 : 0
  
       # AWS Account ID of the peer VPC
  peer_vpc_id   = data.aws_vpc.default.id
  vpc_id        = aws_vpc.main.id
    auto_accept   = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags= merge(

    local.common_tags,{
        Name= "${local.common_name_suffix}-peering"
    }
  )
}

resource "aws_route" "public_peering" {
  count= var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this[0].id
}

resource "aws_route" "default_peering" {
  count= var.is_peering_required ? 1 : 0
  route_table_id            = data.aws_vpc.default.main_route_table_id
  destination_cidr_block    = aws_vpc.main.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this[0].id
}
 