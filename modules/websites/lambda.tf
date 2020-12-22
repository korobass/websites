data "aws_iam_policy_document" "edge_assume_policy" {
  statement {
    sid                 = "LambdaEdge"
    actions             = ["sts:AssumeRole"]

    principals {
      type              = "Service"
      identifiers       = [
        "lambda.amazonaws.com",
        "edgelambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  provider              = aws.us-east-1-region
  name                  = "${var.env}-lambda"
  assume_role_policy    = data.aws_iam_policy_document.edge_assume_policy.json
}

data "archive_file" "index_node" {
  type                  = "zip"
  source_file           = "${path.module}/index.js"
  output_path           = "${path.module}/index.zip"
}

resource "aws_lambda_function" "lambda" {
  provider              = aws.us-east-1-region
  source_code_hash      = data.archive_file.index_node.output_base64sha256
  function_name         = "${var.env}-domain1"
  role                  = aws_iam_role.lambda_role.arn
  handler               = "index.handler"
  runtime               = "nodejs12.x"
  filename              = "${path.module}/index.zip"
  publish               = true

  lifecycle {
    ignore_changes      = [
      source_code_hash,
      last_modified,
      qualified_arn,
      version
    ]
  }
}