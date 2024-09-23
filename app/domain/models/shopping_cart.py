from datetime import datetime

from pydantic import BaseModel


class Shopping_Cart(BaseModel):
    buyer_id: int
    product_id: int
    number_of_installments: int
    total_amount: int
    purchase_date: datetime
