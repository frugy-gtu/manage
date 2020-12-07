from flask_restx import Namespace, Resource

api = Namespace('teams', 'Team related routes')


@api.route('/')
class Teams(Resource):
    def get(self, **kwargs):
        raise NotImplementedError()

    def post(self, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:team_id>')
class Team(Resource):
    def get(self, team_id, **kwargs):
        raise NotImplementedError()

    def put(self, team_id, **kwargs):
        raise NotImplementedError()

    def delete(self, team_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:team_id>/users')
class TeamUsers(Resource):
    def get(self, team_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:team_id>/join')
class JoinTeam(Resource):
    def post(self, team_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:team_id>/requests')
class JoinRequests(Resource):
    def get(self, team_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:team_id>/requests/<uuid:request_id>')
class JoinRequest(Resource):
    def get(self, team_id, request_id, **kwargs):
        raise NotImplementedError()

    def post(self, team_id, request_id, **kwargs):
        raise NotImplementedError()

    def delete(self, team_id, request_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:team_id>/tags')
class TeamTags(Resource):
    def get(self, team_id, **kwargs):
        raise NotImplementedError()

    def post(self, team_id, **kwargs):
        raise NotImplementedError()

    def put(self, team_id, **kwargs):
        raise NotImplementedError()

    def delete(self, team_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:team_id>/states')
class TeamStates(Resource):
    def get(self, team_id, **kwargs):
        raise NotImplementedError()

    def post(self, team_id, **kwargs):
        raise NotImplementedError()

    def put(self, team_id, **kwargs):
        raise NotImplementedError()

    def delete(self, team_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:team_id>/projects')
class TeamProjects(Resource):
    def get(self, team_id, **kwargs):
        raise NotImplementedError()

    def post(self, team_id, **kwargs):
        raise NotImplementedError()
