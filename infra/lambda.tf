resource "aws_lambda_function" "shopping_cart_api" {
  filename      = "../lambda.zip"
  function_name = "shopping_cart_api"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "adapters/rest/v1/handler.handler"
  timeout       = 60
  runtime       = "python3.12"

  environment {
    variables = {
      env = "dev"
    }
  }
}

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.shopping_cart_api.function_name
  principal     = "apigateway.amazonaws.com"
}