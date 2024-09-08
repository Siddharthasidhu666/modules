variable "cidr_block"{
    value = "10.0.0.0/16"
}

variable "project_name"{
}

variable "environment"{
}

variable "common_tags"{
type = map
default = {}
}

variable "vpc_tags"{
type = map
default = {}
