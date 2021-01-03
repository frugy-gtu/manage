from flask import request, abort
from marshmallow import fields, post_load, validates_schema, Schema
from marshmallow.exceptions import ValidationError
from manage_api.db.services import ProjectService
from manage_api.db.services import TaskService
from manage_api.db.services import TaskGroupService
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

    @post_load
    def post_load(self, data, **kwargs):
        user_id = self.get_user_id()
        data['project'] = _validate_user_is_manager(user_id)
        return data


class ProjectDeleteSchema(JWTSchema):
    @validates_schema
    def validate_project_is_empty(self, data, **kwargs):
        if (
            len(
                list(
                    TaskGroupService.dump_all(
                        filters={'==': {'project_id': request.view_args['project_id']}}
                    )
                )
            )
            > 0
        ):
            abort(412, 'Project is not empty')

    @post_load
    def post_load(self, data, **kwargs):
        user_id = self.get_user_id()
        data['project'] = _validate_user_is_manager(user_id)
        return data


class ProjectTagsPostSchema(JWTSchema):
    name = fields.String(required=True, allow_none=False)


class ProjectTagsPutSchema(JWTSchema):
    tags = fields.List(fields.String(), required=True, allow_none=False)


class ProjectStatesGetSchema(JWTSchema):
    @post_load
    def post_load(self, data, **kwargs):
        data['project'] = _validate_user_is_manager(self.get_user_id())
        return data


class ProjectStatesPostSchema(JWTSchema):
    name = fields.String(required=True, allow_none=False)
    rank = fields.Integer(required=True, allow_none=False)


class ProjectStatesPutSchema(JWTSchema):
    states = fields.List(
        fields.Nested(ProjectStatesPostSchema), required=True, allow_none=False
    )


class ProjectTaskGroupsGetSchema(JWTSchema):
    @post_load
    def post_load(self, data, **kwargs):
        user_id = self.get_user_id()
        project = _validate_user_associated(user_id=user_id)
        data['filters'] = {
            '==': {
                'project_id': project['id'],
            },
        }
        return data


class ProjectTaskGroupsPostSchema(JWTSchema):
    name = fields.String(required=True, allow_none=False)

    @validates_schema
    def validate(self, data, **kwargs):
        _validate_user_is_manager(self.get_user_id())

    @post_load
    def post_load(self, data, **kwargs):
        data['project_id'] = request.view_args['project_id']
        return data


class ProjectTaskGroupPutSchema(JWTSchema):
    name = fields.String(required=True, allow_none=False)

    @validates_schema
    def validate(self, data, **kwargs):
        _validate_user_is_manager(self.get_user_id())

    @post_load
    def post_load(self, data, **kwargs):
        try:
            task_group = TaskGroupService(id=request.view_args['task_group_id'])
            if task_group['project_id'] != request.view_args['project_id']:
                abort(404, 'Task group not found in project')
            data['task_group'] = task_group
            return data
        except ValueError as e:
            raise ValidationError(str(e))


class ProjectTaskGroupDeleteSchema(JWTSchema):
    @validates_schema
    def validate(self, data, **kwargs):
        _validate_user_is_manager(self.get_user_id())

    @post_load
    def post_load(self, data, **kwargs):
        try:
            task_group = TaskGroupService(id=request.view_args['task_group_id'])
            if task_group['project_id'] != request.view_args['project_id']:
                abort(404, 'Task group not found in project')
            data['task_group'] = task_group
            return data
        except ValueError as e:
            raise ValidationError(str(e))
