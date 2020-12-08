from flask_restx import Namespace, Resource
from flask_accepts import accepts

from .schemas import request as request_schemas

api = Namespace('users', 'User related routes')


@api.route('/login')
class Login(Resource):
    @accepts(schema=request_schemas.LoginSchema, api=api)
    def post(self, **kwargs):
        raise NotImplementedError()


@api.route('/signup')
class Signup(Resource):
    @accepts(schema=request_schemas.SignupSchema, api=api)
    def post(self, **kwargs):
        raise NotImplementedError()


@api.route('/activate')
class Activate(Resource):
    @accepts(schema=request_schemas.ActivateSchema, api=api)
    def post(self, **kwargs):
        raise NotImplementedError()
