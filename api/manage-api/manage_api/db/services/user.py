from __future__ import annotations

from collections import OrderedDict as ODict
from typing import Any, Dict, List, Optional, Iterator, Union, overload
from uuid import UUID

from flask_jwt_extended import create_access_token
from marshmallow import EXCLUDE, Schema

from manage_api.db.models import db, update_db
from manage_api.db.models.team import Team
from manage_api.db.models.user import User, UserSchema
from manage_api.db.models.user_profile import UserProfile, UserProfileSchema
from manage_api.db.models.user_teams import UserTeams
from manage_api.db.services.helpers import query_builder
from manage_api.db.services.pagination import Paginable
from manage_api.misc.types import filter_type

__all__ = [
    'Userervice',
]


class UserService(Paginable):

    obj: Optional[User]
    _schema: Optional[Schema]

    @overload
    def __init__(
        self,
        dbobject: User,
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

    @overload
    def __init__(
        self,
        *,
        email: str,
        joined_relations: List[str] = None,
    ):
        ...

    @overload
    def __init__(
        self,
        *,
        username: str,
        joined_relations: List[str] = None,
    ):
        ...

    def __init__(
        self,
        dbobject: User = None,
        *,
        id: Union[str, UUID] = None,
        email: str = None,
        username: str = None,
        joined_relations: List[str] = None,
    ):
        self.obj = None
        if dbobject:
            if not isinstance(dbobject, User):
                raise TypeError('Wrong db object type')
            self.obj = dbobject
        elif id:
            obj = self._query(joined_relations=joined_relations).get(id)
            if obj is None:
                raise ValueError('User with this id is not found')
            self.obj = obj
        elif email:
            obj = (
                self._query(joined_relations=joined_relations)
                .filter(User.email == email)
                .first()
            )
            if not obj:
                raise ValueError('User with this email not found')
            self.obj = obj
        elif username:
            obj = (
                self._query(joined_relations=joined_relations)
                .filter(User.username == username)
                .first()
            )
            if not obj:
                raise ValueError('User with this username not found')
            self.obj = obj
        else:
            raise ValueError('At least one parameter must be given.')
        self._schema = self.schema(joined_relations=joined_relations)

    @classmethod
    def create(cls, data: Dict, validate_unknown=True, commit=True) -> UserService:
        if validate_unknown:
            schema = UserSchema()
        else:
            schema = UserSchema(unknown=EXCLUDE)
        validation = schema.validate(data)
        if len(validation) > 0:
            raise ValueError(f'Invalid Data: {validation}')
        dbobject: User = schema.load(data)
        dbobject.hash_password()
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
    ) -> Iterator[UserService]:
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
    def schema(*args, joined_relations: List = None, **kwargs) -> UserService:
        if joined_relations:
            fields_: List[str] = []
            for relation in joined_relations:
                if hasattr(UserSchema, relation):
                    fields_.append(relation)
            return UserSchema(*args, partial=fields_, **kwargs)
        return UserSchema(*args, partial=True, **kwargs)

    def upsert_profile(
        self, profile_data: Dict[str, Any], commit: bool = True
    ) -> Dict[str, Any]:
        profile = UserProfile.query.filter(UserProfile.user_id == self.obj.id).first()
        if 'user_id' in profile_data:
            del profile_data['user_id']
        if profile:
            for k, v in profile_data.items():
                if hasattr(profile, k):
                    setattr(profile, k, v)
        else:
            schema = UserProfileSchema(unknown=EXCLUDE)
            profile_data['user_id'] = self.obj.id
            profile = schema.load(profile_data)
            db.session.add(profile)
        update_db(commit)
        return UserProfileSchema().dump(profile)

    def dump_profile(self) -> Dict[str, Any]:
        profile = UserProfile.query.filter(UserProfile.user_id == self.obj.id).first()
        if profile:
            return UserProfileSchema().dump(profile)
        else:
            return {}

    def create_access_token(self):
        return create_access_token(identity={'id': str(self.obj.id)})

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
            User,
            joined_relations=joined_relations,
            filters=filters,
            order_by=order_by,
        )
        special_filters = filters.get('special') if filters else None
        if special_filters:
            team = special_filters.get('team')
            if team:
                query = query.join(UserTeams, UserTeams.user_id == User.id).filter(
                    UserTeams.team_id == team
                )
        query = query.order_by(User.username)
        return query

    # Operator overloading

    def __getitem__(self, key):  # []
        return self.get(key, strict=True)

    def __dict__(self):
        return self._schema.dump(self.obj)

    def __iter__(self):  # dict() list()
        for k, v in self.__dict__().items():
            yield (k, v)
