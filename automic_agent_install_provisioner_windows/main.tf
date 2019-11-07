variable "aws_access_key" {}
variable "aws_secret_key" {}
//variable "aws_ami" {default = "ami-0080e4c5bc078760e"}
variable "aws_ami" {default = "ami-04b9e92b5572fa0d1"}
variable "aws_security_group_id" {default = "sg-495c840a"}
variable "instance_type" {default = "t2.micro"}
variable "cda_server" {default = "http://STOZH01L7480/cda"}
variable "cda_user" {default = "100/AUTOMIC/AUTOMIC"}
variable "cda_password" {}
//variable "cda_server" {default = "http://vviedev01.sbb01.spoc.global/cda"}
//variable "cda_user" {default = "100/BOND/AUTOMIC"}
//variable "cda_password" {default = "bond"}
//variable "remote_working_dir" {default = "/home/ec2-user/AE"}
variable "remote_working_dir" {default = "/home/ubuntu/AE"}
variable "private_key_file" {default = "C:\\Terraform\\EM\\AWS_Key\\jeny-key-us-east-1.pem"}
variable "package" {default = "no-package"}

provider "aws" {
  region     = "us-east-1"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_instance" "cda_instance" {
  ami                    = "${var.aws_ami}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${var.aws_security_group_id}"]
  key_name	         = "jeny-key-us-east-1"
	
  tags = {
    Name = "pet-shop-prod"
  }
  
  provisioner "remote-exec" {
	inline = [
		"mkdir -p ${var.remote_working_dir}",
		"mkdir -p ${var.remote_working_dir}/scripts"
	]

	connection {
		type        = "ssh"
		host        = self.public_ip 
		user        = "ubuntu"
		private_key = "${file("${var.private_key_file}")}"
	}
  }

   provisioner "automic_agent_install" {
    destination = "${var.remote_working_dir}"
    source = "C:\\Users\\tp674035\\Documents\\Projects\\go-workspace\\src\\terraform-provisioner-cda\\artifacts\\unix\\install"

    //agent_name_prefix = "${var.agent_name_prefix}"
    agent_name = "${random_string.cda_entity_name.result}"
    agent_port = "${var.agent_port}"
    ae_system_name = "${var.ae_system_name}"
    ae_host = "${var.ae_host}"
    ae_port = "${var.ae_port}"
    sm_port = "${var.sm_port}"
    sm_name = "${var.sm_name}${random_string.cda_entity_name.result}"
    //agent_password = "${var.agent_pass}"

    variables = {
      UC_EX_PATH_JOBREPORT = "../tmp"
      UC_EX_PATH_TEMP = "../tmp"
      UC_EX_ACBC = "ABC"
      UC_EX_IP_ADDR = "${self.public_ip}"
    }

    connection {
      host = self.public_ip
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("${var.private_key_file}")}"
    }
  }   
}

