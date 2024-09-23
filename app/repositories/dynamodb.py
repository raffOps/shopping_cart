from abc import ABC
from typing import Any

from boto3.resources.factory import ServiceResource
from botocore.exceptions import ClientError

from domain.errors import InternalServerError
from domain.models.shopping_cart import Shopping_Cart
from domain.ports import Shopping_Cart_Writer_Reader_Repository_Port, Shopping_Cart_Reader_Repository_Port, \
    Shopping_Cart_Writer_Repository_Port


class DynamoDBRepository(Shopping_Cart_Writer_Reader_Repository_Port, Shopping_Cart_Reader_Repository_Port,
                         Shopping_Cart_Writer_Repository_Port, ABC):

    def __init__(self, conn: ServiceResource):
        super().__init__()
        self.conn: Any = conn

    def read_cart_from_buyer_id(self, buyer_id: int) -> Shopping_Cart:
        pass

    def write_cart(self, carts: list[Shopping_Cart]) -> None:
        table = self.conn.Table("ShoppingCart")
        try:
            with table.batch_writer() as writer:
                for cart in carts:
                    json_cart = cart.model_dump(mode="json")
                    writer.put_item(Item=json_cart)
        except ClientError as e:
            raise InternalServerError(f"Not possible put item {json_cart} to table. Error: {e}") from e
