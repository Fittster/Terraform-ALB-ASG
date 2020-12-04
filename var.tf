variable "vpc_cidr" {
    
}

variable "region" {
  
}

variable "ami" {
    default = "ami-0a13d44dccf1f5cf6"
}

variable "instance_type" {
    default = "t2.micro"
}


variable "public_subnet_cidr"{
    type = list
}

variable "private_subnet_cidr"{
    type = list
}

variable "availability_zone" {
    type = list
}

variable "public_subnet_names"{
    type = list
}

variable "private_subnet_names"{
    type = list
}
