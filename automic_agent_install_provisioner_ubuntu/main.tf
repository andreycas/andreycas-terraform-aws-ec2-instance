provider "aws" {
	region     = "us-east-1"
	access_key = "${var.aws_access_key}"
  	secret_key = "${var.aws_secret_key}"
}

resource "aws_instance" "cda_instance" {
  	ami                    = "${var.aws_ami}"
  	instance_type          = "${var.instance_type}"
  	vpc_security_group_ids = ["${var.aws_security_group_id}"]
  	key_name	         = "terraform_keys"
	
  	tags = {
    		Name = "pet-shop-prod"
  	}

  	provisioner "automic_agent_install" {
  		destination = "${var.remote_working_dir}"
    		source = "C:\\Terraform\\EM\\Binaries\\linux"

    		agent_name = "${random_string.append_string.result}"
    		agent_port = "${var.agent_port}"
    		ae_system_name = "${var.ae_system_name}"
    		ae_host = "${var.ae_host}"
    		ae_port = "${var.ae_port}"
    		sm_port = "${var.sm_port}"
    		sm_name = "${var.sm_name}${random_string.append_string.result}"

    		variables = {
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

resource "random_string" "append_string" {
	length  = 10
	special = false
	lower   = false
}


