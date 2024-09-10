variable "cidr_block"{
    default = "10.0.0.0/16"
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
}

##########################
variable "cidr"{
default = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "public_subnets_tags"{
default = {}
}

variable "cidr_private"{
default = ["10.0.11.0/24","10.0.12.0/24"]
}

variable "private_subnets_tags"{
default = {}
}

variable "cidr_database"{
type = list
default = ["10.0.21.0/24","10.0.22.0/24"]
}


variable "database_subnets_tags"{
default = {}
}

variable "igw_tags"{
    default ={}

}