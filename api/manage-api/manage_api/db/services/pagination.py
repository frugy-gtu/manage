from abc import abstractmethod, ABC
from typing import Optional, TypeVar, Generic, Iterator, List, Type, Any, Dict
from marshmallow import Schema
from flask_sqlalchemy import Pagination, BaseQuery


class Paginable(ABC):
    @staticmethod
    @abstractmethod
    def schema(*args, joined_relations: List = None, **kwargs) -> Schema:
        raise NotImplementedError()

    @abstractmethod
    def __init__(self, dbobject: Any):
        raise NotImplementedError()


T = TypeVar('T', bound=Paginable)


class PaginationService(Generic[T]):

    joined_relations: Optional[List[str]]
    pagination: Pagination
    type: Type[T]

    def __init__(
        self,
        member_class: Type[T],
        query: BaseQuery,
        per_page: int,
        page: int,
        joined_relations: List[str] = None,
        pagination: Pagination = None,
    ) -> None:
        self.type = member_class
        self.joined_relations = joined_relations
        if pagination:
            self.pagination = pagination
        else:
            self.pagination = query.paginate(per_page=per_page, page=page)

    def items(self) -> Iterator[T]:
        return map(lambda item: self.type(item), self.pagination.items)

    def dump(self) -> List[Dict[str, Any]]:
        schema = self.type.schema(joined_relations=self.joined_relations)
        return schema.dump(self.pagination.items, many=True)

    def has_next(self):
        return self.pagination.has_next

    def has_prev(self):
        return self.pagination.has_prev

    def pages(self):
        return self.pagination.pages

    def prev(self):
        return PaginationService(
            self.type, None, None, None, pagination=self.pagination.prev
        )

    def next(self):
        return PaginationService(
            self.type, None, None, None, pagination=self.pagination.next
        )

    def total(self):
        return self.pagination.total
