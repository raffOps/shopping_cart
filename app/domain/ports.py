from abc import ABC, abstractmethod

from domain.models.shopping_cart import ShoppingCart


class ShoppingCartServicePort(ABC):

    @abstractmethod
    def create_cart(self, cart: ShoppingCart) -> ShoppingCart:
        pass


class ShoppingCartTopicRepositoryPort(ABC):

    @abstractmethod
    def publish_cart(self, cart: ShoppingCart) -> ShoppingCart:
        pass


class ShoppingCartWriterReaderRepositoryPort(ABC):
    @abstractmethod
    def read_cart_from_buyer_id(self, buyer_id: int) -> ShoppingCart:
        pass

    @abstractmethod
    def write_cart(self, carts: list[ShoppingCart]) -> None:
        pass


class ShoppingCartWriterRepositoryPort(ABC):
    @abstractmethod
    def write_cart(self, carts: list[ShoppingCart]) -> None:
        pass


class ShoppingCartReaderRepositoryPort(ABC):
    @abstractmethod
    def read_cart_from_buyer_id(self, buyer_id: int) -> ShoppingCart:
        pass
