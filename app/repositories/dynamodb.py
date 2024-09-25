from abc import ABC
from typing import Any

from boto3.resources.factory import ServiceResource
from botocore.exceptions import ClientError

from domain.errors import InternalServerError
from domain.models.shopping_cart import ShoppingCart
from domain.ports import ShoppingCartWriterReaderRepositoryPort, ShoppingCartReaderRepositoryPort, \
    ShoppingCartWriterRepositoryPort


class DynamoDBRepository(ShoppingCartWriterReaderRepositoryPort, ShoppingCartReaderRepositoryPort,
                         ShoppingCartWriterRepositoryPort, ABC):

    def __init__(self, conn: ServiceResource):
        super().__init__()
        self.conn: Any = conn

    def read_cart_from_buyer_id(self, buyer_id: int) -> ShoppingCart:
        raise NotImplementedError

    def write_cart(self, carts: list[ShoppingCart]) -> None:
        table = self.conn.Table("ShoppingCart")
        try:
            with table.batch_writer() as writer:
                for cart in carts:
                    json_cart = cart.model_dump(mode="json")
                    writer.put_item(Item=json_cart)
        except ClientError as e:
            raise InternalServerError(f"Not possible put item {json_cart} to table. Error: {e}") from e
