from marshmallow import fields, Schema


class Empty(Schema):
    pass


class Token(Schema):
    access_token = fields.String()


class UserProfile(Schema):
    name = fields.String()
    surname = fields.String()
    avatar = fields.String()


class User(Schema):
    id = fields.String()
    username = fields.String()
    email = fields.String()
    profile = fields.Nested(UserProfile)


class LoginResult(Token):
    user = fields.Nested(User)
