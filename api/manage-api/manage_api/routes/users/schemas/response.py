from marshmallow import fields, Schema


class Empty(Schema):
    pass


class Token(Schema):
    access_token = fields.String()
