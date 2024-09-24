variable "project" {
  default = "raffops"
}
variable "region" {
  default = "us-east-1"
}

output "api_invoke_url" {
  value       = aws_api_gateway_deployment.dev.invoke_url
}

output "shopping_cart_topic" {
  value = aws_sns_topic.shopping_cart.arn
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.shopping_cart.arn
}

output "bucket_dead_letter" {
  value = aws_s3_bucket.firehose-dead-letter-queue.arn
}