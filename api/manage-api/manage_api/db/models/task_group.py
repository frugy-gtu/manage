from marshmallow import fields, post_load
from .base import Base, BaseSchema
from .db import db, UUID, joinedload


class TaskGroup(Base):
    name = db.Column(db.String(), index=True, nullable=False)
    project_id = db.Column(
        UUID(as_uuid=True), db.ForeignKey('project.id'), nullable=False
    )
    # relations
    load_strategies = {
        'project': joinedload,
    }
    project = db.relationship('Project', lazy='noload')


class TaskGroupSchema(BaseSchema):
    name = fields.String(required=True, allow_none=False)
    project_id = fields.UUID(required=True, allow_none=False)
    # relations
    project = fields.Nested('ProjectSchema', dump_only=True)

    @post_load
    def create_obj(self, data, **kwargs):
        return TaskGroup(**data)
