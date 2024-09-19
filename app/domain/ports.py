from abc import ABC, abstractmethod

from domain.models.shopping_cart import Shopping_Cart

class Shopping_Cart_Service_Port(ABC):
    
    @abstractmethod
    def create_cart(self, cart: Shopping_Cart) -> Shopping_Cart:
        pass
    
class Shopping_Cart_Writer_Reader_Repository_Port(ABC):
    @abstractmethod
    def read_cart(self, cart: Shopping_Cart) -> Shopping_Cart:
        pass
    
    @abstractmethod
    def write_cart(self, cart: Shopping_Cart) -> Shopping_Cart:
        pass
    
class Shopping_Cart_Writer_Repository_Port(ABC):
    @abstractmethod
    def write_cart(self, cart: Shopping_Cart) -> Shopping_Cart:
        pass
    
class Shopping_Cart_Reader_Repository_Port(ABC):
    @abstractmethod
    def read_cart(self, cart: Shopping_Cart) -> Shopping_Cart:
        pass