from __future__ import annotations

from collections import OrderedDict as ODict
from typing import Any, Dict, List, Optional, Iterator, Union, overload
from uuid import UUID

from marshmallow import EXCLUDE, Schema

from manage_api.db.models import db, update_db
from manage_api.db.models.team import Team, TeamSchema
from manage_api.db.models.user_teams import UserTeams
from manage_api.db.services.helpers import query_builder
from manage_api.db.services.pagination import Paginable
from manage_api.misc.types import filter_type


__all__ = [
    'TeamService',
]


class TeamService(Paginable):

    obj: Optional[Team]
    _schema: Optional[Schema]

    @overload
    def __init__(
        self,
        dbobject: Team,
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
        dbobject: Team = None,
        *,
        id: Union[str, UUID] = None,
        joined_relations: List[str] = None,
    ):
        self.obj = None
        if dbobject:
            if not isinstance(dbobject, Team):
                raise TypeError('Wrong db object type')
            self.obj = dbobject
        elif id:
            obj = Team.query.get(id)
            if obj is None:
                raise ValueError('Team with this id is not found')
            self.obj = obj
        else:
            raise ValueError('At least one parameter must be given.')
        self._schema = self.schema(joined_relations=joined_relations)

    @classmethod
    def create(cls, data: Dict, validate_unknown=True, commit=True) -> TeamService:
        if validate_unknown:
            schema = TeamSchema()
        else:
            schema = TeamSchema(unknown=EXCLUDE)
        validation = schema.validate(data)
        if len(validation) > 0:
            raise ValueError(f'Invalid Data: {validation}')
        dbobject: Team = schema.load(data)
        db.session.add(dbobject)
        update_db(False)
        db.session.add(UserTeams(user_id=dbobject.user_id, team_id=dbobject.id))
        update_db(commit)
        return cls(dbobject)

    @classmethod
    def get_all(
        cls,
        *,
        joined_relations: List[str] = None,
        filters: Dict[filter_type, Dict[str, Any]] = None,
        order_by: ODict[str, bool] = None,
    ) -> Iterator[TeamService]:
        return map(
            lambda project: cls(project),
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
    def schema(*args, joined_relations: List = None, **kwargs) -> TeamSchema:
        if joined_relations:
            fields_: List[str] = []
            for relation in joined_relations:
                if hasattr(TeamSchema, relation):
                    fields_.append(relation)
            return TeamSchema(*args, partial=fields_, **kwargs)
        return TeamSchema(*args, partial=True, **kwargs)

    def get(self, key: str, default: bool = None, strict: bool = False) -> Any:
        if not strict:
            return getattr(self.obj, key, default)
        else:
            return getattr(self.obj, key)

    def check_password(self, password: str):
        if self.obj is None:
            raise RuntimeError('Database object is null')
        return self.obj.check_password(password)

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
            Team,
            joined_relations=joined_relations,
            filters=filters,
            order_by=order_by,
        )
        special_filters = filters.get('special') if filters else None
        if special_filters:
            user = special_filters.get('user')
            if user:
                query = query.join(UserTeams, UserTeams.team_id == Team.id).filter(
                    UserTeams.user_id == user
                )
        return query

    # Operator overloading

    def __getitem__(self, key):  # []
        return self.get(key, strict=True)

    def __dict__(self):
        return TeamSchema().dump(self.obj)

    def __iter__(self):  # dict() list()
        for k, v in self.__dict__().items():
            yield (k, v)
