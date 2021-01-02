from flask import abort
from flask.globals import request
from marshmallow import fields, Schema, post_load, validates_schema
from marshmallow.exceptions import ValidationError
from manage_api.db.services import ProjectService
from manage_api.db.services import TaskService
from manage_api.db.services import TaskGroupService
from manage_api.db.services import TeamService
from manage_api.routes.common_schemas import JWTSchema


class TasksGetSchema(JWTSchema):
    project_id = fields.UUID(required=False, allow_none=True)
    task_group_id = fields.UUID(required=False, allow_none=True)

    @validates_schema
    def validate_schema(self, data, **kwargs):
        user_id = self.get_user_id()
        try:
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
        except ValueError as e:
            abort(404, str(e))

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


class TasksPostSchema(JWTSchema):
    name = fields.String(required=True, allow_none=False)
    deadline = fields.DateTime(required=True, allow_none=False)
    task_group_id = fields.UUID(required=True, allow_none=False)
    state_id = fields.UUID(required=False, allow_none=True)
    tag_id = fields.UUID(required=False, allow_none=True)
    details = fields.String(required=False, allow_none=True)
    schedule = fields.DateTime(required=False, allow_none=True)

    @validates_schema
    def validate(self, data, **kwargs):
        user_id = self.get_user_id()
        try:
            if data.get('task_group_id'):
                task_group = TaskGroupService(id=data['task_group_id'])
                project = ProjectService(id=task_group['project_id'])
                if not project.is_user_associated(user_id):
                    abort(401, 'You don\'t have access to this team\'s tasks')
        except ValueError as e:
            abort(404, str(e))

    @post_load
    def post_load(self, data, **kwargs):
        if 'state_id' in data:
            del data['state_id']
        if 'tag_id' in data:
            del data['tag_id']
        data['user_id'] = self.get_user_id()
        return data


class TaskGetSchema(JWTSchema):
    @post_load
    def post_load(self, data, **kwargs):
        try:
            task = TaskService(id=request.view_args['task_id'])
            team = TeamService(id=task['team_id'])
            if not team.is_user_associated(self.get_user_id()):
                abort(401, 'You don\'t have access to this task')
            data['task'] = task
            return data
        except ValueError as e:
            abort(404, str(e))


class TaskPutSchema(JWTSchema):
    name = fields.String(required=False, allow_none=True)
    deadline = fields.DateTime(required=False, allow_none=True)
    task_group_id = fields.UUID(required=False, allow_none=True)
    details = fields.String(required=False, allow_none=True)
    schedule = fields.DateTime(required=False, allow_none=True)

    @post_load
    def post_load(self, data, **kwargs):
        try:
            task = TaskService(id=request.view_args['task_id'])
            team = TeamService(id=task['team_id'])
            if not team.is_user_associated(self.get_user_id()):
                abort(401, 'You don\'t have access to this task')
            data['task'] = task
            return data
        except ValueError as e:
            abort(404, str(e))


class TaskDeleteSchema(JWTSchema):
    @post_load
    def post_load(self, data, **kwargs):
        try:
            task = TaskService(id=request.view_args['task_id'])
            team = TeamService(id=task['team_id'])
            if not team.is_user_associated(self.get_user_id()):
                abort(401, 'You don\'t have access to this task')
            data['task'] = task
            return data
        except ValueError as e:
            abort(404, str(e))


class TaskStatePutSchema(JWTSchema):
    state_id = fields.UUID(required=True, allow_none=False)

    @post_load
    def post_load(self, data, **kwargs):
        try:
            task = TaskService(id=request.view_args['task_id'])
            team = TeamService(id=task['team_id'])
            if not team.is_user_associated(self.get_user_id()):
                abort(401, 'You don\'t have access to this task')
            project = ProjectService(id=task['project_id'])
            if not project.has_state(data['state_id']):
                abort(404, 'This state not found on project')
            data['task'] = task
            return data
        except ValueError as e:
            abort(404, str(e))


class TaskTagPutSchema(JWTSchema):
    tag_id = fields.UUID(required=True, allow_none=False)


class TimeLogsPostSchema(JWTSchema):
    logged_time = fields.Integer(required=True, allow_none=False)


class TimeLogPutSchema(JWTSchema):
    logged_time = fields.Integer(required=True, allow_none=False)
