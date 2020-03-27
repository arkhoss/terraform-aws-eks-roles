
output "iam_policy_KubernetesAdminPolicy" {
  description = "KubernetesAdminPolicy ARN"
  value       = aws_iam_policy.KubernetesAdminPolicy.arn
}

output "iam_policy_KubernetesOpsPolicy" {
  description = "KubernetesOpsPolicy ARN"
  value       = aws_iam_policy.KubernetesOpsPolicy.arn
}

output "iam_policy_KubernetesViewOnlyPolicy" {
  description = "KubernetesViewOnlyPolicy ARN"
  value       = aws_iam_policy.KubernetesViewOnlyPolicy.arn
}

output "iam_role_KubernetesAdminRole" {
  description = "KubernetesAdminRole ARN"
  value       = aws_iam_role.KubernetesAdminRole.arn
}

output "iam_role_KubernetesOpsRole" {
  description = "KubernetesOpsRole ARN"
  value       = aws_iam_role.KubernetesOpsRole.arn
}

output "iam_role_KubernetesViewOnlyRole" {
  description = "KubernetesViewOnlyRole ARN"
  value       = aws_iam_role.KubernetesViewOnlyRole.arn
}

