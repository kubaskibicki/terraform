provider "aws" {
	region = "us-east-1"
}

resource "aws_db_instance" "example" {
    identifier_prefix = "terraform-up-and-running"
    engine = "mysql"
    engine_version = "8.0"
    allocated_storage = 10
    instance_class = "db.t3.micro"
    skip_final_snapshot = true
    db_name = var.db_name

    username = var.db_username
    password = var.db_password
}

terraform {
    backend "s3" {
        bucket = "va576251102"
        key = "stage/data-stores/mysql/terraform.tfstate"
        region = "us-east-1"

        use_lockfile = true
        encrypt = true
    }
}