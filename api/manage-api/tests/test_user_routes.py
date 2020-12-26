from flask import Response
from flask.testing import FlaskClient
from manage_api.db import services as db_services


def test_user_login_get(flask_test_client):
    response: Response = flask_test_client.get('/users/login')
    data = response.get_json()
    assert response.status_code == 405


def test_user_login_delete(flask_test_client):
    response: Response = flask_test_client.delete('/users/login')
    data = response.get_json()
    assert response.status_code == 405


def test_user_login_put(flask_test_client):
    response: Response = flask_test_client.put('/users/login')
    data = response.get_json()
    assert response.status_code == 405


def test_user_login_post_email_password(flask_test_client: FlaskClient):
    user_username = '_testuser_'
    user_email = 'test@user.com'
    user_password = '1234567'
    user = db_services.UserService.create(
        {'email': user_email, 'password': user_password, 'username': user_username}
    )
    response: Response = flask_test_client.post(
        '/users/login', json={'email': user_email, 'password': user_password}
    )
    data = response.get_json()
    try:
        assert response.status_code == 200
        assert 'access_token' in data
    finally:
        user.delete()


def test_user_login_post_username_password(flask_test_client):
    response: Response = flask_test_client.put('/users/login')
    data = response.get_json()
    assert response.status_code == 405


def test_user_login_post_email_password(flask_test_client: FlaskClient):
    user_username = '_testuser_'
    user_email = 'test@user.com'
    user_password = '1234567'
    user = db_services.UserService.create(
        {'email': user_email, 'password': user_password, 'username': user_username}
    )
    response: Response = flask_test_client.post(
        '/users/login', json={'username': user_username, 'password': user_password}
    )
    data = response.get_json()
    try:
        assert response.status_code == 200
        assert 'access_token' in data
    finally:
        user.delete()