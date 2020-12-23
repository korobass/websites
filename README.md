# websites

Static websites hosted on S3 using CloudFront and lambda@edge


## Feautres

* cloudfront distribution with basic WAF ACLs
* Lambda@Edge triggered by Cloudfront events 
* optionally Route53 custom domain for CF
* dynamodb table with read/write capacity autoscaling
* IAM role to provide access to dynamodb table
* optinonally example kitten_web website

## Terraform workspace creation

By default it is using local states

    cd websites
    terraform init
    terraform apply -auto-approve -var aws_role=your_iam_role_name

## Example usage using Cloudfront URL

    curl -v https://cf-distribution/
    curl -v https://cf-distribution/kitten_web

## Reference documentation

Implementing Default Directory Indexes in Amazon S3-backed Amazon CloudFront Origins Using Lambda@Edge
https://aws.amazon.com/blogs/compute/implementing-default-directory-indexes-in-amazon-s3-backed-amazon-cloudfront-origins-using-lambdaedge/
