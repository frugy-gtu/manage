from flask_restx import Namespace, Resource
from flask_accepts import accepts
from flask_jwt_extended import jwt_required

from .schemas import request as request_schemas

api = Namespace('teams', 'Team related routes')


@api.route('/')
class Teams(Resource):
    @jwt_required
    def get(self, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.TeamsPostSchema, api=api)
    def post(self, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:team_id>')
class Team(Resource):
    @jwt_required
    def get(self, team_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.TeamPutSchema, api=api)
    def put(self, team_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    def delete(self, team_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:team_id>/users')
class TeamUsers(Resource):
    @jwt_required
    def get(self, team_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:team_id>/join')
class JoinTeam(Resource):
    @jwt_required
    def post(self, team_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:team_id>/requests')
class JoinRequests(Resource):
    @jwt_required
    def get(self, team_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:team_id>/requests/<uuid:request_id>')
class JoinRequest(Resource):
    @jwt_required
    def get(self, team_id, request_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    def post(self, team_id, request_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    def delete(self, team_id, request_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:team_id>/tags')
class TeamTags(Resource):
    @jwt_required
    def get(self, team_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.TeamTagsPostSchema, api=api)
    def post(self, team_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.TeamTagsPutSchema, api=api)
    def put(self, team_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    def delete(self, team_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:team_id>/states')
class TeamStates(Resource):
    @jwt_required
    def get(self, team_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.TeamStatesPostSchema, api=api)
    def post(self, team_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.TeamStatesPutSchema, api=api)
    def put(self, team_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    def delete(self, team_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:team_id>/projects')
class TeamProjects(Resource):
    @jwt_required
    def get(self, team_id, **kwargs):
        raise NotImplementedError()

    @jwt_required
    @accepts(schema=request_schemas.TeamProjectsPostSchema, api=api)
    def post(self, team_id, **kwargs):
        raise NotImplementedError()
