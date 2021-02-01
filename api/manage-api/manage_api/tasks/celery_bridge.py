import os
from manage_api import create_app, create_celery

flask_app = create_app(
    os.getenv('FLASK_CONFIG') or 'development',
    register_blueprints=False,
    register_cli=False,
)
celery = create_celery(flask_app)
