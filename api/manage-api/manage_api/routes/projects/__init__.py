from flask_restx import Namespace, Resource

api = Namespace('projects', 'Project related routes')


@api.route('/')
class Projects(Resource):
    def get(self, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:project_id>')
class Project(Resource):
    def get(self, project_id, **kwargs):
        raise NotImplementedError()

    def put(self, project_id, **kwargs):
        raise NotImplementedError()

    def delete(self, project_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:project_id>/tags')
class ProjectTags(Resource):
    def get(self, project_id, **kwargs):
        raise NotImplementedError()

    def post(self, project_id, **kwargs):
        raise NotImplementedError()

    def put(self, project_id, **kwargs):
        raise NotImplementedError()

    def delete(self, project_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:project_id>/states')
class ProjectStates(Resource):
    def get(self, project_id, **kwargs):
        raise NotImplementedError()

    def post(self, project_id, **kwargs):
        raise NotImplementedError()

    def put(self, project_id, **kwargs):
        raise NotImplementedError()

    def delete(self, project_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:project_id>/task_groups')
class ProjectTaskGroups(Resource):
    def get(self, project_id, **kwargs):
        raise NotImplementedError()

    def post(self, project_id, **kwargs):
        raise NotImplementedError()


@api.route('/<uuid:project_id>/task_groups/<uuid:task_group_id>')
class ProjectTaskGroup(Resource):
    def put(self, project_id, task_group_id, **kwargs):
        raise NotImplementedError()

    def delete(self, project_id, task_group_id, **kwargs):
        raise NotImplementedError()
