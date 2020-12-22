s3_bucket_name              = "domains"
s3_bucket_tags              = {}
dynamodb_tags               = {}
env                         = "poc"

dynamodb_properties         = {
  name                      = "domains"
  billing_mode              = "PROVISIONED"
  point_in_time_recovery    = false
  stream_enabled            = false
  max_capacity              = 2
  min_capacity              = 1
}