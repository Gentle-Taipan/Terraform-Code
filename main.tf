provider "aws" {
  region = "us-east-1"
}

resource "aws_default_vpc" "default" {}

resource "aws_instance" "web" {
  ami                    = "ami-0bbc0801b3da5b7ae"
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web.id]
  tags = {
    Name  = var.name
    Owner = "Suhail"
  }
}

resource "aws_security_group" "web" {
  name        = "web server SG"
  vpc_id      = aws_default_vpc.default.id
  description = "SG for webserver"
  dynamic "ingress" {
    for_each = toset(["80", "22"])
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    description = "Allow all ports"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip" "web" {
  instance = aws_instance.web.id
  tags = {
    Name        = "Eip-Web"
    description = "EIP for web server instance"
  }
}
