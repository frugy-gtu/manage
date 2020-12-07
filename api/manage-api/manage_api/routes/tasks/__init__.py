from flask_restx import Namespace, Resource

api = Namespace('tasks', 'Task related routes')


@api.route('/')
class Tasks(Resource):
    def get(self, **kwargs):
        raise NotImplementedError()

    def post(self, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:task_id>')
class Task(Resource):
    def get(self, task_id, **kwargs):
        raise NotImplementedError()

    def put(self, task_id, **kwargs):
        raise NotImplementedError()

    def delete(self, task_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:task_id>/state')
class TaskState(Resource):
    def put(self, task_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:task_id>/tag')
class TaskTag(Resource):
    def put(self, task_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:task_id>/logs')
class TaskLogs(Resource):
    def get(self, task_id, **kwargs):
        raise NotImplementedError()

    def post(self, task_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:task_id>/logs/<uuid:log_id>')
class TaskLog(Resource):
    def put(self, task_id, **kwargs):
        raise NotImplementedError()

    def delete(self, task_id, **kwargs):
        raise NotImplementedError()
