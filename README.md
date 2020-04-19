# terraform-aws-eks-roles

A terraform module to create all necessary resources for Admin, Operations and ViewOnly AWS policies/roles and its respective ClusterRoles, ClusterRoleBindings and its ConfigMap aws-auth. Inspired by and adapted from [this doc](https://www.terraform.io/docs/providers/aws/guides/eks-getting-started.html) and its [source code](https://github.com/terraform-providers/terraform-provider-aws/tree/master/examples/eks-getting-started).
Read the [AWS docs on EKS to get connected to the k8s dashboard](https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html).

## Assumptions

* You have an EKS cluster in an AWS Account
* You have an AWS CLI with access to AWS Account were EKS cluster exist
* You have an AWS user with sufficient permissions to create IAM policies and IAM roles
* You have a kubeconfig file with access as system:master to the EKS Cluster


## Usage example

A full example is contained in the [examples/basic directory](https://gitlab.com/arkhoss/terraform-aws-eks-roles/-/tree/master/examples).

```hcl

module "kubernetes-roles" {
    source             = "./terraform-aws-eks-roles"

    cluster_name             = var.cluster-name
    master_user              = var.master-user
    local_kube_context       = var.local-kube-context
    cluster_nodes_role       = var.cluster-nodes-role
    tags                     = var.tags
}

```
## Conditional creation

### Need more roles? <!--- TODO: Add here instructions to do multiple roles  -->
Sometimes you need to have a way to create other roles, you can add them using the variables, also including the yml files in `cluster-roles` and `cluster-roles-binding` folders. Keep in mind the variables `cluster-role-qty` and `cluster-role-binding-qty` must be increased or reduced according. And final you need to crate the resources, locals and outputs for each new role.

### dry-run for aws-auth.yml
The variable `overwrite-aws-auth` will allow you to generate the aws-auth.yml file without apply, so you can review it, edit or whatever you need from it. By default, this variable is false.

```hcl

variable "overwrite-aws-auth" {
  type        = bool
  default     = false
  description = "WARNING!!! If true it will override the aws-auth ConfigMap of your cluster"
}

```

## Other documentation

* [IAM Permissions](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/iam-permissions.md): Minimum IAM permissions needed to setup EKS Cluster.
* [EKS FAQ](https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/faq.md): Frequently Asked Questions

## Doc generation

Code formatting and documentation for variables and outputs is generated using [pre-commit-terraform hooks](https://github.com/antonbabenko/pre-commit-terraform) which uses [terraform-docs](https://github.com/segmentio/terraform-docs).

Follow [these instructions](https://github.com/antonbabenko/pre-commit-terraform#how-to-install) to install pre-commit locally.

And install `terraform-docs` with `go get github.com/segmentio/terraform-docs` or `brew install terraform-docs`.

## Contributing

Report issues/questions/feature requests on in the [issues](https://gitlab.com/arkhoss/terraform-aws-eks-roles/-/issues) section.

Full contributing [guidelines are covered here](https://gitlab.com/arkhoss/terraform-aws-eks-roles/-/blob/master/CONTRIBUTING.md).

## Change log

The [changelog](https://gitlab.com/arkhoss/terraform-aws-eks-roles/-/blob/master/CHANGELOG.md) captures all important release notes from v1.0.0

## Authors

Created by:

- David Caballero [Gitlab](https://gitlab.com/arkhoss) | [Github](https://github.com/arkhoss) | d@dcaballero.net

## License

MIT License

Copyright (c) 2020 The terraform-aws-eks-roles module Authors.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Providers

| Name | Version |
|------|---------|
| aws | >= 2.54.0 |
| local | >= 1.4.0 |
| null | >= 2.1.2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| cluster-name | EKS cluster name in AWS | `string` | n/a | yes |
| cluster-nodes-role | IAM Role ARN used by EKS Cluster Nodes, a.k.a Cluster IAM Role ARN | `string` | n/a | yes |
| cluster-role-binding-qty | amount of ClusterRolesBinding to be provisioned, it helps with local iterations | `number` | `3` | no |
| cluster-role-qty | amount of ClusterRoles to be provisioned, it helps with local iterations | `number` | `3` | no |
| cluster-roles | ClusterRoles to be provisioned in EKS | `list` | <pre>[<br>  "cluster-role-cluster-admin",<br>  "cluster-role-cluster-operations",<br>  "cluster-role-cluster-viewonly"<br>]</pre> | no |
| cluster-roles-binding | ClusterRolesBinding to be provisioned in EKS | `list` | <pre>[<br>  "cluster-role-binding-cluster-admin",<br>  "cluster-role-binding-cluster-operations",<br>  "cluster-role-binding-cluster-viewonly"<br>]</pre> | no |
| local-kube-context | Local kubectl context to be used to provision | `string` | n/a | yes |
| master-user | Master cluster user, in case aws-auth roles don't work | `string` | n/a | yes |
| overwrite-aws-auth | WARNING!!! If true it will override the aws-auth ConfigMap of your cluster | `bool` | `false` | no |
| policy-names | IAM policy names | `list` | <pre>[<br>  "EKS-AdminPolicy",<br>  "EKS-OpsPolicy",<br>  "EKS-ViewOnlyPolicy"<br>]</pre> | no |
| resources-prefix | This variable will be a prefix for each IAM Role and Policy | `string` | `""` | no |
| roles-names | IAM role names | `list` | <pre>[<br>  "EKS-AdminsRole",<br>  "EKS-OpsRole",<br>  "EKS-ViewOnlyRole"<br>]</pre> | no |
| tags | n/a | `map(string)` | <pre>{<br>  "Name": ""<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| iam\_policy\_KubernetesAdminPolicy | KubernetesAdminPolicy ARN |
| iam\_policy\_KubernetesOpsPolicy | KubernetesOpsPolicy ARN |
| iam\_policy\_KubernetesViewOnlyPolicy | KubernetesViewOnlyPolicy ARN |
| iam\_role\_KubernetesAdminRole | KubernetesAdminRole ARN |
| iam\_role\_KubernetesOpsRole | KubernetesOpsRole ARN |
| iam\_role\_KubernetesViewOnlyRole | KubernetesViewOnlyRole ARN |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->