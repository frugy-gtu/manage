from flask import Blueprint
from flask_restx import Api

rest_api = Api(
    prefix='/',
    doc='/doc',
    version='0.1.0',
    title='Manage API',
    authorizations={'jwt': {'type': 'apiKey', 'in': 'header', 'name': 'Authorization'}},
    security='jwt',
    validate=True,
)