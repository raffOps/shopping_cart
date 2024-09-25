resource "aws_sns_topic" "shopping_cart" {
  name = "shopping_cart"

}

resource "aws_kinesis_firehose_delivery_stream" "kinesis_to_dynamo_stream" {
  name        = "shopping-cart-processing-stream"
  destination = "http_endpoint"
  depends_on  = [aws_iam_role.kinesis_lambda]

  http_endpoint_configuration {
    url                = "${aws_api_gateway_stage.dev.invoke_url}/v1/shopping_cart/"
    name               = "sns-to-lambda"
    buffering_size     = 15
    buffering_interval = 60
    role_arn           = aws_iam_role.kinesis_lambda.arn
    s3_backup_mode     = "FailedDataOnly"
    s3_configuration {
      bucket_arn         = aws_s3_bucket.firehose-dead-letter-queue.arn
      role_arn           = aws_iam_role.kinesis_lambda.arn
      compression_format = "Snappy"
    }

    cloudwatch_logging_options {
      enabled        = false
      log_group_name = "/aws/sns/shopping-cart-processing-stream"
    }

    secrets_manager_configuration {
      enabled = false
    }
  }
}

resource "aws_sns_topic_subscription" "shopping_cart_sub" {
  topic_arn             = aws_sns_topic.shopping_cart.arn
  protocol              = "firehose"
  endpoint              = aws_kinesis_firehose_delivery_stream.kinesis_to_dynamo_stream.arn
  subscription_role_arn = aws_iam_role.sns_kinesis.arn
  raw_message_delivery  = true
}