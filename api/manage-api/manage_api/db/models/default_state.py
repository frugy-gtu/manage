from marshmallow import fields, post_load
from .base import Base, BaseSchema
from .db import db, UUID, joinedload


class DefaultState(Base):
    name = db.Column(db.String(), index=True, nullable=False)
    rank = db.Column(db.Integer(), index=True, nullable=False)
    team_id = db.Column(
        UUID(as_uuid=True), db.ForeignKey('team.id', ondelete='CASCADE'), nullable=False
    )
    # relations
    load_strategies = {
        'team': joinedload,
    }
    team = db.relationship('Team', lazy='noload')


class DefaultStateSchema(BaseSchema):
    name = fields.String(required=True, allow_none=False)
    rank = fields.Integer(required=True, allow_none=False)
    team_id = fields.UUID(required=True, allow_none=False)
    # relations
    team = fields.Nested('TeamSchema', dump_only=True)

    @post_load
    def create_obj(self, data, **kwargs):
        return DefaultState(**data)
