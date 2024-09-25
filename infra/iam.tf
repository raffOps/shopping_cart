resource "aws_iam_policy" "lambda_dynamodb" {
  name        = "lambda_dynamodb"
  path        = "/"
  description = "service for lambda function work with dynamodb table"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "DynamoDB",
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:Scan",
          "dynamodb:Query",
          "dynamodb:UpdateItem",
          "dynamodb:BatchWriteItem"
        ],
        "Resource" : [
          "*"
        ]
      },
      {
        "Sid" : "Logs",
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : [
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
          Service = "apigateway.amazonaws.com" # Permitir que o API Gateway assuma
        }
      }
    ]
  })

  tags = {
    env = "dev"
  }
}


resource "aws_iam_policy" "sns_kinesis" {
  name        = "sns_kinesis"
  path        = "/"
  description = "IAM for sns send messages to kinesis"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "firehose:DescribeDeliveryStream",
          "firehose:ListDeliveryStreams",
          "firehose:ListTagsForDeliveryStream",
          "firehose:PutRecord",
          "firehose:PutRecordBatch"
        ],
        "Resource" : [
          "*",
        ],
        "Effect" : "Allow"
      }
    ]
  })

  tags = {
    env = "dev"
  }
}

resource "aws_iam_role" "sns_kinesis" {
  name        = "sns_kinesis"
  description = "Allow sns topics to call AWS services on your behalf."
  depends_on  = [aws_iam_policy.sns_kinesis]

  managed_policy_arns = [aws_iam_policy.sns_kinesis.arn]

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "sns.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    env = "dev"
  }
}

resource "aws_iam_policy" "kinesis_lambda" {
  name        = "kinesis_lambda"
  path        = "/"
  description = "IAM for sns send messages to kinesis"

  policy = jsonencode({
    "Statement" : [
      {
        "Action" : [
          "s3:*"
        ],
        "Effect" : "Allow",
        "Resource" : [
          aws_s3_bucket.firehose-dead-letter-queue.arn,
          "${aws_s3_bucket.firehose-dead-letter-queue.arn}/*",
        ]
        "Sid" : "s3Permissions"
      },
      {
        "Action" : [
          "firehose:*",
          "logs:*"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "*"
        ],
        "Sid" : "cloudWatchLog"
      },
      {
        "Action" : [
          "execute-api:*",
          "lambda:*",
          "lambda:*"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "*"
        ],
        "Sid" : "lambdaProcessing"
      }
    ],
    "Version" : "2012-10-17"
  })

  tags = {
    env = "dev"
  }
}

resource "aws_iam_policy" "kinesis_lambda2" {
  name = "kinesis_lambda2"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "GetSecretValue",
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "DecryptSecretWithKMSKey",
        "Effect" : "Allow",
        "Action" : [
          "kms:Decrypt"
        ],
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "kms:ViaService" : [
              "secretsmanager.us-east-1.amazonaws.com"
            ]
          }
        }
      },
      {
        "Sid" : "DataFormatConversion",
        "Effect" : "Allow",
        "Action" : [
          "glue:GetTable",
          "glue:GetTableVersion",
          "glue:GetTableVersions"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "mskSourcePermissions",
        "Effect" : "Allow",
        "Action" : [
          "kafka:GetBootstrapBrokers",
          "kafka:DescribeCluster",
          "kafka:DescribeClusterV2",
          "kafka-cluster:Connect"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "toReadMSKData",
        "Effect" : "Allow",
        "Action" : [
          "kafka-cluster:DescribeTopic",
          "kafka-cluster:DescribeTopicDynamicConfiguration",
          "kafka-cluster:ReadData"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "toDescribeMSKGroup",
        "Effect" : "Allow",
        "Action" : [
          "kafka-cluster:DescribeGroup"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "s3Permissions",
        "Effect" : "Allow",
        "Action" : [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "lambdaProcessing",
        "Effect" : "Allow",
        "Action" : [
          "lambda:InvokeFunction",
          "lambda:GetFunctionConfiguration"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "s3Encryption",
        "Effect" : "Allow",
        "Action" : [
          "kms:GenerateDataKey",
          "kms:Decrypt"
        ],
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "kms:ViaService" : "s3.us-east-1.amazonaws.com"
          },
          "StringLike" : {
            "kms:EncryptionContext:aws:s3:arn" : [
              "*"
            ]
          }
        }
      },
      {
        "Sid" : "cloudWatchLog",
        "Effect" : "Allow",
        "Action" : [
          "logs:PutLogEvents"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "KDSSourcePermissions",
        "Effect" : "Allow",
        "Action" : [
          "kinesis:DescribeStream",
          "kinesis:GetShardIterator",
          "kinesis:GetRecords",
          "kinesis:ListShards"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "KDSEncryption",
        "Effect" : "Allow",
        "Action" : [
          "kms:Decrypt"
        ],
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "kms:ViaService" : "kinesis.us-east-1.amazonaws.com"
          },
          "StringLike" : {
            "kms:EncryptionContext:aws:kinesis:arn" : "*"
          }
        }
      }
    ]
    }
  )
}

resource "aws_iam_role" "kinesis_lambda" {
  name        = "kinesis_lambda"
  description = "Allow kinesis to call AWS services on your behalf."

  managed_policy_arns = [aws_iam_policy.kinesis_lambda.arn, aws_iam_policy.kinesis_lambda2.arn]

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "firehoseAssume",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "firehose.amazonaws.com"
        },
        "Action" : "sts:AssumeRole",
      }
    ]
  })

  tags = {
    env = "dev"
  }
}