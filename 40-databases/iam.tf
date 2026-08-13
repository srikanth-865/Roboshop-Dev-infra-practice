resource "aws_iam_role" "mysql" {
  name = "${local.common_name}-mysql-root-password"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = merge(
    local.common_tags,
    {
        Name = "${local.common_name}-mysql"
    }
  )
  }

  resource "aws_iam_policy" "mysql" {
  name        = "${local.common_name}-mysql-root-password"
  path        = "/"
  description = "policy for getting & describing out mysql parameter to attach mysql instance"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy =   file("mysql-iam-policy.json")
  }

resource "aws_iam_policy_attachment" "mysql" {
  name = "${local.common_name}-mysql"
  roles      = [aws_iam_role.mysql.name]
  policy_arn = aws_iam_policy.mysql.arn
}

resource "aws_iam_instance_profile" "mysql" {
  name = "${local.common_name}-mysql"
  role = aws_iam_role.mysql.name
}

