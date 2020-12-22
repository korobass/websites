{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "${env}001",
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:GetItem",
        "dynamodb:Query",
        "dynamodb:Scan",
        "dynamodb:DescribeTable"
      ],
      "Resource": [
        "arn:aws:dynamodb:${region}:${account_id}:table/${table}"
      ]
    }
  ]
}