resource "aws_s3_bucket" "lambda" {
  bucket = "serverless-lambda-dev"

  tags = {
    env = "dev"
  }
}