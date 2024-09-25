import logging

import boto3
from fastapi import FastAPI
from fastapi.responses import JSONResponse
from mangum import Mangum

from adapters.rest.v1.dto import FirehoseCreateShoppingCart
from domain.errors import BadRequestError
from repositories.dynamodb import DynamoDBRepository

logger = logging.getLogger("v1/shopping_cart/rest")
dynamodb_resource = boto3.resource('dynamodb')
repo = DynamoDBRepository(dynamodb_resource)

app = FastAPI()


@app.get("/")
def root():
    return {"message": "Hello World!"}


@app.post("/v1/shopping_cart/")
def create(firehose_carts: FirehoseCreateShoppingCart) -> JSONResponse:
    try:
        carts = firehose_carts.to_shopping_carts()
        repo.write_cart(carts)
        return JSONResponse(
            status_code=200,
            content={
                "requestId": firehose_carts.requestId,
                "timestamp": firehose_carts.timestamp
            },
            headers={"Content-Type": "application/json"}
        )
    except BadRequestError as e:
        return JSONResponse(
            status_code=400,
            content={
                "errorMessage": e,
                "requestId": firehose_carts.requestId,
                "timestamp": firehose_carts.timestamp,
            },
            headers={"Content-Type": "application/json"}
        )
    except Exception as e:
        return JSONResponse(
            status_code=500,
            content={
                "errorMessage": e,
                "requestId": firehose_carts.requestId,
                "timestamp": firehose_carts.timestamp,
            },
            headers={"Content-Type": "application/json"}
        )


handler = Mangum(app)
