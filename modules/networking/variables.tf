variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
}

variable "subnet_cidrs_public" {
  type        = "list"
  description = "The CIDR block for the public subnet"
}


variable "environment" {
  description = "The environment"
}



variable "availability_zones" {
  type        = "list"
  description = "The az that the resources will be launched"
}

#variable "key_name" {
#  description = "The public key for the bastion host"
#}

variable "projectName"{
	description ="Project Name "
}
