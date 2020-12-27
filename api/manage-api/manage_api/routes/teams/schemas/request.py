from marshmallow import fields, Schema


class TeamsPostSchema(Schema):
    name = fields.String(required=True, allow_none=False)
    abbreviation = fields.String(required=True, allow_none=False)


class TeamPutSchema(Schema):
    name = fields.String(required=False, allow_none=True)
    abbreviation = fields.String(required=False, allow_none=True)


class TeamTagsPostSchema(Schema):
    name = fields.String(required=True, allow_none=False)


class TeamTagsPutSchema(Schema):
    tags = fields.List(fields.String(), required=True, allow_none=False)


class TeamStatesPostSchema(Schema):
    name = fields.String(required=True, allow_none=False)
    rank = fields.Integer(required=True, allow_none=False)


class TeamStatesPutSchema(Schema):
    states = fields.List(
        fields.Nested(TeamStatesPostSchema), required=True, allow_none=False
    )


class TeamProjectsPostSchema(Schema):
    name = fields.String(required=True, allow_none=False)
