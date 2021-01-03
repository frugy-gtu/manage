from flask import request
from flask_restx import Namespace, Resource
from flask_accepts import accepts, responds
from flask_jwt_extended import create_access_token, jwt_required

from .schemas import request as request_schemas, response as response_schemas
from manage_api.db.services.team import TeamService
from manage_api.db.services.user import UserService

api = Namespace('users', 'User related routes')


@api.route('/login')
class Login(Resource):
    @api.doc(security=None)
    @accepts(schema=request_schemas.LoginSchema, api=api)
    @responds(schema=response_schemas.LoginResult, api=api, status_code=200)
    def post(self, **kwargs):
        data = request.parsed_obj
        access_token = create_access_token(identity={'id': data['user']['id']})
        result = {'access_token': access_token}
        result['user'] = data['user'].dump()
        print(result)
        return result


@api.route('/signup')
class Signup(Resource):
    @api.doc(security=None)
    @accepts(schema=request_schemas.SignupSchema, api=api)
    @responds(schema=response_schemas.User, api=api, status_code=201)
    def post(self, **kwargs):
        data = request.parsed_obj
        profile_data = data['profile']
        del data['profile']
        user = UserService.create(data)
        profile = user.upsert_profile(profile_data)
        team = TeamService.create(
            {
                'name': f'{user["username"]}\'s team',
                'abbreviation': f'{user["username"][0].upper()}T',
                'user_id': user['id'],
            }
        )
        team.update_states(['todo', 'in-progress', 'done', 'cancel'])
        result = user.dump()
        result['profile'] = profile
        return result


@api.route('/profile')
class Profile(Resource):
    @jwt_required
    @accepts(query_params_schema=request_schemas.UserProfileGetSchema, api=api)
    @responds(schema=response_schemas.User, api=api, status_code=200)
    def get(self, **kwargs):
        params = request.parsed_query_params
        user_data = params['user'].dump()
        return user_data

    @jwt_required
    @accepts(schema=request_schemas.UserProfilePutSchema, api=api)
    @responds(schema=response_schemas.User, api=api, status_code=200)
    def put(self, **kwargs):
        data = request.parsed_obj
        user: UserService = data['user']
        del data['user']
        p = user.upsert_profile(data)
        result = user.dump()
        result['profile'] = p
        return result


@api.route('/profile/<uuid:user_id>')
class OtherProfile(Resource):
    @jwt_required
    @accepts(query_params_schema=request_schemas.UserOtherProfileGetSchema, api=api)
    @responds(schema=response_schemas.User, api=api, status_code=200)
    def get(self, user_id, **kwargs):
        params = request.parsed_query_params
        user_data = params['user'].dump()
        user_data['profile'] = params['user'].dump_profile()
        return user_data


@api.route('/activate')
class Activate(Resource):
    @api.doc(security=None)
    @accepts(schema=request_schemas.ActivateSchema, api=api)
    @responds(schema=response_schemas.Empty, api=api, status_code=202)
    def post(self, **kwargs):
        raise NotImplementedError()
