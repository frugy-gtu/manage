from flask_restx import Namespace, Resource
from flask_accepts import accepts
from flask_jwt_extended import jwt_required

from .schemas import request as request_schemas


api = Namespace('projects', 'Project related routes')


@api.route('/')
class Projects(Resource):
    @jwt_required
    def get(self, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:project_id>')
class Project(Resource):
    @jwt_required
    def get(self, project_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.ProjectPutSchema, api=api)
    def put(self, project_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    def delete(self, project_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:project_id>/tags')
class ProjectTags(Resource):
    @jwt_required
    def get(self, project_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.ProjectTagsPostSchema, api=api)
    def post(self, project_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.ProjectTagsPutSchema, api=api)
    def put(self, project_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    def delete(self, project_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:project_id>/states')
class ProjectStates(Resource):
    @jwt_required
    def get(self, project_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.ProjectStatesPostSchema, api=api)
    def post(self, project_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.ProjectStatesPutSchema, api=api)
    def put(self, project_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    def delete(self, project_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:project_id>/task_groups')
class ProjectTaskGroups(Resource):
    @jwt_required
    def get(self, project_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.ProjectTaskGroupsPostSchema, api=api)
    def post(self, project_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:project_id>/task_groups/<uuid:task_group_id>')
class ProjectTaskGroup(Resource):
    @jwt_required
    @accepts(schema=request_schemas.ProjectTaskGroupPutSchema, api=api)
    def put(self, project_id, task_group_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    def delete(self, project_id, task_group_id, **kwargs):
        raise NotImplementedError()
