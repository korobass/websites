

locals {
  # use this local variable to hardcode your IAM role
  default_role           = {
    arn                  = "arn:aws:iam::${var.account_id}:role/MyHardcodedRole"
    session_name         = "MySession"
  }

  # use this local variable to provide role name as -var aws_role=""
  input_role             = {
    arn                  = "arn:aws:iam::${var.account_id}:role/${var.aws_role}"
    session_name         = var.aws_role
  }
}

provider "aws" {
  version                = "~> 3.22.0"
  region                 = var.default_region
  allowed_account_ids    = [var.account_id]
  assume_role {
    role_arn             = var.aws_role == "default" ? local.default_role.arn : local.input_role.arn
    session_name         = var.aws_role == "default" ? local.default_role.session_name : local.input_role.session_name
  }
}

provider "aws" {
  version                = "~> 3.22.0"
  region                 = var.cf_region
  alias                  = "us-east-1-region"

  allowed_account_ids    = [var.account_id]
  assume_role {
    role_arn             = var.aws_role == "default" ? local.default_role.arn : local.input_role.arn
    session_name         = var.aws_role == "default" ? local.default_role.session_name : local.input_role.session_name
  }
}

terraform {
  required_version       = ">= 0.13"
}