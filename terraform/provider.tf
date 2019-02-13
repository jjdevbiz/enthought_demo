variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "pub_key" {}
variable "pvt_key" {}
variable "ssh_fingerprint" {}
variable "rds_username" {}
variable "rds_password" {}
variable "hosted_zone_id" {}
variable "secretHash" {}
variable "defaultSubnet" {}

# Configure the AWS Provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-east-1"
}
