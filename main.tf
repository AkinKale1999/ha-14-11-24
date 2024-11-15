terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "G_Actions_Terraform_Instanz" {
  # count = 5
  ami                    = "ami-0eddb4a4e7d846d6f"
  instance_type          = "t2.micro"
  key_name               = "Terraform-key"
  vpc_security_group_ids = [aws_security_group.ssh_access.id]

  tags = {
    Name = "EC2-HA"
  }
}

output "instance_public_ips" {
  value = aws_instance.G_Actions_Terraform_Instanz.*.public_ip
}

resource "aws_security_group" "ssh_access" {
  name = "ssh_access"

  ingress = {
    from_port  = 22
    to_port    = 22
    protocol   = "tcp"
    cidr_block = ["0.0.0.0/0"]
  }


  egress = {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_block = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh_access"
  }
}



resource "aws_vpc" "Instanz_For_Terraform" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "VPC for EC2"
  }
}

resource "aws_subnet" "subnet_For_VPC" {
  vpc_id            = aws_vpc.Instanz_For_Terraform.id
  cidr_block        = "10.0.0.0/20"
  availability_zone = "eu-central-1c"

  tags = {
    Name = "Subnet for VPC"
  }
}

resource "aws_internet_gateway" "igw_For_vpc" {
  vpc_id = aws_vpc.Instanz_For_Terraform.id

  tags = {
    Name = "internet-gateway-for-vpc"
  }
}

resource "aws_route_table" "routing_table_For_vpc" {
  vpc_id = aws_vpc.Instanz_For_Terraform.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_For_vpc.id
  }

  tags = {
    Name = "Routing Table for VPC"
  }
}

resource "aws_route_table_association" "defining_routing_in_the_VPC" {
  subnet_id      = aws_subnet.subnet_For_VPC.id
  route_table_id = aws_route_table.routing_table_For_vpc.id
}
