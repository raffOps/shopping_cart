from abc import ABC
from typing import Any

from boto3.resources.factory import ServiceResource

from domain.errors import InternalServerError
from domain.models.shopping_cart import Shopping_Cart
from domain.ports import Shopping_Cart_Writer_Reader_Repository_Port, Shopping_Cart_Reader_Repository_Port, \
    Shopping_Cart_Writer_Repository_Port


class DynamoDBRepository(Shopping_Cart_Writer_Reader_Repository_Port, Shopping_Cart_Reader_Repository_Port,
                         Shopping_Cart_Writer_Repository_Port, ABC):

    def __init__(self, conn: ServiceResource):
        super().__init__()
        self.conn: Any = conn
        try:
            create_cart_table(self.conn)
        except Exception as e:
            raise InternalServerError("Not possible to create cart table") from e

    def read_cart(self, cart: Shopping_Cart) -> Shopping_Cart:
        pass

    def write_cart(self, cart: Shopping_Cart) -> Shopping_Cart:
        pass


def create_cart_table(conn: Any) -> None:
    table = conn.create_table(
        TableName='ShoppingCart',
        KeySchema=[
            {
                'AttributeName': 'buyer_id',
                'KeyType': 'HASH'
            },
            {
                'AttributeName': 'product_id',
                'KeyType': 'RANGE'
            }
        ],
        AttributeDefinitions=[
            {
                'AttributeName': 'buyer_id',
                'AttributeType': 'N'
            },
            {
                'AttributeName': 'product_id',
                'AttributeType': 'N'
            },
            {
                'AttributeName': 'purchase_date',
                'AttributeType': 'S'
            }
        ],
        BillingMode='PAY_PER_REQUEST',
        GlobalSecondaryIndexes=[
            {
                'IndexName': 'PurchaseDateIndex',
                'KeySchema': [
                    {
                        'AttributeName': 'purchase_date',
                        'KeyType': 'HASH'
                    },
                    {
                        'AttributeName': 'buyer_id',
                        'KeyType': 'RANGE'
                    }
                ],
                'Projection': {
                    'ProjectionType': 'INCLUDE',
                    'NonKeyAttributes': ['product_id', 'number_of_installments', 'total_amount']
                },
            }
        ]
    )

    table.meta.client.get_waiter('table_exists').wait(TableName='ShoppingCart')
