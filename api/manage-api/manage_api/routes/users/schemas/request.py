from marshmallow import fields, Schema, post_load, validates_schema, ValidationError
from manage_api.db.services import UserService


class LoginSchema(Schema):
    username = fields.String(required=False, allow_none=True)
    email = fields.Email(required=False, allow_none=True)
    password = fields.String(required=True, allow_none=False)

    @post_load
    def post_load(self, data, **kwargs):
        try:
            if 'email' in data:
                if 'username' in data:
                    raise ValidationError('Don\'t user both username and email')
                user = UserService(email=data['email'])
            elif 'username' in data:
                user = UserService(username=data['username'])
            else:
                raise ValidationError('Provide an email or username')
        except ValueError as e:
            raise ValidationError(str(e))
        else:
            if user.check_password(data['password']):
                data['user'] = user
                return data
            raise ValidationError('Wrong Password')


class SignupSchema(Schema):
    username = fields.String(required=True, allow_none=False)
    email = fields.Email(required=True, allow_none=False)
    password = fields.String(required=True, allow_none=False)

    @validates_schema
    def check_uniqueness_of_user(self, data, **kwargs):
        try:
            UserService(username=data['username'])
            raise ValidationError('User with this username exists')
        except ValueError:
            try:
                UserService(email=data['email'])
                raise ValidationError('User with this email exists')
            except ValueError:
                pass


class ActivateSchema(Schema):
    email = fields.Email(required=True, allow_none=False)
    otp = fields.String(required=True, allow_none=False)
