from flask import request, abort
from marshmallow import fields, post_load, validates_schema, Schema
from marshmallow.exceptions import ValidationError
from manage_api.db.services import ProjectService
from manage_api.db.services import TeamService
from manage_api.routes.common_schemas import JWTSchema
from marshmallow import fields, Schema


def _validate_project_in_url():
    project_id = request.view_args['project_id']
    try:
        return ProjectService(id=project_id)
    except ValueError as e:
        abort(404, str(e))


def _validate_user_associated(user_id):
    project = _validate_project_in_url()
    if not project.is_user_associated(user_id):
        abort(401, 'You are not in this project')
    return project


def _validate_user_is_manager(user_id):
    project = _validate_project_in_url()
    team = TeamService(id=project['team_id'])
    if str(team['user_id']) != str(user_id):
        abort(401, 'You are not the manager of this project')
    return project


class ProjectsGetSchema(JWTSchema):
    @post_load
    def post_load(self, data, **kwargs):
        user_id = self.get_user_id()
        data['filters'] = {
            'special': {
                'user': user_id,
            }
        }
        return data


class ProjectGetSchema(JWTSchema):
    @post_load
    def post_load(self, data, **kwargs):
        user_id = self.get_user_id()
        data['project'] = _validate_user_associated(user_id)
        return data


class ProjectPutSchema(JWTSchema):
    name = fields.String(required=True, allow_none=False)


class ProjectDeleteSchema(JWTSchema):
    name = fields.String(required=True, allow_none=False)


class ProjectTagsPostSchema(JWTSchema):
    name = fields.String(required=True, allow_none=False)


class ProjectTagsPutSchema(JWTSchema):
    tags = fields.List(fields.String(), required=True, allow_none=False)


class ProjectStatesPostSchema(JWTSchema):
    name = fields.String(required=True, allow_none=False)
    rank = fields.Integer(required=True, allow_none=False)


class ProjectStatesPutSchema(JWTSchema):
    states = fields.List(
        fields.Nested(ProjectStatesPostSchema), required=True, allow_none=False
    )


class ProjectTaskGroupsPostSchema(JWTSchema):
    name = fields.String(required=True, allow_none=False)


class ProjectTaskGroupPutSchema(JWTSchema):
    name = fields.String(required=True, allow_none=False)


class ProjectTaskGroupDeleteSchema(JWTSchema):
    ...
