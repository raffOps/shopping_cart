resource "aws_ecr_repository" "lambda" {
  name                 = "lambda_cart"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}