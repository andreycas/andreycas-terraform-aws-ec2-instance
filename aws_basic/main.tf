variable "aws_access_key" {}
variable "aws_secret_key" {}
//variable "aws_ami" {default = "ami-0080e4c5bc078760e"}
variable "aws_ami" {default = "ami-0e84e211558a022c0"}
variable "aws_security_group_id" {default = "default"}
variable "instance_type" {default = "t2.micro"}

provider "aws" {
  region     = "us-east-2"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_instance" "cda_instance" {
  ami                    = "${var.aws_ami}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${var.aws_security_group_id}"]  
  key_name	             = "johnny-key-us-east-1"
}
