from marshmallow import fields, post_load
from werkzeug.security import check_password_hash, generate_password_hash
from .base import Base, BaseSchema
from .db import db


class User(Base):
    username = db.Column(db.String(), unique=True, nullable=False)
    email = db.Column(db.String(), unique=True, nullable=False)
    password = db.Column(db.String(), index=False, nullable=False)
    is_active = db.Column(
        db.Boolean(),
        index=False,
        nullable=False,
        default=True,
        server_default=db.text('false'),
    )

    teams = db.relationship('Team', secondary='user_teams', lazy='noload')

    def hash_password(self):
        self.password = generate_password_hash(self.password)

    def check_password(self, password):
        return check_password_hash(self.password, password)


class UserSchema(BaseSchema):
    username = fields.String(required=True, allow_none=False)
    email = fields.String(required=True, allow_none=False)
    password = fields.String(required=True, allow_none=False)
    is_active = fields.Boolean(required=False, allow_none=False)

    @post_load
    def create_obj(self, data, **kwargs):
        return User(**data)
