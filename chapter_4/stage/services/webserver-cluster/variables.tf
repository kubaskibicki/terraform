variable "server_port" {
	description = "The port the server will use for http requests"
	type = number
	default = 8080
}

variable "bucket_name" {
    description = "Bucket name in organised file structure"
    type = string
    default = "bucket-name98321321"
}

variable "db_remote_state_key" {
    description = "Path to tf state"
    type = string
    default = "stage/data-stores/mysql/terraform.tfstate"
}
