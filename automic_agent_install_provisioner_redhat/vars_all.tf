variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_ami" {default = "ami-0551d2acb56d6e88c"}
variable "aws_security_group_id" {default = "sg-495c840a"}
variable "instance_type" {default = "t2.micro"}
variable "remote_working_dir" {default = "/home/ec2-user/AE"}
variable "private_key_file" {default = "C:\\Terraform\\EM\\AWS_Key\\jeny-key-us-east-1.pem"}
variable "agent_port" {default = "2300"}
variable "ae_system_name" {default = "AUTOMIC"}
variable "ae_host" {default = "3.88.27.73"}
variable "ae_port" {default = "2217"}
variable "sm_port" {default = "8871"}
variable "sm_name" {default = "sm_"}
