from fastapi import FastAPI
from fastapi.responses import JSONResponse
from mangum import Mangum

from domain.models.shopping_cart import Shopping_Cart


app = FastAPI()
handler = Mangum(app)

#
@app.get("/create/")
async def create(cart: Shopping_Cart) -> JSONResponse:
    return JSONResponse(content=cart.model_dump())