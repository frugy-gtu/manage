from marshmallow import fields, Schema


class Base(Schema):
    id = fields.UUID()
    created_at = fields.String()


class Project(Base):
    name = fields.String()
    team_id = fields.UUID()


class ProjectTag(Base):
    name = fields.String()


class ProjectState(Base):
    name = fields.String()
    rank = fields.Integer()


class TaskGroup(Base):
    name = fields.String()
