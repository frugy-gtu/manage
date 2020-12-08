from flask_restx import Namespace, Resource
from flask_accepts import accepts, responds
from flask_jwt_extended import jwt_required

from .schemas import request as request_schemas, response as response_schemas


api = Namespace('projects', 'Project related routes')


@api.route('/')
class Projects(Resource):
    @jwt_required
    @responds(schema=response_schemas.Project, api=api, status_code=200)
    def get(self, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:project_id>')
class Project(Resource):
    @jwt_required
    @responds(schema=response_schemas.Project, api=api, status_code=200)
    def get(self, project_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.ProjectPutSchema, api=api)
    @responds(schema=response_schemas.Project, api=api, status_code=200)
    def put(self, project_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @responds(schema=response_schemas.Project, api=api, status_code=200)
    def delete(self, project_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:project_id>/tags')
class ProjectTags(Resource):
    @jwt_required
    @responds(schema=response_schemas.ProjectTag, api=api, status_code=200)
    def get(self, project_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.ProjectTagsPostSchema, api=api)
    @responds(schema=response_schemas.ProjectTag, api=api, status_code=201)
    def post(self, project_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.ProjectTagsPutSchema, api=api)
    @responds(schema=response_schemas.ProjectTag, api=api, status_code=201)
    def put(self, project_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @responds(schema=response_schemas.ProjectTag, api=api, status_code=200)
    def delete(self, project_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:project_id>/states')
class ProjectStates(Resource):
    @jwt_required
    @responds(schema=response_schemas.ProjectState, api=api, status_code=200)
    def get(self, project_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.ProjectStatesPostSchema, api=api)
    @responds(schema=response_schemas.ProjectState, api=api, status_code=201)
    def post(self, project_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.ProjectStatesPutSchema, api=api)
    @responds(schema=response_schemas.ProjectState, api=api, status_code=201)
    def put(self, project_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @responds(schema=response_schemas.ProjectState, api=api, status_code=200)
    def delete(self, project_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:project_id>/task_groups')
class ProjectTaskGroups(Resource):
    @jwt_required
    @responds(schema=response_schemas.TaskGroup, api=api, status_code=200)
    def get(self, project_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.ProjectTaskGroupsPostSchema, api=api)
    @responds(schema=response_schemas.TaskGroup, api=api, status_code=201)
    def post(self, project_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:project_id>/task_groups/<uuid:task_group_id>')
class ProjectTaskGroup(Resource):
    @jwt_required
    @accepts(schema=request_schemas.ProjectTaskGroupPutSchema, api=api)
    @responds(schema=response_schemas.TaskGroup, api=api, status_code=200)
    def put(self, project_id, task_group_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @responds(schema=response_schemas.TaskGroup, api=api, status_code=200)
    def delete(self, project_id, task_group_id, **kwargs):
        raise NotImplementedError()
