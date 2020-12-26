from flask_jwt_extended import get_jwt_identity
from marshmallow import Schema, post_load, ValidationError
from manage_api.db.services import UserService


class JWTSchema(Schema):
    def get_user(self):
        identity = get_jwt_identity()
        if identity:
            try:
                return UserService(id=identity['id'])
            except ValueError:
                raise ValidationError('User Not Found')
        return None
