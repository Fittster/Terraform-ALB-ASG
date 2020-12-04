resource "aws_route_table" "PublicRouteTable_TF" {
    vpc_id = aws_vpc.mainvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.IGW_TF.id
    }
    tags = {
        Name = "PublicRouteTable_TF"
    }
    depends_on = [aws_vpc.mainvpc,aws_internet_gateway.IGW_TF]
}

resource "aws_route_table_association" "publicroutetableassociation" {
    count = length(var.public_subnet_cidr)
    subnet_id = element(aws_subnet.public_subnets.*.id, count.index)
    route_table_id = aws_route_table.PublicRouteTable_TF.id
    depends_on = [aws_subnet.public_subnets, aws_route_table.PublicRouteTable_TF]
}

resource "aws_route_table" "PrivateRouteTable_TF" {
    vpc_id = aws_vpc.mainvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.NATGW_TF.id
    }
        tags = {
            Name = "PrivateRouteTable_TF"
        }
        depends_on = [aws_vpc.mainvpc,aws_nat_gateway.NATGW_TF]
}

resource "aws_route_table_association" "privateroutetableassociation" {
    count = length(var.private_subnet_cidr)
    subnet_id = element(aws_subnet.private_subnets.*.id, count.index)
    route_table_id = aws_route_table.PrivateRouteTable_TF.id
    depends_on = [aws_subnet.private_subnets, aws_route_table.PrivateRouteTable_TF]
}
