class DomainError(Exception):
    """Erro base para o domínio."""
    pass


class BadRequestError(DomainError):
    def __init__(self, message):
        super().__init__(message)


class NotFoundError(DomainError):
    def __init__(self, message):
        super().__init__(message)


class InternalServerError(DomainError):
    def __init__(self, message):
        super().__init__(message)
