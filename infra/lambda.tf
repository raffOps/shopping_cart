resource "aws_lambda_function" "shopping_cart_api" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "../lambda.zip"
  function_name = "shopping_cart_api"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "adapters/rest/v1/handler.handler"
  timeout       = 60
  runtime = "python3.12"

  environment {
    variables = {
      env = "dev"
    }
  }
}

# Adicionando permissão para o API Gateway invocar a função Lambda
# Adicionando permissão para o API Gateway invocar a função Lambda
resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.shopping_cart_api.function_name  # Substitua pelo seu nome de função
  principal     = "apigateway.amazonaws.com"
}