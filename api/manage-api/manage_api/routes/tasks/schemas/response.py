from marshmallow import fields, Schema


class BooleanResult(Schema):
    result = fields.Boolean()


class Base(Schema):
    id = fields.UUID()
    created_at = fields.String()


class Task(Base):
    name = fields.String()
    details = fields.String()
    schedule = fields.String()
    deadline = fields.String()
    task_group_id = fields.UUID()
    state_id = fields.UUID()
    task_tag_id = fields.UUID()
    project_id = fields.UUID()


class TimeLog(Base):
    task_id = fields.UUID()
    user_id = fields.UUID()
    logged_time = fields.Integer()
