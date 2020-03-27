
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

