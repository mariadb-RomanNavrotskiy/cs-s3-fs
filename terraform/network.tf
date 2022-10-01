resource "aws_vpc" "vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = var.zone.prefix
  }
}

resource "aws_subnet" "subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = cidrsubnet(aws_vpc.vpc.cidr_block, 8, 1)
  availability_zone = "us-east-1a"
}

resource "aws_eip" "eip" {
  count = var.instance.count
  vpc   = true
}

resource "aws_eip_association" "eip" {
  count         = var.instance.count
  instance_id   = element(aws_instance.instance.*.id, count.index)
  allocation_id = element(aws_eip.eip.*.id, count.index)
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_default_route_table" "route" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_security_group" "security-instance" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "security-instance-to-efs" {
  vpc_id = aws_vpc.vpc.id

  egress {
    from_port = 2049
    to_port   = 2049
    protocol    = "tcp"
  }
}

resource "aws_security_group" "security-efs" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    security_groups = [aws_security_group.security-instance-to-efs.id]
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
  }

  egress {
    from_port = 2049
    to_port   = 2049
    protocol    = "tcp"
  }

}
