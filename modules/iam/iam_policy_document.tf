data "aws_iam_policy_document" "assume_role_policy" {
  for_each = { for role in var.roles : role.name => role }

  statement {
    actions = ["sts:AssumeRole"]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${each.value.name}"
    ]
  }
}

data "aws_caller_identity" "current" {}
