
provider "aws" {
  region                  = "ap-southeast-2"
  profile                 = "MYAWS"
}
resource "aws_instance" "ubuntu" {
  ami           = "ami-0567f647e75c7bc05" # us-west-2
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  user_data = <<-EOF
		#! /bin/bash
    sudo apt-get update
    sudo apt  install postgresql -y
    sudo su postgres

		
	EOF

} 

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS"
  vpc_id      = aws_default_vpc.default.id
  

  ingress {
    description      = "TLS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  ingress {
    description      = "TLS"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["27.4.171.123/32"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  resource "aws_key_pair" "mazhar" {
  key_name   = "mazhar"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPAFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxPCM"
  }

  tags = {
    Name = "allow_tls"
  }
}
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}
