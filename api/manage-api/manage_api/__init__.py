import os

from celery import Celery
from flask import Flask, Response, jsonify, request
from flask import json
from flask_cors import CORS
from flask_migrate import Migrate
from flask_jwt_extended import JWTManager

from manage_api.config import config
from manage_api import config_confidential
from manage_api.db.models import db
from manage_api.routes import rest_api
from manage_api.services.exceptions import InvalidUsage

__version__ = '0.1.0'


def create_app(config_name=None, register_routes=True, register_cli=True):
    app = Flask(__name__)

    # Config
    config_name = config_name or (os.getenv('FLASK_CONFIG') or 'development')
    app.config.from_object(config[config_name])
    app.config.from_object(
        config_confidential
    )  # override confidential configuration values

    # Response
    class AppResponse(Response):
        default_mimetype = 'text/html'

    app.response_class = AppResponse

    # Allow Cors
    CORS(app, supports_credentials=True)

    # Initialize database
    db.init_app(app)
    Migrate(app, db, compare_type=True)

    # jwt
    JWTManager(app)

    # Register routes
    if register_routes:
        rest_api.init_app(app)

    # Register CLI
    if register_cli:
        from manage_api.cli.tune_db import cli as tune_cli

        app.cli.add_command(tune_cli)

    # Handlers

    @app.errorhandler(InvalidUsage)
    def handle_invalid_usage(error):
        response = jsonify(error.to_dict())
        response.status_code = error.status_code
        return response

    @app.errorhandler(NotImplementedError)
    def handle_not_implemented(error):
        response = 'NOT IMPLEMENTED'
        response.status_code = 501
        return response

    @app.before_request
    def for_cors():
        if request.method == 'OPTIONS':
            return jsonify({})

    return app


def create_celery(app):
    celery_app = Celery(
        app.import_name,
        broker='redis://localhost:6379/0',
        backend='redis://localhost:6379/0',
    )
    celery_app.conf.update(app.config)

    class ContextTask(celery_app.Task):
        abstract = True

        def __call__(self, *args, **kwargs):
            with app.app_context():
                return celery_app.Task.__call__(self, *args, **kwargs)

    celery_app.Task = ContextTask
    celery_app.conf.task_default_queue = app.config['CELERY_TASK_DEFAULT_QUEUE']
    return celery_app