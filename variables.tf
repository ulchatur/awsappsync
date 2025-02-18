variable "api_name" {}
variable "authentication_type" {}
variable "schema_file" {}
variable "dynamodb_table_name" {}


variable "visibility" {}
variable "tags" {}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

