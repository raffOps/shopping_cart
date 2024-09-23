from abc import ABC

from app.domain.ports import Shopping_Cart_Service_Port, Shopping_Cart_Writer_Reader_Repository_Port
from domain.errors import NotFoundError, InternalServerError, BadRequestError
from domain.models.shopping_cart import Shopping_Cart


class Shopping_Cart_Service(Shopping_Cart_Service_Port, ABC):

    def __init__(self, repository: Shopping_Cart_Writer_Reader_Repository_Port):
        super().__init__()
        self.repository: Shopping_Cart_Writer_Reader_Repository_Port = repository

    def create_cart(self, cart: Shopping_Cart) -> Shopping_Cart:
        try:
            created_cart = self.repository.write_cart(cart)
        except [NotFoundError, BadRequestError, InternalServerError] as e:
            raise e
        except Exception:
            raise InternalServerError
        else:
            return created_cart
