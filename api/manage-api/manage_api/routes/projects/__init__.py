from flask import request, abort
from flask_restx import Namespace, Resource
from flask_accepts import accepts, responds
from flask_jwt_extended import jwt_required

from .schemas import request as request_schemas, response as response_schemas
from manage_api.db.services.project import ProjectService
from manage_api.db.services.task_group import TaskGroupService


api = Namespace('projects', 'Project related routes')


@api.route('/')
class Projects(Resource):
    @jwt_required
    @accepts(query_params_schema=request_schemas.ProjectsGetSchema, api=api)
    @responds(schema=response_schemas.Project(many=True), api=api, status_code=200)
    def get(self, **kwargs):
        params = request.parsed_query_params
        result = ProjectService.dump_all(filters=params['filters'])
        return result


@api.route('/<uuid:project_id>')
class Project(Resource):
    @jwt_required
    @accepts(query_params_schema=request_schemas.ProjectGetSchema, api=api)
    @responds(schema=response_schemas.Project, api=api, status_code=200)
    def get(self, project_id, **kwargs):
        params = request.parsed_query_params
        project = params['project']
        return project.dump()

    @jwt_required
    @accepts(schema=request_schemas.ProjectPutSchema, api=api)
    @responds(schema=response_schemas.Project, api=api, status_code=200)
    def put(self, project_id, **kwargs):
        data = request.parsed_obj
        project = data['project']
        del data['project']
        project.update(data)
        return project.dump()

    @jwt_required
    @accepts(query_params_schema=request_schemas.ProjectDeleteSchema, api=api)
    @responds(schema=response_schemas.Project, api=api, status_code=200)
    def delete(self, project_id, **kwargs):
        params = request.parsed_query_params
        project = params['project']
        project_data = project.dump()
        project.delete()
        return project_data


@api.route('/<uuid:project_id>/tags')
class ProjectTags(Resource):
    @jwt_required
    @responds(schema=response_schemas.ProjectTag(many=True), api=api, status_code=200)
    def get(self, project_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.ProjectTagsPostSchema, api=api)
    @responds(schema=response_schemas.ProjectTag, api=api, status_code=201)
    def post(self, project_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.ProjectTagsPutSchema, api=api)
    @responds(schema=response_schemas.ProjectTag(many=True), api=api, status_code=201)
    def put(self, project_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @responds(schema=response_schemas.ProjectTag, api=api, status_code=200)
    def delete(self, project_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:project_id>/states')
class ProjectStates(Resource):
    @jwt_required
    @responds(schema=response_schemas.ProjectState(many=True), api=api, status_code=200)
    def get(self, project_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.ProjectStatesPostSchema, api=api)
    @responds(schema=response_schemas.ProjectState, api=api, status_code=201)
    def post(self, project_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.ProjectStatesPutSchema, api=api)
    @responds(schema=response_schemas.ProjectState(many=True), api=api, status_code=201)
    def put(self, project_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @responds(schema=response_schemas.ProjectState, api=api, status_code=200)
    def delete(self, project_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:project_id>/task-groups')
class ProjectTaskGroups(Resource):
    @jwt_required
    @accepts(query_params_schema=request_schemas.ProjectTaskGroupsGetSchema, api=api)
    @responds(schema=response_schemas.TaskGroup(many=True), api=api, status_code=200)
    def get(self, project_id, **kwargs):
        params = request.parsed_query_params
        task_groups = TaskGroupService.dump_all(filters=params['filters'])
        return task_groups

    @jwt_required
    @accepts(schema=request_schemas.ProjectTaskGroupsPostSchema, api=api)
    @responds(schema=response_schemas.TaskGroup, api=api, status_code=201)
    def post(self, project_id, **kwargs):
        data = request.parsed_obj
        task_group = TaskGroupService.create(data)
        return task_group.dump()


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
