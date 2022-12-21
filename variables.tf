#variables related to the provider region.
variable "aws_region" {
    description = "Provider region to create services."
    type = string
    default = "ap-south-1"
}
#variables related to VPC and Security group.
variable "vpc_cidr" {
    description = "VPC cidr"
    type = string
    default = "10.20.0.0/16"
}

variable "security_group_name" {
    description = "Name of the security group"
    type = string
    default = "traffic"
}

#variables related to S3 buckets.
variable "first_bucket_name" {
    description = "Name of the first bucket"
    type = string
    default = "created-to-upload-images"
}

variable "second_bucket_name" {
    description = "Name of the second bucket"
    type = string
    default = "after-triggering-lambda" 
}

#variables related to RDS database
variable "database_name" {
    description = "Database name"
    type = string
    default = "mydb"
}

variable "database_username" {
    description = "Database username"
    type = string
    default = "root"
}

variable "database_password" {
    description = "DB password"
    type = string
    default = "shivakumar"
}

#variable related to lambda function
variable "lambda_function_name" {
    description = "Lambda function name"
    type = string
    default = "hello"
}

#variables related to ECS cluster
variable "ecs_cluster_name" {
    description = "ECS cluster name"
    type = string
    default = "travelly"
}

variable "task_definition_name" {
    description = "Task definition name"
    type = string
    default = "travelly_task"
}

variable "ecs_service_name" {
    description = "ECS service name"
    type = string
    default = "travelly"
}