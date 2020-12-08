from flask_restx import Namespace, Resource
from flask_accepts import accepts, responds
from flask_jwt_extended import jwt_required

from .schemas import request as request_schemas, response as response_schemas

api = Namespace('teams', 'Team related routes')


@api.route('/')
class Teams(Resource):
    @jwt_required
    @responds(schema=response_schemas.Team(many=True), api=api, status_code=200)
    def get(self, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.TeamsPostSchema, api=api)
    @responds(schema=response_schemas.Team, api=api, status_code=201)
    def post(self, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:team_id>')
class Team(Resource):
    @jwt_required
    @responds(schema=response_schemas.Team, api=api, status_code=200)
    def get(self, team_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.TeamPutSchema, api=api)
    @responds(schema=response_schemas.Team, api=api, status_code=200)
    def put(self, team_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @responds(schema=response_schemas.Team, api=api, status_code=200)
    def delete(self, team_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:team_id>/users')
class TeamUsers(Resource):
    @jwt_required
    @responds(schema=response_schemas.TeamUser(many=True), api=api, status_code=200)
    def get(self, team_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:team_id>/join')
class JoinTeam(Resource):
    @jwt_required
    @responds(schema=response_schemas.JoinRequest, api=api, status_code=200)
    def post(self, team_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:team_id>/requests')
class JoinRequests(Resource):
    @jwt_required
    @responds(schema=response_schemas.JoinRequest(many=True), api=api, status_code=200)
    def get(self, team_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:team_id>/requests/<uuid:request_id>')
class JoinRequest(Resource):
    @jwt_required
    @responds(schema=response_schemas.JoinRequest, api=api, status_code=200)
    def get(self, team_id, request_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @responds(schema=response_schemas.JoinRequest, api=api, status_code=200)
    def post(self, team_id, request_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @responds(schema=response_schemas.JoinRequest, api=api, status_code=200)
    def delete(self, team_id, request_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:team_id>/tags')
class TeamTags(Resource):
    @jwt_required
    @responds(schema=response_schemas.TeamTag(many=True), api=api, status_code=200)
    def get(self, team_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.TeamTagsPostSchema, api=api)
    @responds(schema=response_schemas.TeamTag, api=api, status_code=201)
    def post(self, team_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.TeamTagsPutSchema, api=api)
    @responds(schema=response_schemas.TeamTag(many=True), api=api, status_code=201)
    def put(self, team_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @responds(schema=response_schemas.TeamTag, api=api, status_code=200)
    def delete(self, team_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:team_id>/states')
class TeamStates(Resource):
    @jwt_required
    @responds(schema=response_schemas.TeamState(many=True), api=api, status_code=200)
    def get(self, team_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.TeamStatesPostSchema, api=api)
    @responds(schema=response_schemas.TeamState, api=api, status_code=201)
    def post(self, team_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.TeamStatesPutSchema, api=api)
    @responds(schema=response_schemas.TeamState(many=True), api=api, status_code=201)
    def put(self, team_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @responds(schema=response_schemas.TeamState, api=api, status_code=200)
    def delete(self, team_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:team_id>/projects')
class TeamProjects(Resource):
    @jwt_required
    @responds(schema=response_schemas.TeamProject(many=True), api=api, status_code=200)
    def get(self, team_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.TeamProjectsPostSchema, api=api)
    @responds(schema=response_schemas.TeamProject, api=api, status_code=201)
    def post(self, team_id, **kwargs):
        raise NotImplementedError()
