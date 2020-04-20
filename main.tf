data "aws_caller_identity" "current" {}

resource "local_file" "aws-auth" {
  content = templatefile("${path.module}/cluster-configmap/aws-auth.tmpl", {
    account_id         = data.aws_caller_identity.current.account_id,
    role_for_admins    = join("-", [local.RoleForAdmins, var.cluster_name]),
    role_for_ops       = join("-", [local.RoleForOps, var.cluster_name]),
    role_for_viewonly  = join("-", [local.RoleForViewOnly, var.cluster_name])
    master_user        = var.master_user
    cluster_nodes_role = var.cluster_nodes_role
  })
  filename = "${path.cwd}/aws-auth.yml"
}

resource "aws_iam_policy" "KubernetesAdminPolicy" {
  name        = join("-", [local.AdminPolicy, var.cluster_name])
  path        = "/"
  description = "KubernetesAdmin policy to access kubernetes cluster"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "eks:DescribeCluster",
              "eks:ListClusters"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${join("-", [local.RoleForAdmins, var.cluster_name])}"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "KubernetesOpsPolicy" {
  name        = join("-", [local.OpsPolicy, var.cluster_name])
  path        = "/"
  description = "Kubernetes operations policy to access kubernetes cluster"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "eks:DescribeCluster",
              "eks:ListClusters"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${join("-", [local.RoleForOps, var.cluster_name])}"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "KubernetesViewOnlyPolicy" {
  name        = join("-", [local.ViewOnlyPolicy, var.cluster_name])
  path        = "/"
  description = "Kubernetes view only policy to access kubernetes cluster"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "eks:DescribeCluster",
              "eks:ListClusters"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Resource": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${join("-", [local.RoleForViewOnly, var.cluster_name])}"
        }
    ]
}
EOF
}

resource "aws_iam_role" "KubernetesAdminRole" {
  name                  = join("-", [local.RoleForAdmins, var.cluster_name])
  path                  = "/"
  description           = "Provides access to kubernetes admin users."
  force_detach_policies = false
  tags                  = var.tags
  assume_role_policy    = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  depends_on = [
    aws_iam_policy.KubernetesAdminPolicy
  ]

}

resource "aws_iam_role" "KubernetesOpsRole" {
  name                  = join("-", [local.RoleForOps, var.cluster_name])
  path                  = "/"
  description           = "Provides access to kubernetes operations users."
  force_detach_policies = false
  tags                  = var.tags

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  depends_on = [
    aws_iam_policy.KubernetesOpsPolicy
  ]

}

resource "aws_iam_role" "KubernetesViewOnlyRole" {
  name                  = join("-", [local.RoleForViewOnly, var.cluster_name])
  path                  = "/"
  description           = "Provides access to kubernetes view only users."
  force_detach_policies = false
  tags                  = var.tags

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

  depends_on = [
    aws_iam_policy.KubernetesViewOnlyPolicy
  ]

}

resource "aws_iam_role_policy_attachment" "KubernetesAdminRole" {
  role       = aws_iam_role.KubernetesAdminRole.name
  policy_arn = aws_iam_policy.KubernetesAdminPolicy.arn

  depends_on = [
    aws_iam_policy.KubernetesAdminPolicy,
    aws_iam_role.KubernetesAdminRole
  ]
}

resource "aws_iam_role_policy_attachment" "KubernetesOpsRole" {
  role       = aws_iam_role.KubernetesOpsRole.name
  policy_arn = aws_iam_policy.KubernetesOpsPolicy.arn

  depends_on = [
    aws_iam_policy.KubernetesOpsPolicy,
    aws_iam_role.KubernetesOpsRole
  ]
}

resource "aws_iam_role_policy_attachment" "KubernetesViewOnlyRole" {
  role       = aws_iam_role.KubernetesViewOnlyRole.name
  policy_arn = aws_iam_policy.KubernetesViewOnlyPolicy.arn

  depends_on = [
    aws_iam_policy.KubernetesViewOnlyPolicy,
    aws_iam_role.KubernetesViewOnlyRole
  ]
}

resource "null_resource" "set-local-kube-context" {
  provisioner "local-exec" {
    command     = "kubectl config use-context ${var.local_kube_context}"
    interpreter = ["sh", "-c"]
  }
}

resource "null_resource" "setup-cluster-roles" {
  count = var.cluster_role_qty
  provisioner "local-exec" {
    command     = "kubectl apply -f ${path.module}/cluster-roles/${var.cluster_roles[count.index]}.yml"
    interpreter = ["sh", "-c"]
  }

  depends_on = [
    null_resource.set-local-kube-context
  ]
}

resource "null_resource" "setup-cluster-binding" {
  count = var.cluster_role_binding_qty
  provisioner "local-exec" {
    command     = "kubectl apply -f ${path.module}/cluster-roles-binding/${var.cluster_roles_binding[count.index]}.yml"
    interpreter = ["sh", "-c"]
  }

  depends_on = [
    null_resource.set-local-kube-context
  ]
}

resource "null_resource" "setup-config-map" {

  count = var.overwrite_aws_auth ? 1 : 0

  provisioner "local-exec" {
    command     = "kubectl apply -f ${path.cwd}/aws-auth.yml"
    interpreter = ["sh", "-c"]
  }

  depends_on = [
    null_resource.set-local-kube-context,
    local_file.aws-auth
  ]
}
