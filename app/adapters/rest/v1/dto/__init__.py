import base64
import json
from typing import Any

from pydantic import BaseModel

from domain.errors import BadRequestError
from domain.models.shopping_cart import ShoppingCart


class FirehoseCreateShoppingCart(BaseModel):
    requestId: str
    timestamp: int
    records: list[dict[str, Any]]

    def to_shopping_carts(self) -> list[ShoppingCart]:
        carts: list[ShoppingCart] = []
        for record in self.records:
            try:
                json_payload = base64.b64decode(record["data"]).decode('utf-8')
                dict_payload = json.loads(json_payload)
                carts.append(ShoppingCart(**dict_payload))
            except Exception as e:
                raise BadRequestError(f"Error parsing cart b64 to json: {e}")
        return carts
