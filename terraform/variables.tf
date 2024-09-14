# the values of all these variables are asigned by the terragrunt.hcl file in thie directory
variable "region" {
  description = "AWS region"
  type        = string
}

variable "bucket_name" {
  description = "unique bucket name"
  type        = string
}

variable "owner_name" {
  description = "owner_name"
  type        = string
}

variable "tags" {
  description = "tags"
  type = map(string)
}