locals {

  # Policy Names
  AdminPolicy    = replace(join("-", [var.resources_prefix, var.policy_names[0]]), "/-.*/", var.policy_names[0])
  OpsPolicy      = replace(join("-", [var.resources_prefix, var.policy_names[1]]), "/-.*/", var.policy_names[1])
  ViewOnlyPolicy = replace(join("-", [var.resources_prefix, var.policy_names[2]]), "/-.*/", var.policy_names[2])

  # Role Names
  RoleForAdmins   = replace(join("-", [var.resources_prefix, var.roles_names[0]]), "/-.*/", var.roles_names[0])
  RoleForOps      = replace(join("-", [var.resources_prefix, var.roles_names[1]]), "/-.*/", var.roles_names[1])
  RoleForViewOnly = replace(join("-", [var.resources_prefix, var.roles_names[2]]), "/-.*/", var.roles_names[2])

}
