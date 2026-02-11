variable "db_usename" {
    description = "The username for the database"
    type = string
    sensitive = true
}

variable "db_password" {
    description = "The password for the database"
    type = string
    sensitive = true
}