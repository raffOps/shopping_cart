from datetime import datetime

from pydantic import BaseModel


class ShoppingCart(BaseModel):
    buyer_id: int
    product_id: int
    number_of_installments: int
    total_amount: int
    purchase_date: datetime
