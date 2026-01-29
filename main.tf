provider "aws" {
	region = "us-east-1"
}

resource "aws_instance" "example" {
	ami = "ami-002e81a9a522f1f19"
	instance_type = "t2.micro"

	tags = {
		Name="example"
	}
}
