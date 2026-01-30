provider "aws" {
	region = "us-east-1"
}

variable "server_port" {
	description = "The port the server will use for http requests"
	type = number
	default = 8080
}

resource "aws_instance" "ec2_example" {
	ami = "ami-002e81a9a522f1f19"
	instance_type = "t2.micro"
	vpc_security_group_ids = [aws_security_group.instance.id]

	tags = {
		Name="example"
	}

	user_data = <<-EOF
			#!/bin/bash
			echo "Hello, World" > index.html
			nohup busybox httpd -f -p ${var.server_port} &
			EOF

	user_data_replace_on_change = true
}

resource "aws_security_group" "instance" {

  name = "example-security-group"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "public_ip" {
  value       = aws_instance.ec2_example.public_ip
  description = "The public IP of the Instance"
}
