
/*
# 1️⃣ Create the IAM Role
resource "aws_iam_role" "deckhouse" {
  name = "deckhouse-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# 2️⃣ Create the IAM Policy from JSON file
resource "aws_iam_policy" "deckhouse" {
  name   = "deckhouse-policy"
  policy = file("${path.module}/policy.json")
}

# 3️⃣ Attach the policy to the role
resource "aws_iam_role_policy_attachment" "deckhouse_attach" {
  role       = aws_iam_role.deckhouse.name
  policy_arn = aws_iam_policy.deckhouse.arn
}

*/