terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }
}

variable "aws_region" {
  default = "eu-west-1"
}

variable "tags" {
  type = map(string)
}

variable "cluster-name" {
  type = string
}

variable "master-user" {
  type        = string
  description = "Master cluster user, in case aws-auth roles don't work"
}

variable "local-kube-context" {
  type = string
}

variable "cluster-nodes-role" {
  type = string
}

provider "aws" {
  region  = var.aws_region
  profile = "sandbox"
}

module "kubernetes-roles" {
  source = "../../../modules/terraform-aws-eks-roles"

  cluster_name       = var.cluster-name
  master_user        = var.master-user
  local_kube_context = var.local-kube-context
  cluster_nodes_role = var.cluster-nodes-role
  tags               = var.tags
}
