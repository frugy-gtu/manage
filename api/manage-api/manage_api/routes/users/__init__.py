from flask_restx import Namespace, Resource
from flask_accepts import accepts, responds

from .schemas import request as request_schemas, response as response_schemas

api = Namespace('users', 'User related routes')


@api.route('/login')
class Login(Resource):
    @accepts(schema=request_schemas.LoginSchema, api=api)
    @responds(schema=response_schemas.Token, api=api, status_code=200)
    def post(self, **kwargs):
        raise NotImplementedError()


@api.route('/signup')
class Signup(Resource):
    @accepts(schema=request_schemas.SignupSchema, api=api)
    @responds(schema=response_schemas.Empty, api=api, status_code=201)
    def post(self, **kwargs):
        raise NotImplementedError()


@api.route('/activate')
class Activate(Resource):
    @accepts(schema=request_schemas.ActivateSchema, api=api)
    @responds(schema=response_schemas.Empty, api=api, status_code=202)
    def post(self, **kwargs):
        raise NotImplementedError()
