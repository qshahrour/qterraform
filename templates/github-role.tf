#######################################################
#               GitHub OIDC Provider
#######################################################
data "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
#  client_id_list = ["sts.amazonaws.com"]
#  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}
#######################################################
#           IAM Role for GitHub Actions
#######################################################
#resource "aws_iam_role" "github_actions_eks" {
#  name = "github-actions-eks-role"
#
#  assume_role_policy = jsonencode({
#    Version = "2012-10-17"
#    Statement = [{
#      Effect = "Allow"
#      Principal = {
#        Federated = data.aws_iam_openid_connect_provider.github.arn
#      }
#      Action = "sts:AssumeRoleWithWebIdentity"
#      Condition = {
#        StringEquals = {
#          "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
#        }
#        StringLike = {
#          "token.actions.githubusercontent.com:sub" = "repo:${var.github_owner}/${var.github_repo}:*"
#        }
#      }
#    }]
#  })
#}
#######################################################
#             Attach Policy to Role
#######################################################
#resource "aws_iam_role_policy_attachment" "attach_eks_admin" {
#  role       = aws_iam_role.github_actions_eks.name
#  policy_arn = var.eks_admin_policy_arn
#}
#
# ----------------------
# Outputs
# ----------------------
#output "github_actions_role_arn" {
#  value       = aws_iam_role.github_actions_eks.arn
#  description = "The IAM Role ARN to use in GitHub Secrets"
#}
