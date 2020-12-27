from flask import abort
from marshmallow import fields, Schema, post_load, validates_schema
from marshmallow.exceptions import ValidationError
from manage_api.db.services import ProjectService
from manage_api.db.services import TaskGroupService
from manage_api.routes.common_schemas import JWTSchema


class TasksGetSchema(JWTSchema):
    project_id = fields.UUID(required=False, allow_none=True)
    task_group_id = fields.UUID(required=False, allow_none=True)

    @validates_schema
    def validate_schema(self, data, **kwargs):
        user_id = self.get_user_id()
        if data.get('task_group_id'):
            task_group = TaskGroupService(id=data['task_group_id'])
            project = ProjectService(id=task_group['project_id'])
            if not project.is_user_associated(user_id):
                abort(401, 'You don\'t have access to this team\'s tasks')
        else:
            if data.get('project_id'):
                project = ProjectService(id=data['project_id'])
                project.is_user_associated(user_id)
                if not project.is_user_associated(user_id):
                    abort(401, 'You don\'t have access to this team\'s tasks')

    @post_load
    def post_load(self, data, **kwargs):
        data['filters'] = {'==': {}}
        if data.get('task_group_id'):
            data['filters']['==']['task_group_id'] = data['task_group_id']
        elif data.get('project_id'):
            data['filters']['==']['project_id'] = data['project_id']
        else:
            data['filters']['==']['user_id'] = self.get_user_id()
        return data


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
