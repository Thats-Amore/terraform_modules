# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These variables are expected to be passed in by the operator
# ---------------------------------------------------------------------------------------------------------------------

variable "aws_region" {
  description = "The AWS region in which all resources will be created"
}

variable "aws_account_id" {
  description = "The ID of the AWS Account in which to create resources."
}

variable "aws_account_alias" {
  description = "The AWS Account alias"
}

variable "vpc_name" {
  description = "Name of the VPC. Examples include 'prod', 'dev', 'mgmt', etc."
}

variable "ec2_instance_type" {
  description = "The type of instances to run for the Utility servers (e.g. t2.medium)"
}

variable "ec2_key_name" {
  description = "The name of the Key Pair that can be used to SSH into instance"
}

variable "terraform_state_aws_region" {
  description = "The AWS region of the S3 bucket used to store Terraform remote state"
}

variable "terraform_state_s3_bucket" {
  description = "The name of the S3 bucket used to store Terraform remote state"
}

variable "arn_region" {
  description = "Used to set appropriate arn values for Commercial (arn:aws:) or Govcloud (arn:aws-us-gov:)"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "hosted_zone_domain_name" {
  description = "Hosted Zone Name"
}

variable "pizza_hostname" {
  description = "Hostname of Utility instance"
}

variable "pizza_asg_instance_count" {
  description = "The number of instances spun up in each ASG"
}

variable "elk_environment" {
  description = "The elastic stack environment that logs will be sent to"
}

variable "pizza_bucket_name" {
  description = "The name of the bucket that this pizza instance will use"
}

variable "email_team_tag" {
  description = "Team to notify of non-critical AWS events related to Pizza"
  default     = "admins@thats-amore.com"
}
