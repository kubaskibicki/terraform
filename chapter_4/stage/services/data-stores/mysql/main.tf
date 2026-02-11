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
    db_name = "example_database"

    username = var.db_usename
    password = var.db_password
}

terraform {
    backend "s3" {
        bucket = "bucket-name98321321"
        key = "stage/data-stores/mysql/terraform.tfstate"
        region = "us-east-1"

        use_lockfile = true
        encrypt = true
    }
}