from flask_restx import Namespace, Resource

api = Namespace('users', 'User related routes')


@api.route('/login')
class Login(Resource):
    def post(self, **kwargs):
        raise NotImplementedError()


@api.route('/signup')
class Signup(Resource):
    def post(self, **kwargs):
        raise NotImplementedError()


@api.route('/activate')
class Activate(Resource):
    def post(self, **kwargs):
        raise NotImplementedError()
