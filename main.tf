terraform {
  backend "s3"{
  bucket = "github-actions-slengpack"
  key = "terrraform.tfstate"
  region = "eu-central-1"
  }
  
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


resource "aws_security_group" "ssh_access" {
  name        = "ssh-access-sg"
  description = "Allow SSH access to EC2 instances"
  vpc_id      = "vpc-0b948e9d589ae0fd5"

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

  tags = {
    Name = "SSH Access Security Group"
  }
}


resource "aws_instance" "instance_1" {
  ami                         = "ami-0745b7d4092315796"
  instance_type               = "t2.micro"
  key_name                    = "slengpack"
  subnet_id                   = "subnet-024dc0752fedfae85"
  vpc_security_group_ids      = [aws_security_group.ssh_access.id]
  associate_public_ip_address = true

  tags = {
    Name = "Instance-Public"
    VPC  = "vpc-0b948e9d589ae0fd5"
  }
}

resource "aws_instance" "instance_2" {
  ami                    = "ami-00123af0ec3011bb6" #використай свою AMI
  instance_type          = "t2.micro"
  key_name               = "slengpack"
  subnet_id              = "subnet-0cd5072ef462bb252"
  vpc_security_group_ids = [aws_security_group.ssh_access.id]

  tags = {
    Name = "Instance-Privat"
    VPC  = "vpc-0b948e9d589ae0fd5"
  }
}

output "created_sg_id" {
    value = aws_security_group.ssh_access.id
}
