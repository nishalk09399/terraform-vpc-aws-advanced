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

variable "public_subnet_ids" {
    default = {}
}

variable "private_subnet_ids" {
    default = {}
}

variable "database_subnet_ids" {
    default = {}
}

variable  "is_peering_required" {
    default = false
}

variable "requestor_vpc_id" {

}

variable "default_route_table_id" {

}

variable "default_vpc_cidr" {

}

variable "env" {

}