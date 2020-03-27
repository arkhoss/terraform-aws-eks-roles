locals {

  # Policy Names
  AdminPolicy    = replace(join("-", [var.resources-prefix, var.policy-names[0]]), "/-.*/", var.policy-names[0])
  OpsPolicy      = replace(join("-", [var.resources-prefix, var.policy-names[1]]), "/-.*/", var.policy-names[1])
  ViewOnlyPolicy = replace(join("-", [var.resources-prefix, var.policy-names[2]]), "/-.*/", var.policy-names[2])

  # Role Names
  RoleForAdmins   = replace(join("-", [var.resources-prefix, var.roles-names[0]]), "/-.*/", var.roles-names[0])
  RoleForOps      = replace(join("-", [var.resources-prefix, var.roles-names[1]]), "/-.*/", var.roles-names[1])
  RoleForViewOnly = replace(join("-", [var.resources-prefix, var.roles-names[2]]), "/-.*/", var.roles-names[2])

}
