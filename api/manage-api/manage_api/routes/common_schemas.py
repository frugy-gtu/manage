from flask_jwt_extended import get_jwt_identity
from marshmallow import Schema, post_load, ValidationError
from manage_api.db.services import UserService


class UserHeadersSchema(Schema):
    @post_load
    def post_load(self, data, **kwargs):
        identity = get_jwt_identity()
        if identity:
            try:
                data['user'] = UserService(id=identity['id'])
                return data
            except ValueError:
                raise ValidationError('User Not Found')
        data['user'] = None
        return data
