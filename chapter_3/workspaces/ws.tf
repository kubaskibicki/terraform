provider "aws" {
	region = "us-east-1"
}


resource "aws_instance" "ec2_example" {
	ami = "ami-002e81a9a522f1f19"
	instance_type = "t2.micro"
}


terraform {
    backend "s3" {
      bucket = "terraform-up-and-running-5739483"
      key = "workspaces-example/terraform.tfstate"
      region = "us-east-1"

      use_lockfile = true
      encrypt = true
    }
}
