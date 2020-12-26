from __future__ import annotations

from typing import Any, Dict, Optional, Iterator, Union, overload
from uuid import UUID

from flask_jwt_extended import create_access_token
from marshmallow import EXCLUDE

from manage_api.db.models import db, update_db
from manage_api.db.models.user import User, UserSchema


__all__ = [
    'Userervice',
]


class UserService:

    obj: Optional[User]

    @overload
    def __init__(self, dbobject: User):
        ...

    @overload
    def __init__(self, *, id: str):
        ...

    @overload
    def __init__(self, *, id: UUID):
        ...

    @overload
    def __init__(self, *, email: str):
        ...

    @overload
    def __init__(self, *, username: str):
        ...

    def __init__(
        self,
        dbobject: User = None,
        *,
        id: Union[str, UUID] = None,
        email: str = None,
        username: str = None,
    ):
        self.obj = None
        if dbobject:
            if not isinstance(dbobject, User):
                raise TypeError('Wrong db object type')
            self.obj = dbobject
        elif id:
            obj = User.query.get(id)
            if obj is None:
                raise ValueError('User with this id is not found')
            self.obj = obj
        elif email:
            obj = User.query.filter(User.email == email).first()
            if not obj:
                raise ValueError('User with this email not found')
            self.obj = obj
        elif username:
            obj = User.query.filter(User.username == username).first()
            if not obj:
                raise ValueError('User with this username not found')
            self.obj = obj
        else:
            raise ValueError('At least one parameter must be given.')

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
    def get_all(cls) -> Iterator[UserService]:
        return map(lambda user: cls(user), User.query.all())

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

    # Operator overloading

    def __getitem__(self, key):  # []
        return self.get(key, strict=True)

    def __dict__(self):
        return UserSchema().dump(self.obj)

    def __iter__(self):  # dict() list()
        for k, v in self.__dict__().items():
            yield (k, v)
