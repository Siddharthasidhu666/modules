module "roboshop"{
source = "../developer-modules"
project_name = var.project
environment = var.environment
common_tags = var.common_tags
vpc_tags = var.vpc_tags


}
