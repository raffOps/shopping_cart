import logging

import boto3
from fastapi import FastAPI
from fastapi.responses import JSONResponse
from mangum import Mangum

from domain.models.shopping_cart import Shopping_Cart
from repositories.dynamodb import DynamoDBRepository

logger = logging.getLogger("v1/shopping_cart/rest")
dynamodb_resource = boto3.resource('dynamodb')
repo = DynamoDBRepository(dynamodb_resource)

app = FastAPI()

@app.get("/")
def root():
    return {"message": "Hello World!"}


@app.post("/v1/shopping_cart/")
def create(carts: list[Shopping_Cart]) -> JSONResponse:
    logger.info(carts)
    try:
        repo.write_cart(carts)
        return JSONResponse(status_code=201, content={"message": "Cart created"})
    except Exception as e:
        return JSONResponse(status_code=200, content={"message": f"Internal Server Error: {e}"})


handler = Mangum(app)
