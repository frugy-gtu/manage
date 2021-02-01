from flask_jwt_extended import get_jwt_identity
from marshmallow import fields, Schema, post_load, ValidationError
from manage_api.db.services import UserService


class BoolResult(Schema):
    result = fields.Boolean()


class JWTSchema(Schema):
    def get_user_id(self):
        identity = get_jwt_identity()
        if identity:
            return identity['id']
        return None

    def get_user(self):
        id = self.get_user_id()
        if id:
            try:
                return UserService(id=id)
            except ValueError:
                raise ValidationError('User Not Found')
        return None
