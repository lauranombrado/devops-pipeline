
provider "aws" {
  region = var.aws_region
  profile = "devops"
}

variable "region" {
  description = "Region Name"
  default     = "us-east-1"
}

variable "aws_region" {
  description = "EC2 Region for the VPC"
  default     = "us-east-1"
}

variable "remote_cidr" {
  description = "CIDR from remote testing source"
  default = "136.158.103.54/32" #MyIp
}

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_a_cidr" {
  description = "CIDR for the public 1a subnet"
  default = "10.0.0.0/25"
}

variable "public_subnet_b_cidr" {
  description = "CIDR for the public 1b subnet"
  default = "10.0.0.128/25"
}


variable "private_subnet_a_cidr" {
  description = "CIDR for the private 1a subnet"
  default = "10.0.1.0/25"
}

variable "private_subnet_b_cidr" {
  description = "CIDR for the private 1b subnet"
  default = "10.0.1.128/25"
}

variable "private_db_subnet_a_cidr" {
  description = "CIDR for the private 1a subnet"
  default = "10.0.2.0/25"
}

variable "private_db_subnet_b_cidr" {
  description = "CIDR for the private 1b subnet"
  default = "10.0.2.128/25"
}

variable "key_path" {
  description = "SSH public key path"
  default = ".ssh/devops.pub"
}

variable "asg_jenkins_slave_min" {
  description = "Auto scaling minimum size"
  default = "1"
}

variable "asg_jenkins_slave_max" {
  description = "Auto scaling max size"
  default = "2"
}

variable "asg_jenkins_slave_desired" {
  description = "Auto scaling desired size"
  default = "2"
}

variable "asg_jenkins_master_min" {
  description = "Auto scaling minimum size"
  default = "1"
}
variable "asg_jenkins_master_max" {
  description = "Auto scaling max size"
  default = "1"
}

variable "asg_jenkins_master_desired" {
  description = "Auto scaling desired size"
  default = "1"
}

variable "asg_gitlab_min" {
  description = "Auto scaling minimum size"
  default = "1"
}
variable "asg_gitlab_max" {
  description = "Auto scaling max size"
  default = "2"
}

variable "asg_gitlab_desired" {
  description = "Auto scaling desired size"
  default = "1"
}

variable "data_volume_type" {
  description = "EBS volume type"
  default = "gp2"
}

variable "data_volume_size" {
  description = "EBS volume size"
  default = "50"
}

variable "root_block_device_size" {
  description = "Root EBS volume size"
  default = "50"
}

variable "gitlab_postgresql_password" {
  default = "supersecret"
}

variable "gitlab_rds_multiAZ" {
  default = "false" 
}

variable "availability_zones" {
  type = list(string)
  default = ["us-east-1a", "us-east-1b"] 
}

variable "subnets" {
  type = list(string)
  default = ["subnet-c404f1f5", "subnet-c7940fc9"]
}

variable "instance_type" {
  default = "t3.medium"  
}