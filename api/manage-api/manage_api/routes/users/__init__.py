from flask import request
from flask_restx import Namespace, Resource
from flask_accepts import accepts, responds
from flask_jwt_extended import create_access_token

from .schemas import request as request_schemas, response as response_schemas
from manage_api.db.services.team import TeamService
from manage_api.db.services.user import UserService

api = Namespace('users', 'User related routes')


@api.route('/login')
class Login(Resource):
    @api.doc(security=None)
    @accepts(schema=request_schemas.LoginSchema, api=api)
    @responds(schema=response_schemas.Token, api=api, status_code=200)
    def post(self, **kwargs):
        data = request.parsed_obj
        access_token = create_access_token(identity={'id': data['user']['id']})
        return {'access_token': access_token}


@api.route('/signup')
class Signup(Resource):
    @api.doc(security=None)
    @accepts(schema=request_schemas.SignupSchema, api=api)
    @responds(schema=response_schemas.User, api=api, status_code=201)
    def post(self, **kwargs):
        data = request.parsed_obj
        user = UserService.create(data)
        team = TeamService.create(
            {
                'name': f'{user["username"]}\'s team',
                'abbreviation': f'{user["username"][:2]}T',
                'user_id': user['id'],
            }
        )
        return user.dump()


@api.route('/activate')
class Activate(Resource):
    @api.doc(security=None)
    @accepts(schema=request_schemas.ActivateSchema, api=api)
    @responds(schema=response_schemas.Empty, api=api, status_code=202)
    def post(self, **kwargs):
        raise NotImplementedError()
