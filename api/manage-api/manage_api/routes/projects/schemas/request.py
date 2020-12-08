from marshmallow import fields, Schema


class ProjectPutSchema(Schema):
    name = fields.String(required=True, allow_none=False)


class ProjectTagsPostSchema(Schema):
    name = fields.String(required=True, allow_none=False)


class ProjectTagsPutSchema(Schema):
    tags = fields.List(fields.String(), required=True, allow_none=False)


class ProjectStatesPostSchema(Schema):
    name = fields.String(required=True, allow_none=False)
    rank = fields.Integer(required=True, allow_none=False)


class ProjectStatesPutSchema(Schema):
    states = fields.List(
        fields.Nested(ProjectStatesPostSchema), required=True, allow_none=False
    )


class ProjectTaskGroupsPostSchema(Schema):
    name = fields.String(required=True, allow_none=False)


class ProjectTaskGroupPutSchema(Schema):
    name = fields.String(required=True, allow_none=False)
