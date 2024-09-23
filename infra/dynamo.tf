resource "aws_dynamodb_table" "shopping_cart" {
  name         = "ShoppingCart"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "buyer_id"
  range_key = "purchase_date"

  attribute {
    name = "buyer_id"
    type = "N"
  }

  attribute {
    name = "product_id"
    type = "N"
  }

  attribute {
    name = "purchase_date"
    type = "S"
  }

  global_secondary_index {
    name            = "PurchaseDateIndex"
    hash_key        = "product_id"
    range_key       = "buyer_id"
    projection_type = "INCLUDE"

    non_key_attributes = ["purchase_date", "number_of_installments", "total_amount"]
  }

  tags = {
    env = "dev"
  }
}