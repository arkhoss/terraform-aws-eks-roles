variable "resources-prefix" {
  type        = string
  default     = ""
  description = "This variable will be a prefix for each IAM Role and Policy"
}

variable "cluster-name" {
  type        = string
  description = "EKS cluster name in AWS"
}

variable "master-user" {
  type        = string
  description = "Master cluster user, in case aws-auth roles don't work"
}

variable "policy-names" {
  type        = list
  default     = ["EKS-AdminPolicy", "EKS-OpsPolicy", "EKS-ViewOnlyPolicy"]
  description = "IAM policy names"
}

variable "roles-names" {
  type        = list
  default     = ["EKS-AdminsRole", "EKS-OpsRole", "EKS-ViewOnlyRole"]
  description = "IAM role names"
}

variable "cluster-role-qty" {
  type        = number
  default     = 3
  description = "amount of ClusterRoles to be provisioned, it helps with local iterations"
}

variable "cluster-roles" {
  type = list
  default = [
    "cluster-role-cluster-admin",
    "cluster-role-cluster-operations",
    "cluster-role-cluster-viewonly"
  ]
  description = "ClusterRoles to be provisioned in EKS"
}

variable "cluster-role-binding-qty" {
  type        = number
  default     = 3
  description = "amount of ClusterRolesBinding to be provisioned, it helps with local iterations"
}

variable "cluster-roles-binding" {
  type = list
  default = [
    "cluster-role-binding-cluster-admin",
    "cluster-role-binding-cluster-operations",
    "cluster-role-binding-cluster-viewonly"
  ]
  description = "ClusterRolesBinding to be provisioned in EKS"
}

variable "local-kube-context" {
  type        = string
  description = "Local kubectl context to be used to provision"
}

variable "overwrite-aws-auth" {
  type        = bool
  default     = false
  description = "WARNING!!! If true it will override the aws-auth ConfigMap of your cluster"
}

variable "cluster-nodes-role" {
  type        = string
  description = "IAM Role ARN used by EKS Cluster Nodes, a.k.a Cluster IAM Role ARN"
}

variable "tags" {
  type    = map(string)
  default = { "Name" = "" }
}

