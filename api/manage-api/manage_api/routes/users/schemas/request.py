from flask import abort
from flask.globals import request
from marshmallow import (
    fields,
    Schema,
    pre_load,
    post_load,
    validates_schema,
    ValidationError,
)
from manage_api.routes.common_schemas import JWTSchema
from manage_api.db.services import UserService


class LoginSchema(Schema):
    username = fields.String(required=False, allow_none=True)
    email = fields.Email(required=False, allow_none=True)
    password = fields.String(required=True, allow_none=False)

    @post_load
    def post_load(self, data, **kwargs):
        try:
            if data.get('email'):
                if data.get('username'):
                    raise ValidationError('Don\'t user both username and email')
                user = UserService(email=data['email'], joined_relations=['profile'])
            elif data.get('username'):
                user = UserService(
                    username=data['username'], joined_relations=['profile']
                )
            else:
                raise ValidationError('Provide an email or username')
        except ValueError as e:
            raise ValidationError(str(e))
        else:
            if user.check_password(data['password']):
                data['user'] = user
                return data
            raise abort(401, 'Wrong Password')


class SignupSchema(Schema):
    username = fields.String(required=True, allow_none=False)
    email = fields.Email(required=True, allow_none=False)
    password = fields.String(required=True, allow_none=False)
    name = fields.String(required=False, allow_none=True)
    surname = fields.String(required=False, allow_none=True)
    avatar = fields.String(required=False, allow_none=True)

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

    @post_load
    def post_load(self, data, **kwargs):
        profile_keys = ['name', 'surname', 'avatar']
        data['profile'] = {}
        for k in profile_keys:
            v = data.get(k)
            if v:
                data['profile'][k] = v
                del data[k]
        return data


class UserProfileGetSchema(JWTSchema):
    @post_load
    def post_load(self, data, **kwargs):
        user_id = self.get_user_id()
        data['user'] = UserService(id=user_id, joined_relations=['profile'])
        return data


class UserProfilePutSchema(JWTSchema):
    name = fields.String(required=False, allow_none=True)
    surname = fields.String(required=False, allow_none=True)
    avatar = fields.String(required=False, allow_none=True)

    @post_load
    def post_load(self, data, **kwargs):
        user_id = self.get_user_id()
        data['user'] = UserService(id=user_id, joined_relations=['profile'])
        return data


class UserOtherProfileGetSchema(JWTSchema):
    @post_load
    def post_load(self, data, **kwargs):
        try:
            data['user'] = UserService(
                id=request.view_args['user_id'], joined_relations=['profile']
            )
            return data
        except ValueError as e:
            abort(404, str(e))


class ActivateSchema(Schema):
    email = fields.Email(required=True, allow_none=False)
    otp = fields.String(required=True, allow_none=False)
