resource "aws_api_gateway_rest_api" "api" {
  name        = "shopping_cart"
}

resource "aws_api_gateway_model" "create_shopping_cart" {
  rest_api_id  = aws_api_gateway_rest_api.api.id
  name         = "createShoppingCart"
  content_type = "application/json"

  schema = jsonencode({
    "type": "array",
    "items": {
      "type": "object",
      "properties": {
        "buyer_id": {
          "type": "integer"
        },
        "product_id": {
          "type": "integer"
        },
        "number_of_installments": {
          "type": "integer"
        },
        "total_amount": {
          "type": "integer"
        },
        "purchase_date": {
          "type": "string",
          "format": "date-time"
        }
      },
      "required": [
        "buyer_id",
        "product_id",
        "number_of_installments",
        "total_amount",
        "purchase_date"
      ]
    }
  }
  )
}

resource "aws_api_gateway_resource" "v1" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  path_part   = "v1"
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
}

resource "aws_api_gateway_resource" "shopping_cart" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  path_part   = "shopping_cart"
  parent_id   = aws_api_gateway_resource.v1.id
}


resource "aws_api_gateway_method" "post" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.shopping_cart.id
  http_method   = "POST"
  authorization = "NONE"
  request_models = {
    "application/json" = aws_api_gateway_model.create_shopping_cart.name
  }
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.shopping_cart.id
  http_method             = aws_api_gateway_method.post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.shopping_cart_api.invoke_arn
}

resource "aws_api_gateway_deployment" "dev" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.dev.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "dev"
}