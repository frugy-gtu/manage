from marshmallow import fields, post_load
from .base import Base, BaseSchema
from .db import db, UUID, joinedload, selectinload


class Team(Base):
    name = db.Column(db.String(), index=True, nullable=False)
    abbreviation = db.Column(db.String(), index=False, nullable=False)
    user_id = db.Column(UUID(as_uuid=True), db.ForeignKey('user.id'), nullable=False)
    # relations
    load_strategies = {
        'user': joinedload,
        'users': selectinload,
    }
    user = db.relationship('User', lazy='noload')
    users = db.relationship('User', secondary='user_teams', lazy='noload')


class TeamSchema(BaseSchema):
    name = fields.String(required=True, allow_none=False)
    abbreviation = fields.String(required=True, allow_none=False)
    user_id = fields.UUID(required=True, allow_none=False)
    # relations
    user = fields.Nested('UserSchema', dump_only=True)

    @post_load
    def create_obj(self, data, **kwargs):
        return Team(**data)
