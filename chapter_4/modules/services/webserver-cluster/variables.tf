variable "server_port" {
	description = "The port the server will use for http requests"
	type = number
	default = 8080
}

variable "bucket_name" {
    description = "Bucket name in organised file structure"
    type = string
    default = "va576251102"
}

variable "db_remote_state_key" {
    description = "Path to tf state"
    type = string
    default = "stage/data-stores/mysql/terraform.tfstate"
}

variable max_size {
    description = "Max size of EC2 cluster"
    type = number
}

variable min_size {
    description = "Min size of EC2 cluster"
    type = number
}

variable instance_type {
    description = "Instance type e.g. t2.micro"
    type = string
}

variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}