from flask import Response
from flask.testing import FlaskClient
from manage_api.db import models as db_models
from manage_api.db import services as db_services


def test_user_login_get(flask_test_client):
    response: Response = flask_test_client.get('/users/login')
    assert response.status_code == 405


def test_user_login_delete(flask_test_client):
    response: Response = flask_test_client.delete('/users/login')
    assert response.status_code == 405


def test_user_login_put(flask_test_client):
    response: Response = flask_test_client.put('/users/login')
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


def test_user_signup_get(flask_test_client):
    response: Response = flask_test_client.get('/users/signup')
    assert response.status_code == 405


def test_user_signup_delete(flask_test_client):
    response: Response = flask_test_client.delete('/users/signup')
    assert response.status_code == 405


def test_user_signup_put(flask_test_client):
    response: Response = flask_test_client.put('/users/signup')
    assert response.status_code == 405


def test_user_signup_post_email_username_password(flask_test_client):
    user_data = {
        'username': '_testuser_',
        'email': 'test@user.com',
        'password': '1234567',
    }
    response: Response = flask_test_client.post('/users/signup', json=user_data)
    data = response.get_json()
    assert response.status_code == 201
    assert data['username'] == user_data['username']
    assert data['email'] == user_data['email']
    user = db_models.User.query.get(data['id'])
    assert user is not None
    assert user.username == user_data['username']
    assert user.email == user_data['email']


def test_user_signup_post_used_email_username_password(flask_test_client):
    user_data_1 = {
        'username': '_testuser1_',
        'email': 'test1@user.com',
        'password': '1234567',
    }
    user_data_2 = {
        'username': '_testuser2_',
        'email': 'test1@user.com',
        'password': '1234567',
    }
    db_services.UserService.create(user_data_1)
    response: Response = flask_test_client.post('/users/signup', json=user_data_2)
    assert response.status_code == 400
    assert db_models.User.query.count() == 1


def test_user_signup_post_email_used_username_password(flask_test_client):
    user_data_1 = {
        'username': '_testuser1_',
        'email': 'test1@user.com',
        'password': '1234567',
    }
    user_data_2 = {
        'username': '_testuser1_',
        'email': 'test2@user.com',
        'password': '1234567',
    }
    db_services.UserService.create(user_data_1)
    response: Response = flask_test_client.post('/users/signup', json=user_data_2)
    assert response.status_code == 400
    assert db_models.User.query.count() == 1
