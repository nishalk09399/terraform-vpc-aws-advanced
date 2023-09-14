variable "cidr_block" {  #forcing user to provide values

}

variable "enable_dns_support" {
    default = "true"
}

variable "enable_dns_hostnames" {
    default = "true"
}

variable "common_tags" {
    default = {} #this means tags is optional 
    type = map
}


variable "vpc_tags" {
    default = {} #this means tags is optional 
    type = map
}

variable "project_name" {  #required
   
}

variable "igw_tags" {
    default = {} #this means tags is optional 
    type = map
}


variable "public_subnet_cidr" { #we need to accept only 2 subenets that is the challenge
    type = list
    validation {
        condition  = length(var.public_subnet_cidr) == 2
        error_message = "please enter any two public subents CIDR"
    }   
       
}

variable "private_subnet_cidr" { #we need to accept only 2 subenets that is the challenge
    type = list
    validation {
        condition  = length(var.private_subnet_cidr) == 2
        error_message = "please enter any two private subents CIDR"
    }   
       
}

variable "database_subnet_cidr" { #we need to accept only 2 subenets that is the challenge
    type = list
    validation {
        condition  = length(var.database_subnet_cidr) == 2
        error_message = "please enter any two database subents CIDR"
    }   
       
}

variable "nat_gateway_tags" {
    default = {}
}

variable "private_route_table_tags" {
    default = {}
}

variable "public_route_table_tags" {
    default = {}
}

variable "database_route_table_tags" {
    default = {}
}

variable "db_subnet_group_tags" {
    default = {}
}
