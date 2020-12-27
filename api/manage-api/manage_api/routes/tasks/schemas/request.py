from marshmallow import fields, Schema


class TasksPostSchema(Schema):
    name = fields.String(required=True, allow_none=False)
    deadline = fields.DateTime(required=True, allow_none=False)
    task_group_id = fields.UUID(required=True, allow_none=False)
    state_id = fields.UUID(required=False, allow_none=True)
    tag_id = fields.UUID(required=False, allow_none=True)
    details = fields.String(required=False, allow_none=True)
    schedule = fields.DateTime(required=False, allow_none=True)


class TaskPutSchema(Schema):
    name = fields.String(required=False, allow_none=True)
    deadline = fields.DateTime(required=False, allow_none=True)
    task_group_id = fields.UUID(required=False, allow_none=True)
    details = fields.String(required=False, allow_none=True)
    schedule = fields.DateTime(required=False, allow_none=True)


class TaskStatePutSchema(Schema):
    state_id = fields.UUID(required=True, allow_none=False)


class TaskTagPutSchema(Schema):
    tag_id = fields.UUID(required=True, allow_none=False)


class TimeLogsPostSchema(Schema):
    logged_time = fields.Integer(required=True, allow_none=False)


class TimeLogPutSchema(Schema):
    logged_time = fields.Integer(required=True, allow_none=False)
