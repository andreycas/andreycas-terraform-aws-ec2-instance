variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_ami" {default = "ami-0080e4c5bc078760e"}
variable "aws_security_group_id" {default = "sg-495c840a"}
variable "instance_type" {default = "t2.micro"}
variable "cda_server" {default = "http://STOZH01L7480/cda"}
variable "cda_user" {default = "100/AUTOMIC/AUTOMIC"}
variable "cda_password" {default = ""}

provider "aws" {
  region     = "us-east-1"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_instance" "cda_instance" {
  ami                    = "${var.aws_ami}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${var.aws_security_group_id}"]
	
  tags = {
    Name = "pet-shop-prod"
  }
}

provider "cda" {
  cda_server     = "${var.cda_server}"
 // user           = "${var.cda_user}"
 // password       = "${var.cda_password}"  
	
  default_attributes = { // default_attributes can be used to set the 'folder' and 'owner' attributes globally for the template.
    folder = "DEFAULT"
    owner  = "100/AUTOMIC/AUTOMIC"
  }
}
 
resource "cda_environment" "demoEnvironment" {
  name               = "${aws_instance.cda_instance.tags.Name}"
  type               = "Production"
  
  deployment_targets = ["${cda_deployment_target.demoTarget.name}"]
}

resource "cda_deployment_target" "demoTarget" {
  name        = "Tomcat"
  type        = "Tomcat"
  //agent       = "WIN01" //TODO Install the Agent
}
/*
resource "cda_login_object" "my_login_object" {
  name        = "test_login_object-${local.id}"
  folder      = "DEFAULT"
  owner       = "100/AUTOMIC/AUTOMIC"

  credentials = [
    {
      agent      = "*"
      type       = "WINDOWS"
      username   = "Agent_User"
      password   = "automic"
    }
  ]
}

resource "cda_deployment_profile" "my_deployment_profile" {
  name         = "test_profile-${local.id}"
  application  = "IM Test App"
  environment  = "${cda_environment.firstEnvironment.name}"
  login_object = "${cda_login_object.my_login_object.name}"

  deployment_map = {
    "${var.component_name}" = "${cda_deployment_target.jenys_target.name}, Local Tomcat"
    "Component B" = "Local Tomcat"
  }
}

resource "cda_workflow_execution" "my_execution" {
  triggers                     = "true"
  application                  = "application" 
  workflow                     = "workflow name" 
  package                      = "package" 
  deployment_profile           = "my_deployment_profile" 
  override_existing_components = "false"	
}
*/	