from flask import Blueprint
from flask_restx import Api
from . import projects, tasks, teams, users

rest_api = Api(
    prefix='/',
    doc='/doc',
    version='0.1.0',
    title='Manage API',
    authorizations={'jwt': {'type': 'apiKey', 'in': 'header', 'name': 'Authorization'}},
    security='jwt',
    validate=True,
)

rest_api.add_namespace(projects.api)
rest_api.add_namespace(tasks.api)
rest_api.add_namespace(teams.api)
rest_api.add_namespace(users.api)
