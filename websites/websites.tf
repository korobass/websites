variable "s3_bucket_name" {
}

variable "s3_bucket_tags" {
  type                      = map(string)
}

variable "dynamodb_tags" {
  type                      = map(string)
}

variable "dynamodb_properties" {
  type                      = map(string)
}

variable "env" {
  type                      = string
}

module "websites" {
  providers                 = {
    aws.us-east-1-region    = aws.us-east-1-region
  }

  source                    = "../modules/websites"

  env                       = var.env
  s3_bucket_name            = "${var.env}-${var.s3_bucket_name}"
  s3_tags                   = var.s3_bucket_tags
  dynamodb_properties       = var.dynamodb_properties
  dynamodb_tags             = var.dynamodb_tags
}