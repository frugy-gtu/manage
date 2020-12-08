from flask_restx import Namespace, Resource
from flask_accepts import accepts, responds
from flask_jwt_extended import jwt_required

from .schemas import request as request_schemas, response as response_schemas

api = Namespace('tasks', 'Task related routes')


@api.route('/')
class Tasks(Resource):
    @jwt_required
    @responds(schema=response_schemas.Task, api=api, status_code=200)
    def get(self, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.TasksPostSchema, api=api)
    @responds(schema=response_schemas.Task, api=api, status_code=201)
    def post(self, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:task_id>')
class Task(Resource):
    @jwt_required
    @responds(schema=response_schemas.Task, api=api, status_code=200)
    def get(self, task_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.TaskPutSchema, api=api)
    @responds(schema=response_schemas.Task, api=api, status_code=200)
    def put(self, task_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @responds(schema=response_schemas.Task, api=api, status_code=200)
    def delete(self, task_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:task_id>/state')
class TaskState(Resource):
    @jwt_required
    @accepts(schema=request_schemas.TaskStatePutSchema, api=api)
    @responds(schema=response_schemas.BooleanResult, api=api, status_code=200)
    def put(self, task_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:task_id>/tag')
class TaskTag(Resource):
    @jwt_required
    @accepts(schema=request_schemas.TaskTagPutSchema, api=api)
    @responds(schema=response_schemas.BooleanResult, api=api, status_code=200)
    def put(self, task_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:task_id>/logs')
class TaskLogs(Resource):
    @jwt_required
    @responds(schema=response_schemas.TimeLog, api=api, status_code=200)
    def get(self, task_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.TimeLogsPostSchema, api=api)
    @responds(schema=response_schemas.TimeLog, api=api, status_code=201)
    def post(self, task_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:task_id>/logs/<uuid:log_id>')
class TaskLog(Resource):
    @jwt_required
    @accepts(schema=request_schemas.TimeLogPutSchema, api=api)
    @responds(schema=response_schemas.TimeLog, api=api, status_code=200)
    def put(self, task_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @responds(schema=response_schemas.TimeLog, api=api, status_code=200)
    def delete(self, task_id, **kwargs):
        raise NotImplementedError()
