locals {
  dynamodb_name = "${var.env}-${var.dynamodb_properties["name"]}"
}

resource "aws_dynamodb_table" "table" {
  name                          = local.dynamodb_name
  billing_mode                  = var.dynamodb_properties["billing_mode"]
  read_capacity                 = 1
  write_capacity                = 1
  # It is recommended to use lifecycle ignore_changes for read_capacity and/or write_capacity if there's autoscaling policy attached to the table.
  lifecycle {
    ignore_changes              = [
    read_capacity,
    write_capacity
    ]
  }

  # KeySchema
  hash_key                      = "path"
# attribiutes of schema
  attribute {
    name                        = "path"
    type                        = "S"
  }

  stream_enabled                = var.dynamodb_properties["stream_enabled"]
  point_in_time_recovery {
    enabled                     = var.dynamodb_properties["point_in_time_recovery"]
  }
  tags                          = var.dynamodb_tags
}

# use existing service role for DynamoDB autoscaling
data "aws_iam_role" "autoscale-service-linked-role" {
  name                          = "AWSServiceRoleForApplicationAutoScaling_DynamoDBTable"
}
# read capacity autoscaling
resource "aws_appautoscaling_target" "table_read_target" {
  depends_on                    = [
    aws_dynamodb_table.table,
    data.aws_iam_role.autoscale-service-linked-role
  ]
  max_capacity                  = var.dynamodb_properties["max_capacity"]
  min_capacity                  = var.dynamodb_properties["min_capacity"]
  resource_id                   = "table/${local.dynamodb_name}"
  role_arn                      = data.aws_iam_role.autoscale-service-linked-role.arn
  scalable_dimension            = "dynamodb:table:ReadCapacityUnits"
  service_namespace             = "dynamodb"
}


resource "aws_appautoscaling_policy" "dynamodb_table_read_policy" {
  name                          = "DynamoDBReadCapacityUtilization:${aws_appautoscaling_target.table_read_target.resource_id}"
  policy_type                   = "TargetTrackingScaling"
  resource_id                   = aws_appautoscaling_target.table_read_target.resource_id
  scalable_dimension            = aws_appautoscaling_target.table_read_target.scalable_dimension
  service_namespace             = aws_appautoscaling_target.table_read_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type    = "DynamoDBReadCapacityUtilization"
    }

    target_value                = 70
  }
}
# write capacity autoscaling
resource "aws_appautoscaling_target" "table_write_target" {
  depends_on                    = [
    aws_dynamodb_table.table,
    data.aws_iam_role.autoscale-service-linked-role
  ]
  max_capacity                  = var.dynamodb_properties["max_capacity"]
  min_capacity                  = var.dynamodb_properties["min_capacity"]
  resource_id                   = "table/${local.dynamodb_name}"
  role_arn                      = data.aws_iam_role.autoscale-service-linked-role.arn
  scalable_dimension            = "dynamodb:table:WriteCapacityUnits"
  service_namespace             = "dynamodb"
}

resource "aws_appautoscaling_policy" "dynamodb_table_write_policy" {
  name                          = "DynamoDBWriteCapacityUtilization:${aws_appautoscaling_target.table_write_target.resource_id}"
  policy_type                   = "TargetTrackingScaling"
  resource_id                   = aws_appautoscaling_target.table_write_target.resource_id
  scalable_dimension            = aws_appautoscaling_target.table_write_target.scalable_dimension
  service_namespace             = aws_appautoscaling_target.table_write_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type    = "DynamoDBWriteCapacityUtilization"
    }

    target_value                = 70
  }
}