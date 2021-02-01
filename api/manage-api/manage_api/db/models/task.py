from marshmallow import fields, post_load
from .base import Base, BaseSchema, DateTimeV2
from .db import db, UUID, joinedload


class Task(Base):
    name = db.Column(db.String(), index=True, nullable=False)
    deadline = db.Column(db.DateTime(timezone=True), index=False, nullable=True)
    schedule = db.Column(
        db.DateTime(timezone=True), index=False, nullable=False, default=db.func.now()
    )
    details = db.Column(db.String(), index=False, nullable=True)
    user_id = db.Column(UUID(as_uuid=True), db.ForeignKey('user.id'), nullable=False)
    team_id = db.Column(UUID(as_uuid=True), db.ForeignKey('team.id'), nullable=False)
    project_id = db.Column(
        UUID(as_uuid=True), db.ForeignKey('project.id'), nullable=False
    )
    task_group_id = db.Column(
        UUID(as_uuid=True),
        db.ForeignKey('task_group.id', ondelete='CASCADE'),
        nullable=False,
    )
    state_id = db.Column(UUID(as_uuid=True), db.ForeignKey('state.id'), nullable=False)

    # relations
    load_strategies = {
        'user': joinedload,
        'state': joinedload,
        'team': joinedload,
        'project': joinedload,
        'task_group': joinedload,
    }
    user = db.relationship('User', lazy='noload')
    state = db.relationship('State', lazy='noload')
    team = db.relationship('Team', lazy='noload')
    project = db.relationship('Project', lazy='noload')
    task_group = db.relationship('TaskGroup', lazy='noload')


class TaskSchema(BaseSchema):
    name = fields.String(required=True, allow_none=False)
    deadline = DateTimeV2(required=False, allow_none=True)
    schedule = DateTimeV2(required=False, allow_none=True)
    details = fields.String(required=False, allow_none=True)
    user_id = fields.UUID(required=True, allow_none=False)
    team_id = fields.UUID(required=True, allow_none=False)
    project_id = fields.UUID(required=True, allow_none=False)
    task_group_id = fields.UUID(required=True, allow_none=False)
    state_id = fields.UUID(required=True, allow_none=False)
    # relations
    user = fields.Nested('UserSchema', dump_only=True)
    state = fields.Nested('StateSchema', dump_only=True)
    team = fields.Nested('TeamSchema', dump_only=True)
    project = fields.Nested('ProjectSchema', dump_only=True)
    task_group = fields.Nested('TaskGroupSchema', dump_only=True)

    @post_load
    def create_obj(self, data, **kwargs):
        return Task(**data)
