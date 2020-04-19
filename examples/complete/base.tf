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

variable "resources-prefix" {
  type = string
}

variable "cluster-name" {
  type = string
}

variable "master-user" {
  type        = string
  description = "Master cluster user, in case aws-auth roles don't work"
}

variable "policy-names" {
  type = list
}

variable "roles-names" {
  type = list
}

variable "cluster-role-qty" {
  type = number
}

variable "cluster-roles" {
  type = list
}

variable "cluster-role-binding-qty" {
  type = number
}

variable "cluster-roles-binding" {
  type = list
}

variable "local-kube-context" {
  type = string
}

variable "overwrite-aws-auth" {
  type = bool
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

  resources_prefix         = var.resources-prefix
  cluster_name             = var.cluster-name
  master_user              = var.master-user
  policy_names             = var.policy-names
  roles_names              = var.roles-names
  cluster_role_qty         = var.cluster-role-qty
  cluster_roles            = var.cluster-roles
  cluster_role_binding_qty = var.cluster-role-binding-qty
  cluster_roles_binding    = var.cluster-roles-binding
  local_kube_context       = var.local-kube-context
  overwrite_aws_auth       = var.overwrite-aws-auth
  cluster_nodes_role       = var.cluster-nodes-role
  tags                     = var.tags
}
