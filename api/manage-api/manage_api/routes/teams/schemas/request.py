from flask import request, abort
from marshmallow import fields, post_load, validates_schema, Schema
from marshmallow.exceptions import ValidationError
from manage_api.db.services import TeamService
from manage_api.routes.common_schemas import JWTSchema


def _validate_team_in_url():
    team_id = request.view_args['team_id']
    try:
        return TeamService(id=team_id)
    except ValueError as e:
        abort(404, str(e))


def _validate_user_associated(user_id):
    team = _validate_team_in_url()
    if not team.is_user_associated(user_id):
        abort(401, 'You are not in this team')


def _validate_user_is_manager(user_id):
    team = _validate_team_in_url()
    if str(team['user_id']) != user_id:
        abort(401, 'You are not the manager of this team')


class TeamsGetSchema(JWTSchema):
    @post_load
    def post_load(self, data, **kwargs):
        user = self.get_user()
        data['filters'] = {
            'special': {
                'user': user['id'],
            }
        }
        return data


class TeamsPostSchema(JWTSchema):
    name = fields.String(required=True, allow_none=False)
    abbreviation = fields.String(required=True, allow_none=False)

    @validates_schema
    def validates_schema(self, data, **kwargs):
        teams = TeamService.get_all(
            filters={
                '==': {
                    'user_id': self.get_user_id(),
                    'name': data['name'],
                }
            }
        )
        if len(list(teams)) > 0:
            raise ValidationError(f'This user already has a team named {data["name"]}')

    @post_load
    def post_load(self, data, **kwargs):
        data['user_id'] = self.get_user_id()
        return data


class TeamGetSchema(JWTSchema):
    @post_load
    def post_load(self, data, **kwargs):
        user = self.get_user()
        data['user'] = user
        return data


class TeamPutSchema(JWTSchema):
    name = fields.String(required=False, allow_none=True)
    abbreviation = fields.String(required=False, allow_none=True)

    @post_load
    def post_load(self, data, **kwargs):
        user = self.get_user()
        data['user'] = user
        return data


class TeamDeleteSchema(JWTSchema):
    @post_load
    def post_load(self, data, **kwargs):
        user = self.get_user()
        data['user'] = user
        return data


class TeamTagsPostSchema(JWTSchema):
    name = fields.String(required=True, allow_none=False)


class TeamTagsPutSchema(JWTSchema):
    tags = fields.List(fields.String(), required=True, allow_none=False)


class TeamStatesPostSchema(JWTSchema):
    name = fields.String(required=True, allow_none=False)
    rank = fields.Integer(required=True, allow_none=False)


class TeamStatesPutSchema(JWTSchema):
    states = fields.List(
        fields.Nested(TeamStatesPostSchema), required=True, allow_none=False
    )


class TeamProjectsGetSchema(JWTSchema):
    @validates_schema
    def validate(self, data, **kwargs):
        _validate_user_associated(user_id=self.get_user_id())

    @post_load
    def post_load(self, data, **kwargs):
        team_id = request.view_args['team_id']
        data['filters'] = {
            '==': {'team_id': team_id},
        }
        return data


class TeamProjectsPostSchema(JWTSchema):
    name = fields.String(required=True, allow_none=False)

    @validates_schema
    def validate(self, data, **kwargs):
        _validate_user_is_manager(user_id=self.get_user_id())

    @post_load
    def post_load(self, data, **kwargs):
        data['team_id'] = request.view_args['team_id']
        return data
