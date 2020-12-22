data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  region                = data.aws_region.current.name
  account_id            = data.aws_caller_identity.current.account_id
}

data "aws_iam_policy_document" "assume_policy" {
  statement {
    sid                 = "Domains1"
    actions             = ["sts:AssumeRole"]

    principals {
      type              = "Service"
      identifiers       = ["lambda.amazonaws.com"]
    }
  }
}

# AWS IAM Role for domains lambda
resource "aws_iam_role" "role" {
  name                  = local.dynamodb_name
  assume_role_policy    = data.aws_iam_policy_document.assume_policy.json
}

data "template_file" "policy" {
  template              = file("${path.module}/policies/dynamodb.json.tpl")
  vars                  = {
    table               = local.dynamodb_name
    region              = local.region
    account_id          = local.account_id
    env                 = var.env
  }
}

resource "aws_iam_policy" "policy" {
  name                  = local.dynamodb_name
  description           = "Access to dynamodb table"
  policy                = data.template_file.policy.rendered
}

resource "aws_iam_role_policy_attachment" "attachment" {
  policy_arn            = aws_iam_policy.policy.arn
  role                  = aws_iam_role.role.name
}