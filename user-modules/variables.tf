variable "common_tags" {
  default = {
    Project = "roboshop"
    Environment = "dev"
    Terraform = "true"
  }
}

variable "project" {
  default = "roboshop"
}

variable "environment" {
  default = "dev"
}

variable "vpc_tags" {
  default = {
    hi = "hello"
  }
}
