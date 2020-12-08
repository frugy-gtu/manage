from flask_restx import Namespace, Resource
from flask_accepts import accepts
from flask_jwt_extended import jwt_required

from .schemas import request as request_schemas

api = Namespace('tasks', 'Task related routes')


@api.route('/')
class Tasks(Resource):
    @jwt_required
    def get(self, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.TasksPostSchema, api=api)
    def post(self, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:task_id>')
class Task(Resource):
    @jwt_required
    def get(self, task_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.TaskPutSchema, api=api)
    def put(self, task_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    def delete(self, task_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:task_id>/state')
class TaskState(Resource):
    @jwt_required
    @accepts(schema=request_schemas.TaskStatePutSchema, api=api)
    def put(self, task_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:task_id>/tag')
class TaskTag(Resource):
    @jwt_required
    @accepts(schema=request_schemas.TaskTagPutSchema, api=api)
    def put(self, task_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:task_id>/logs')
class TaskLogs(Resource):
    @jwt_required
    def get(self, task_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.TimeLogsPostSchema, api=api)
    def post(self, task_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:task_id>/logs/<uuid:log_id>')
class TaskLog(Resource):
    @jwt_required
    @accepts(schema=request_schemas.TimeLogPutSchema, api=api)
    def put(self, task_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    def delete(self, task_id, **kwargs):
        raise NotImplementedError()
