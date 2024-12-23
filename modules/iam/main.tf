resource "aws_iam_role" "roles" {
  for_each = { for role in var.roles : role.name => role }

  name               = each.value.name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_policy" "policies" {
  for_each = { for role in var.roles : role.name => role }

  name   = "${each.key}-policy"
  policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      for policy in each.value.policies : {
        Effect   = "Allow"
        Action   = policy
        Resource = "*"
      }
    ]
  })
}

