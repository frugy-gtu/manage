from flask.testing import FlaskClient
from manage_api import create_app
from pytest import fixture


@fixture(scope='session')
def flask_test_client() -> FlaskClient:
    flask_app = create_app('testing')
    with flask_app.test_client() as testing_client:
        with flask_app.app_context():
            yield testing_client
