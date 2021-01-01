from marshmallow import fields, post_load
from werkzeug.security import check_password_hash, generate_password_hash
from .base import Base, BaseSchema
from .db import db, UUID


class UserProfile(Base):
    name = db.Column(db.String(), index=False, nullable=True)
    surname = db.Column(db.String(), index=False, nullable=True)
    avatar = db.Column(db.String(), index=False, nullable=True)
    user_id = db.Column(UUID(as_uuid=True), db.ForeignKey('user.id'), nullable=False)


class UserProfileSchema(BaseSchema):
    name = fields.String(required=False, allow_none=True)
    surname = fields.String(required=False, allow_none=True)
    avatar = fields.String(required=False, allow_none=True)
    user_id = fields.UUID(required=True, allow_none=False)

    @post_load
    def create_obj(self, data, **kwargs):
        return UserProfile(**data)
