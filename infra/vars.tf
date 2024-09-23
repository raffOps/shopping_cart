variable "region" {
  default = "us-east-1"
}

output "api_invoke_url" {
  value       = aws_api_gateway_deployment.dev.invoke_url
  description = "URL to invoke the API"
}