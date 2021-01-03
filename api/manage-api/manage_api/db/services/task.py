from __future__ import annotations

from collections import OrderedDict as ODict
from typing import Any, Dict, List, Optional, Iterator, Union, overload
from uuid import UUID

from marshmallow import EXCLUDE, Schema

from manage_api.db.models import db, update_db
from manage_api.db.models import task_group
from manage_api.db.models.project import Project
from manage_api.db.models.state import State
from manage_api.db.models.task import Task, TaskSchema
from manage_api.db.models.task_group import TaskGroup
from manage_api.db.services.helpers import query_builder
from manage_api.db.services.pagination import Paginable
from manage_api.misc.types import filter_type


__all__ = [
    'TaskService',
]


class TaskService(Paginable):

    obj: Optional[Task]
    _schema: Optional[Schema]

    @overload
    def __init__(
        self,
        dbobject: Task,
        joined_relations: List[str] = None,
    ):
        ...

    @overload
    def __init__(
        self,
        *,
        id: str,
        joined_relations: List[str] = None,
    ):
        ...

    @overload
    def __init__(
        self,
        *,
        id: UUID,
        joined_relations: List[str] = None,
    ):
        ...

    def __init__(
        self,
        dbobject: Task = None,
        *,
        id: Union[str, UUID] = None,
        joined_relations: List[str] = None,
    ):
        self.obj = None
        if dbobject:
            if not isinstance(dbobject, Task):
                raise TypeError('Wrong db object type')
            self.obj = dbobject
        elif id:
            obj = self._query(joined_relations=joined_relations).get(id)
            if obj is None:
                raise ValueError('Task with this id is not found')
            self.obj = obj
        else:
            raise ValueError('At least one parameter must be given.')
        self._schema = self.schema(joined_relations=joined_relations)

    @classmethod
    def create(cls, data: Dict, validate_unknown=True, commit=True) -> TaskService:
        if not data.get('project_id'):
            task_group = TaskGroup.query.get(data['task_group_id'])
            data['project_id'] = task_group.project_id
        if not data.get('team_id'):
            project = Project.query.get(data['project_id'])
            data['team_id'] = project.team_id
        if not data.get('state_id'):
            data['state_id'] = (
                State.query.filter(State.project_id == data['project_id'])
                .order_by(State.rank)
                .first()
                .id
            )
        if validate_unknown:
            schema = TaskSchema()
        else:
            schema = TaskSchema(unknown=EXCLUDE)
        validation = schema.validate(data)
        if len(validation) > 0:
            raise ValueError(f'Invalid Data: {validation}')
        dbobject: Task = schema.load(data)
        db.session.add(dbobject)
        update_db(commit)
        return cls(dbobject)

    @classmethod
    def get_all(
        cls,
        *,
        joined_relations: List[str] = None,
        filters: Dict[filter_type, Dict[str, Any]] = None,
        order_by: ODict[str, bool] = None,
    ) -> Iterator[TaskService]:
        return map(
            lambda task: cls(task),
            cls._query(
                joined_relations=joined_relations, filters=filters, order_by=order_by
            ).all(),
        )

    @classmethod
    def dump_all(
        cls,
        *,
        joined_relations: List[str] = None,
        schema: Optional[Schema] = None,
        filters: Dict[filter_type, Dict[str, Any]] = None,
        order_by: ODict[str, bool] = None,
    ) -> List[Dict[str, Any]]:
        schema = schema or cls.schema(joined_relations=joined_relations)
        return schema.dump(
            cls._query(
                joined_relations=joined_relations, filters=filters, order_by=order_by
            ).all(),
            many=True,
        )

    @staticmethod
    def schema(*args, joined_relations: List = None, **kwargs) -> TaskSchema:
        if joined_relations:
            fields_: List[str] = []
            for relation in joined_relations:
                if hasattr(TaskSchema, relation):
                    fields_.append(relation)
            return TaskSchema(*args, partial=fields_, **kwargs)
        return TaskSchema(*args, partial=True, **kwargs)

    def get(self, key: str, default: bool = None, strict: bool = False) -> Any:
        if not strict:
            return getattr(self.obj, key, default)
        else:
            return getattr(self.obj, key)

    def update(self, data: Dict[str, Any], commit=True):
        if self.obj is None:
            raise RuntimeError('Database object is null')
        for k, v in data.items():
            if hasattr(self.obj, k):
                setattr(self.obj, k, v)
        update_db(commit)

    def update_state(self, state_id: Union[str, UUID], commit=True) -> bool:
        if self.obj is None:
            raise RuntimeError('Database object is null')
        if str(self.obj.state_id) == str(state_id):
            return False
        self.obj.state_id = state_id
        update_db(commit)
        return True

    def delete(self, commit=True):
        if self.obj is None:
            raise RuntimeError('Database object is null')
        db.session.delete(self.obj)
        update_db(commit)
        self.obj = None

    def dump(self) -> Dict[str, Any]:
        return self.__dict__()

    @staticmethod
    def _query(
        *,
        joined_relations: List[str] = None,
        filters: Dict[filter_type, Dict[str, Any]] = None,
        order_by: ODict[str, bool] = None,
    ):
        query = query_builder(
            Task,
            joined_relations=joined_relations,
            filters=filters,
            order_by=order_by,
        )
        return query

    # Operator overloading

    def __getitem__(self, key):  # []
        return self.get(key, strict=True)

    def __dict__(self):
        return TaskSchema().dump(self.obj)

    def __iter__(self):  # dict() list()
        for k, v in self.__dict__().items():
            yield (k, v)
