from datetime import date
from pydantic import BaseModel


class Shopping_Cart(BaseModel):
    id: int | None = None
    buyer_id: int
    product_id: int
    number_of_installments: int
    total_amount: int
    purchase_date: date