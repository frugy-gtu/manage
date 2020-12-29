from flask.testing import FlaskClient
from manage_api import create_app
from manage_api.db import models as db_models
from pytest import fixture

from time import sleep


@fixture(scope='function')
def flask_test_client() -> FlaskClient:
    flask_app = create_app('testing')
    with flask_app.test_client() as testing_client:
        with flask_app.app_context():
            try:
                yield testing_client
            finally:
                db_models.db.session.rollback()
                for table in reversed(db_models.db.metadata.sorted_tables):
                    db_models.db.session.execute(table.delete())
                db_models.db.session.commit()
