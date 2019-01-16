variable "environment" {
  default = "GearuDEVTest"
}


variable "repository_name" {
  default = "rag"
}

variable "vpc_id" {
  description = "The VPC id"
}

variable "availability_zones" {
  type        = "list"
  description = "The AZS to use"
}

#variable "security_groups_ids" {
#  type        = "list"
#  description = "The SGs to use"
#}

variable "public_subnets_ids" {
  type        = "list"
  description = "The private subnets to use"
}

variable "max_instance_size" {
  description = "Maximum number of instances in the cluster"
  
}

variable "min_instance_size" {
  description = "Minimum number of instances in the cluster"
  
}

variable "desired_capacity" {
  description = "Desired number of instances in the cluster"
  
}


variable "cluster"
{
description = "cluster..."
}

variable "instance_group" {
  default     = "default"
  description = "The name of the instances that you consider as a group"
}

variable "default_alb_target_group" {
   description =" alb target group"
}

#variable "alb_name"{
#}

variable "alb_security_group_default_id"{
}



variable "alb_name" {
  default     = "ALB"
  description = "The name of the loadbalancer"
}

#variable "environment" {
#  description = "The name of the environment"
#}

#variable "public_subnets_ids" {
#  type        = "list"
#  description = "List of public subnet ids to place the loadbalancer in"
#}

#variable "vpc_id" {
#  description = "The VPC id"
#}

variable "deregistration_delay" {
  default     = "300"
  description = "The default deregistration delay"
}

variable "health_check_path" {
  default     = "/actuator/health"
  description = "The default health check path"
}

variable "allow_cidr_block" {
  default     = "0.0.0.0/0"
  description = "Specify cird block that is allowd to acces the LoadBalancer"
}
variable "projectName"{
  description = "Project Name"
}

variable "ecsFamily"
{
	description ="ECS Family Name"
}

variable "amis" {
  type = "map"
}

variable "region"
{
	description = "Region Environment is Built"
}


variable "instance_type"
{
   description ="Instance Type to be built"
}

variable "rootvoltype"{

  description ="Root Volume Type"

} 

variable "rootvolsize"{

    description ="Root Volume Size"
}

variable "domainName"{

	description ="Domain Name "
}

variable "primarydomainName"{

	description ="Primary Domain Name under which Domain needs to be registered"
	
}	
  
variable "ecs_container_name" {

   description ="ECS container name"
}

variable "image_urn" {
	description ="ECS Image name"
}

variable "container_port" {
   
	description ="ECS Container Port Numner"
} 
   
 
   



