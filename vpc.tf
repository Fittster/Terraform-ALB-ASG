resource "aws_vpc" "mainvpc" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"
    enable_dns_hostnames = true

    tags = {
        Name = "VPC_TF"
    }
}



resource "aws_security_group" "ec2_private_security_group" {
        name = "EC2-private-scg"
        description   = "Only allow public SG resources to access private instaances"
        vpc_id = aws_vpc.mainvpc.id

        ingress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            # Allows all communication from traffic that starts from the public security group
            security_groups = [aws_security_group.ec2_public_security_group.id]
        }
            egress {
            from_port = 0
            to_port = 0
            protocol = "-1"
            cidr_blocks = ["0.0.0.0/0"]
        }

        tags = {
            Name = "ec2_private_security_group"
        }
        depends_on = [aws_vpc.mainvpc,aws_security_group.ec2_public_security_group]
}

resource "aws_internet_gateway" "IGW_TF"{
    vpc_id = aws_vpc.mainvpc.id

    tags = {
        Name = "IGW_TF"
    }
    depends_on = [aws_vpc.mainvpc]
}

resource "aws_eip" "EIP_TF" {
    vpc = true
    tags = {
        Name = "EIP_TF"
    }
}

resource "aws_nat_gateway" "NATGW_TF" {
    allocation_id = aws_eip.EIP_TF.id
    subnet_id = aws_subnet.public_subnets[0].id

    tags = {
        Name  = "NATGW_TF"
    }
    depends_on = [aws_eip.EIP_TF,aws_subnet.public_subnets]
}
