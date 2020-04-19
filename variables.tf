variable "resources_prefix" {
  type        = string
  default     = ""
  description = "This variable will be a prefix for each IAM Role and Policy"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name in AWS"
}

variable "master_user" {
  type        = string
  description = "Master cluster user, in case aws-auth roles don't work"
}

variable "policy_names" {
  type        = list
  default     = ["EKS-AdminPolicy", "EKS-OpsPolicy", "EKS-ViewOnlyPolicy"]
  description = "IAM policy names"
}

variable "roles_names" {
  type        = list
  default     = ["EKS-AdminsRole", "EKS-OpsRole", "EKS-ViewOnlyRole"]
  description = "IAM role names"
}

variable "cluster_role_qty" {
  type        = number
  default     = 3
  description = "amount of ClusterRoles to be provisioned, it helps with local iterations"
}

variable "cluster_roles" {
  type = list
  default = [
    "cluster-role-cluster-admin",
    "cluster-role-cluster-operations",
    "cluster-role-cluster-viewonly"
  ]
  description = "ClusterRoles to be provisioned in EKS"
}

variable "cluster_role_binding_qty" {
  type        = number
  default     = 3
  description = "amount of ClusterRolesBinding to be provisioned, it helps with local iterations"
}

variable "cluster_roles_binding" {
  type = list
  default = [
    "cluster-role-binding-cluster-admin",
    "cluster-role-binding-cluster-operations",
    "cluster-role-binding-cluster-viewonly"
  ]
  description = "ClusterRolesBinding to be provisioned in EKS"
}

variable "local_kube_context" {
  type        = string
  description = "Local kubectl context to be used to provision"
}

variable "overwrite_aws_auth" {
  type        = bool
  default     = false
  description = "WARNING!!! If true it will override the aws-auth ConfigMap of your cluster"
}

variable "cluster_nodes_role" {
  type        = string
  description = "IAM Role ARN used by EKS Cluster Nodes, a.k.a Cluster IAM Role ARN"
}

variable "tags" {
  type    = map(string)
  default = { "Name" = "" }
}
