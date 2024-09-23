resource "aws_iam_policy" "lambda_dynamodb" {
  name        = "lambda_dynamodb"
  path        = "/"
  description = "service for lambda function work with dynamodb table"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "DynamoDB",
        "Effect": "Allow",
        "Action": [
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:UpdateItem",
          "dynamodb:BatchWriteItem"
        ],
        "Resource": [
          "*"
        ]
      },
      {
        "Sid": "Logs",
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": [
          "*"
        ]
      }
    ]
  })

  tags = {
    env = "dev"
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name        = "iam_for_lambda"
  description = "Allows Lambda functions to call AWS services on your behalf."
  depends_on  = [aws_iam_policy.lambda_dynamodb]

  managed_policy_arns = [aws_iam_policy.lambda_dynamodb.arn]

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"  # Permitir que o API Gateway assuma
        }
      }
    ]
  })

  tags = {
    env = "dev"
  }
}


