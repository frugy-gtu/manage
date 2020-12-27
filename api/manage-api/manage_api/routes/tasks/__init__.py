from flask import request
from flask_restx import Namespace, Resource
from flask_accepts import accepts, responds
from flask_jwt_extended import jwt_required

from .schemas import request as request_schemas, response as response_schemas
from manage_api.db.services import TaskService

api = Namespace('tasks', 'Task related routes')


@api.route('/')
class Tasks(Resource):
    @jwt_required
    @accepts(query_params_schema=request_schemas.TasksGetSchema, api=api)
    @responds(schema=response_schemas.Task(many=True), api=api, status_code=200)
    def get(self, **kwargs):
        params = request.parsed_query_params
        result = TaskService.dump_all(filters=params['filters'])
        return result

    @jwt_required
    @accepts(schema=request_schemas.TasksPostSchema, api=api)
    @responds(schema=response_schemas.Task, api=api, status_code=201)
    def post(self, **kwargs):
        data = request.parsed_obj
        task = TaskService.create(data)
        return task


@api.route('/<uuid:task_id>')
class Task(Resource):
    @jwt_required
    @accepts(query_params_schema=request_schemas.TaskGetSchema, api=api)
    @responds(schema=response_schemas.Task, api=api, status_code=200)
    def get(self, task_id, **kwargs):
        params = request.parsed_query_params
        task = params['task']
        return task.dump()

    @jwt_required
    @accepts(schema=request_schemas.TaskPutSchema, api=api)
    @responds(schema=response_schemas.Task, api=api, status_code=200)
    def put(self, task_id, **kwargs):
        data = request.parsed_obj
        task = data['task']
        del data['task']
        task.update(data)
        return task.dump()

    @jwt_required
    @accepts(query_params_schema=request_schemas.TaskDeleteSchema, api=api)
    @responds(schema=response_schemas.Task, api=api, status_code=200)
    def delete(self, task_id, **kwargs):
        params = request.parsed_query_params
        task = params['task']
        task_data = task.dump()
        task.delete()
        return task_data


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
    @responds(schema=response_schemas.TimeLog(many=True), api=api, status_code=200)
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
