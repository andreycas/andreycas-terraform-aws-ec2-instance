locals {
	in_id = "${random_string.password.result}"
}

resource "random_string" "password" {
  length = 10
  special = false
}

provider "aws" {
	region     = "us-east-1"
	access_key = "${var.aws_access_key}"
	secret_key = "${var.aws_secret_key}"
}

resource "aws_instance" "cda_instance" {
	ami                    = "${var.aws_ami}"
	instance_type          = "t3.xlarge"
	vpc_security_group_ids = ["${var.aws_security_group_id}"]
//	vpc_security_group_ids = "default"
//	key_name	       = "${var.aws_key_name}"
//	key_name	= "jeny-key-us-east-1"
        key_name	= "terraform_keys"	

	user_data = <<HEREDOC
		#!/bin/bash
		yum update -y
		yum install -y docker
		service docker start
		usermod -aG docker ec2-user
		curl -L https://github.com/docker/compose/releases/download/1.21.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose	
		chmod +x /usr/local/bin/docker-compose
		sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
		yum install -y git
		mkdir  /tmp/jenya
                cd /tmp/jenya
		git clone git://github.com/jenyss/requestbin.git
		cd requestbin
		docker-compose build
		docker-compose up -d
		cd /tmp
		printf '%s\n' '{"Source": "johnny.castro@arus.com.co", "Template": "MyTemplateJ_${local.in_id}", "ConfigurationSetName": "ConfigSet", "Destination": {"ToAddresses": [ "jenya.stoeva@broadcom.com"]}, "TemplateData": "{}"}' >myemail1.json
		export AWS_ACCESS_KEY_ID=${var.aws_access_key} 
		export AWS_SECRET_ACCESS_KEY=${var.aws_secret_key}
		export AWS_DEFAULT_REGION=us-east-1
		aws ses send-templated-email --cli-input-json file://myemail1.json
	HEREDOC
}

resource "aws_ses_template" "MyTemplateJ" {
	name    = "MyTemplateJ_${local.in_id}"
	subject = "Greetings, Johnny!"
	html    = "<h1>Hello johnny,</h1><p>Your app url is http://${aws_instance.cda_instance.*.public_ip[0]}.</p>"
	text    = "Hello johnny, Your app url is http://${aws_instance.cda_instance.*.public_ip[0]}."
}

output "public_ip" {
	description = "List of public IP addresses assigned to the instances, if applicable"
	value = "${aws_instance.cda_instance.*.public_ip[0]}"
}

output "id" {
	description = "List of IDs of instances"
	value       = "${aws_instance.cda_instance.*.id[0]}"
}

output "availability_zone" {
	description = "List of availability zones of instances"
	value       = "${aws_instance.cda_instance.*.availability_zone[0]}"
}

output "key_name" {
	description = "List of key names of instances"
	value       = "${aws_instance.cda_instance.*.key_name[0]}"
}

output "public_dns" {
	description = "List of public DNS names assigned to the instances. For EC2-VPC, this is only available if you've enabled DNS hostnames for your VPC"
	value       = "${aws_instance.cda_instance.*.public_dns[0]}"
}
/*
output "network_interface_id" {
	description = "List of IDs of the network interface of instances"
	value       = "${aws_instance.cda_instance.*.network_interface_id[0]}"
}

output "primary_network_interface_id" {
	description = "List of IDs of the primary network interface of instances"
	value       = "${aws_instance.cda_instance.*.primary_network_interface_id[0]}"
}

output "private_dns" {
	description = "List of private DNS names assigned to the instances. Can only be used inside the Amazon EC2, and only available if you've enabled DNS hostnames for your VPC"
	value       = "${aws_instance.cda_instance.*.private_dns[0]}"
}

output "private_ip" {
	description = "List of private IP addresses assigned to the instances"
	value       = "${aws_instance.cda_instance.*.private_ip[0]}"
}

output "security_groups" {
	description = "List of associated security groups of instances"
	value       = "${aws_instance.cda_instance.*.security_groups[0]}"
}

output "vpc_security_group_ids" {
	description = "List of associated security groups of instances, if running in non-default VPC"
	value       = "${aws_instance.cda_instance.*.vpc_security_group_ids[0]}"
}

output "subnet_id" {
	description = "List of IDs of VPC subnets of instances"
	value       = "${aws_instance.cda_instance.*.subnet_id[0]}"
}
*/
