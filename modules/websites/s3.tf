resource "aws_s3_bucket" "s3_bucket" {
  bucket             = var.s3_bucket_name
  tags               = var.s3_tags

  versioning {
    enabled          = var.bucket_versioning
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions          = ["s3:GetObject"]
    resources        = ["${aws_s3_bucket.s3_bucket.arn}/*"]

    principals {
      type           = "AWS"
      identifiers    = [aws_cloudfront_origin_access_identity.cdn.iam_arn]
    }
  }

  statement {
    actions          = ["s3:ListBucket"]
    resources        = [aws_s3_bucket.s3_bucket.arn]

    principals {
      type           = "AWS"
      identifiers    = [aws_cloudfront_origin_access_identity.cdn.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket-policy" {
  bucket             = aws_s3_bucket.s3_bucket.id
  policy             = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_s3_bucket_object" "site1" {
  for_each           = var.upload_sample_site ? fileset("${path.module}/kitten_web", "**/*") : []
  bucket             = aws_s3_bucket.s3_bucket.id
  key                = each.value
  source             = "${path.module}/kitten_web/${each.value}"
  etag               = filemd5("${path.module}/kitten_web/${each.value}")
}
resource "aws_s3_bucket_object" "site2" {
  for_each           = var.upload_sample_site ? fileset("${path.module}/kitten_web", "**/*") : []
  bucket             = aws_s3_bucket.s3_bucket.id
  key                = "kitten_web/${each.value}"
  source             = "${path.module}/kitten_web/${each.value}"
  etag               = filemd5("${path.module}/kitten_web/${each.value}")
}

output "fileset-results" {
  value              = fileset("${path.module}/kitten_web/", "**/*")
}