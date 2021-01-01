from marshmallow import fields, Schema
from manage_api.routes.common_schemas import BoolResult


class TeamBase(Schema):
    id = fields.UUID()
    created_at = fields.String()


class Team(TeamBase):
    name = fields.String()
    abbreviation = fields.String()


class TeamUser(TeamBase):
    username = fields.String()
    email = fields.Email()


class JoinRequest(TeamBase):
    user_id = fields.UUID()


class TeamTag(TeamBase):
    name = fields.String()


class TeamState(TeamBase):
    name = fields.String()
    rank = fields.Integer()


class TeamProject(TeamBase):
    name = fields.String()
