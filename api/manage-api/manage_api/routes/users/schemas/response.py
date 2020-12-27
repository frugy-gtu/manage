from marshmallow import fields, Schema


class Empty(Schema):
    pass


class Token(Schema):
    access_token = fields.String()


class User(Schema):
    id = fields.String()
    username = fields.String()
    email = fields.String()
