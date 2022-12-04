terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "devfloors"

    workspaces {
      name = "terraform-k8s-boilerplate-bastion"
    }
  }
}

output "context" {
  value =  yamldecode(file(var.config_file)).context
}

output "config" {
  value = yamldecode(templatefile(var.config_file, local.context))
}

locals {
  context = yamldecode(file(var.config_file)).context
  config  = yamldecode(templatefile(var.config_file, local.context))
}

provider "aws" {
  region = "ap-northeast-2"
  shared_credentials_file = "~/.aws/credentials"
}

