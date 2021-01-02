from flask import request, abort
from marshmallow import fields, post_load, validates_schema, Schema
from marshmallow.exceptions import ValidationError
from manage_api.db.services import ProjectService
from manage_api.db.services import TeamService
from manage_api.db.services import UserService
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
    return team


def _validate_user_is_manager(user_id):
    team = _validate_team_in_url()
    if str(team['user_id']) != str(user_id):
        abort(401, 'You are not the manager of this team')
    return team


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
    @validates_schema
    def validate_team_has_no_project(self, data, **kwargs):
        if (
            len(
                ProjectService.dump_all(
                    filters={
                        '==': {
                            'team_id': request.view_args['team_id'],
                        },
                    },
                )
            )
            > 0
        ):
            abort(
                412,
                'Cannot delete team because it has projects. First delete the projects.',
            )

    @post_load
    def post_load(self, data, **kwargs):
        user = self.get_user()
        team = _validate_user_is_manager(user['id'])
        data['team'] = team
        return data


class TeamUsersGetSchema(JWTSchema):
    @validates_schema
    def validate(self, data, **kwargs):
        _validate_user_associated(user_id=self.get_user_id())

    @post_load
    def post_load(self, data, **kwargs):
        data['filters'] = {
            'special': {
                'team': request.view_args['team_id'],
            }
        }
        return data


class TeamUsersPostSchema(JWTSchema):
    user_id = fields.UUID(required=False, allow_none=True)
    username = fields.String(required=False, allow_none=True)

    @post_load
    def post_load(self, data, **kwargs):
        try:
            if not data.get('user_id'):
                if not data.get('username'):
                    abort(400)
                user = UserService(username=data['username'])
                data['user_id'] = str(user['id'])
            else:
                UserService(id=data['user_id'])
        except ValueError as e:
            abort(404, 'User not found')
        team = _validate_user_is_manager(user_id=self.get_user_id())
        if team.is_user_associated(data['user_id']):
            data['team'] = None
            return data
        data['team'] = team
        return data


class TeamTagsPostSchema(JWTSchema):
    name = fields.String(required=True, allow_none=False)


class TeamTagsPutSchema(JWTSchema):
    tags = fields.List(fields.String(), required=True, allow_none=False)


class TeamStatesGetSchema(JWTSchema):
    @post_load
    def post_load(self, data, **kwargs):
        data['team'] = _validate_user_is_manager(self.get_user_id())
        return data


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
