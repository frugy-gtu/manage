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
    assert response.status_code == 200
    assert 'access_token' in data


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
    assert response.status_code == 200
    assert 'access_token' in data


def test_user_login_post_email_password_profile_data(flask_test_client: FlaskClient):
    user_username = '_testuser_'
    user_email = 'test@user.com'
    user_password = '1234567'
    user = db_services.UserService.create(
        {'email': user_email, 'password': user_password, 'username': user_username}
    )
    profile_data = {
        'name': 'Test',
        'surname': 'User',
    }
    user.upsert_profile(profile_data)
    response: Response = flask_test_client.post(
        '/users/login', json={'email': user_email, 'password': user_password}
    )
    data = response.get_json()
    assert response.status_code == 200
    assert 'access_token' in data
    assert 'user' in data
    assert data['user']['username'] == user['username']
    assert data['user']['email'] == user['email']
    assert data['user']['profile']['name'] == profile_data['name']
    assert data['user']['profile']['surname'] == profile_data['surname']


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
    assert db_models.Team.query.count() == 1
    team = db_models.Team.query.first()
    assert team.user_id == user.id


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


def test_user_signup_email_username_password_profile(flask_test_client):
    user_data = {
        'username': '_testuser_',
        'email': 'test@user.com',
        'password': '1234567',
        'name': 'Test',
        'surname': 'User',
    }
    response: Response = flask_test_client.post('/users/signup', json=user_data)
    data = response.get_json()
    assert response.status_code == 201
    assert data['username'] == user_data['username']
    assert data['email'] == user_data['email']
    assert data['profile']['name'] == user_data['name']
    assert data['profile']['surname'] == user_data['surname']
    user = db_models.User.query.get(data['id'])
    assert user is not None
    assert user.username == user_data['username']
    assert user.email == user_data['email']
    assert db_models.UserProfile.query.count() == 1
    profile = db_models.UserProfile.query.first()
    assert profile.name == user_data['name']
    assert profile.surname == user_data['surname']
    assert profile.user_id == user.id


def test_user_profile_post(flask_test_client):
    response: Response = flask_test_client.post('/users/profile')
    assert response.status_code == 405


def test_user_profile_delete(flask_test_client):
    response: Response = flask_test_client.delete('/users/profile')
    assert response.status_code == 405


def test_user_profile_get_without_jwt(flask_test_client):
    user_username = '_testuser_'
    user_email = 'test@user.com'
    user_password = '1234567'
    user = db_services.UserService.create(
        {'email': user_email, 'password': user_password, 'username': user_username}
    )
    profile_data = {
        'name': 'Test',
        'surname': 'User',
    }
    user.upsert_profile(profile_data)
    response: Response = flask_test_client.get('/users/profile')
    assert response.status_code == 401


def test_user_profile_get_with_jwt(flask_test_client):
    user_username = '_testuser_'
    user_email = 'test@user.com'
    user_password = '1234567'
    user = db_services.UserService.create(
        {'email': user_email, 'password': user_password, 'username': user_username}
    )
    _ = db_services.UserService.create(
        {'email': 'test2@user.com', 'password': 'qweqwe', 'username': '_testuser2_'}
    )
    profile_data = {
        'name': 'Test',
        'surname': 'User',
    }
    user.upsert_profile(profile_data)
    access_token = user.create_access_token()
    headers = {'Authorization': f'Bearer {access_token}'}
    response: Response = flask_test_client.get('/users/profile', headers=headers)
    data = response.get_json()
    assert response.status_code == 200
    assert data['id'] == str(user['id'])
    assert data['username'] == user['username']
    assert data['profile']['name'] == profile_data['name']
    assert data['profile']['surname'] == profile_data['surname']


def test_user_profile_put_without_jwt(flask_test_client):
    user_username = '_testuser_'
    user_email = 'test@user.com'
    user_password = '1234567'
    user = db_services.UserService.create(
        {'email': user_email, 'password': user_password, 'username': user_username}
    )
    profile_data = {
        'name': 'Test',
        'surname': 'User',
    }
    user.upsert_profile(profile_data)
    new_profile_data = {
        'name': 'NewTest',
        'surname': 'NewUser',
    }
    response: Response = flask_test_client.put('/users/profile', json=new_profile_data)
    assert response.status_code == 401


def test_user_profile_put_with_jwt(flask_test_client):
    user_username = '_testuser_'
    user_email = 'test@user.com'
    user_password = '1234567'
    user = db_services.UserService.create(
        {'email': user_email, 'password': user_password, 'username': user_username}
    )
    profile_data = {
        'name': 'Test',
        'surname': 'User',
    }
    user.upsert_profile(profile_data)
    access_token = user.create_access_token()
    headers = {'Authorization': f'Bearer {access_token}'}
    new_profile_data = {
        'name': 'NewTest',
        'surname': 'NewUser',
    }
    response: Response = flask_test_client.put(
        '/users/profile', json=new_profile_data, headers=headers
    )
    data = response.get_json()
    assert response.status_code == 200
    assert data['id'] == str(user['id'])
    assert data['username'] == user['username']
    assert data['profile']['name'] == new_profile_data['name']
    assert data['profile']['surname'] == new_profile_data['surname']


def test_user_other_profile_post(flask_test_client):
    user_username = '_testuser_'
    user_email = 'test@user.com'
    user_password = '1234567'
    user = db_services.UserService.create(
        {'email': user_email, 'password': user_password, 'username': user_username}
    )
    response: Response = flask_test_client.post(f'/users/profile/{user["id"]}')
    assert response.status_code == 405


def test_user_other_profile_put(flask_test_client):
    user_username = '_testuser_'
    user_email = 'test@user.com'
    user_password = '1234567'
    user = db_services.UserService.create(
        {'email': user_email, 'password': user_password, 'username': user_username}
    )
    response: Response = flask_test_client.put(f'/users/profile/{user["id"]}')
    assert response.status_code == 405


def test_user_other_profile_delete(flask_test_client):
    user_username = '_testuser_'
    user_email = 'test@user.com'
    user_password = '1234567'
    user = db_services.UserService.create(
        {'email': user_email, 'password': user_password, 'username': user_username}
    )
    response: Response = flask_test_client.delete(f'/users/profile/{user["id"]}')
    assert response.status_code == 405


def test_user_profile_get_without_jwt(flask_test_client):
    user_username = '_testuser_'
    user_email = 'test@user.com'
    user_password = '1234567'
    user = db_services.UserService.create(
        {'email': user_email, 'password': user_password, 'username': user_username}
    )
    user2 = db_services.UserService.create(
        {'email': 'test2@user.com', 'password': 'qweqwe', 'username': '_testuser2_'}
    )
    profile_data = {
        'name': 'Test',
        'surname': 'User',
    }
    user.upsert_profile(profile_data)
    profile_data2 = {
        'name': 'Test2',
        'surname': 'User2',
    }
    user2.upsert_profile(profile_data2)
    response: Response = flask_test_client.get(f'/users/profile/{user["id"]}')
    assert response.status_code == 401


def test_user_profile_get_with_jwt(flask_test_client):
    user_username = '_testuser_'
    user_email = 'test@user.com'
    user_password = '1234567'
    user = db_services.UserService.create(
        {'email': user_email, 'password': user_password, 'username': user_username}
    )
    user2 = db_services.UserService.create(
        {'email': 'test2@user.com', 'password': 'qweqwe', 'username': '_testuser2_'}
    )
    profile_data = {
        'name': 'Test',
        'surname': 'User',
    }
    user.upsert_profile(profile_data)
    profile_data2 = {
        'name': 'Test2',
        'surname': 'User2',
    }
    user2.upsert_profile(profile_data2)
    access_token = user2.create_access_token()
    headers = {'Authorization': f'Bearer {access_token}'}
    response: Response = flask_test_client.get(
        f'/users/profile/{user["id"]}', headers=headers
    )
    data = response.get_json()
    assert response.status_code == 200
    assert data['id'] == str(user['id'])
    assert data['username'] == user['username']
    assert data['profile']['name'] == profile_data['name']
    assert data['profile']['surname'] == profile_data['surname']
