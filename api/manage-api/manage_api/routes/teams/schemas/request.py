from marshmallow import fields, post_load
from manage_api.routes.common_schemas import JWTSchema


class TeamsGetSchema(JWTSchema):
    @post_load
    def post_load(self, data, **kwargs):
        user = self.get_user()
        data['filters'] = {
            '==': {
                'user_id': user['id'],
            }
        }
        return data


class TeamsPostSchema(JWTSchema):
    name = fields.String(required=True, allow_none=False)
    abbreviation = fields.String(required=True, allow_none=False)


class TeamPutSchema(JWTSchema):
    name = fields.String(required=False, allow_none=True)
    abbreviation = fields.String(required=False, allow_none=True)


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


class TeamProjectsPostSchema(JWTSchema):
    name = fields.String(required=True, allow_none=False)
