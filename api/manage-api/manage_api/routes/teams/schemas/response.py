from marshmallow import fields, Schema


class Base(Schema):
    id = fields.UUID()
    created_at = fields.DateTime()


class Team(Base):
    name = fields.String()
    abbreviation = fields.String()


class TeamUser(Base):
    username = fields.String()
    email = fields.Email()


class JoinRequest(Base):
    user_id = fields.UUID()


class TeamTag(Base):
    name = fields.String()


class TeamState(Base):
    name = fields.String()
    rank = fields.Integer()


class TeamProject(Base):
    name = fields.String()
