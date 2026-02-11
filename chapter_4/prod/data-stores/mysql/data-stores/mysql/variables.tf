variable "db_username" {
    description = "The username for the database"
    type = string
    sensitive = true
}

variable "db_password" {
    description = "The password for the database"
    type = string
    sensitive = true
}

variable "db_name" {
    description = "Name of mysql database"
    type = string
    default = "example_database_prod"
}

variable "bucket_name" {
    description = "Bucket name in organised file structure"
    type = string
    default = "va576251102"
}