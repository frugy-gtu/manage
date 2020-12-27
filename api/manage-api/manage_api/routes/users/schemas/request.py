from marshmallow import fields, Schema


class LoginSchema(Schema):
    username = fields.String(required=False, allow_none=True)
    email = fields.Email(required=False, allow_none=True)
    password = fields.String(required=True, allow_none=False)


class SignupSchema(Schema):
    username = fields.String(required=True, allow_none=False)
    email = fields.Email(required=True, allow_none=False)
    password = fields.String(required=True, allow_none=False)


class ActivateSchema(Schema):
    email = fields.Email(required=True, allow_none=False)
    otp = fields.String(required=True, allow_none=False)
