#~~~~~DATA~~~~~
#VPC to create the instance in
data "aws_vpc" "default_vpc" {
  default = true
} 

#~~~~~REQUIRED VARS~~~~
#Name assocated with the EC2 instance - will be used as a prefix for the key
variable "dms_instance_id" {
    #default = "dms-repl-n-staging"
    description = "Name assocated with the EC2 instance - will be used as a prefix for the key alias as well"
}

#~~~~~OPTIONAL VARS~~~~
#Pin to AZ or allow Multi-AZ Deployment
variable "dms_instance_az" {
    default = "" #does this work
    description = "The EC2 Availability Zone that the replication instance will be created in."
}
variable "dms_instance_multi_az" {
    default = false
    description = "Specifies if the replication instance is a multi-az deployment. You cannot set the availability_zone parameter if the multi_az parameter is set to true."
}

