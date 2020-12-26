from flask import Response
from flask.testing import FlaskClient
from manage_api.db import models as db_models
from manage_api.db import services as db_services


def test_teams_put(flask_test_client):
    response: Response = flask_test_client.put('/teams/')
    assert response.status_code == 405


def test_teams_delete(flask_test_client):
    response: Response = flask_test_client.delete('/teams/')
    assert response.status_code == 405


def test_teams_get_without_jwt(flask_test_client):
    response: Response = flask_test_client.get('/teams/')
    assert response.status_code == 401


def test_teams_get_with_jwt(flask_test_client):
    user_data = {
        'username': 'test_user',
        'email': 'test@user.com',
        'password': '123123asd',
    }
    user = db_services.UserService.create(user_data)
    access_token = user.create_access_token()
    headers = {'Authorization': f'Bearer {access_token}'}
    team_1_data = {
        'name': 'test_team_1',
        'abbreviation': 'tt1',
        'user_id': user['id'],
    }
    team_2_data = {
        'name': 'test_team_2',
        'abbreviation': 'tt2',
        'user_id': user['id'],
    }
    team_1 = db_services.TeamService.create(team_1_data).dump()
    team_2 = db_services.TeamService.create(team_2_data).dump()
    response: Response = flask_test_client.get('/teams/', headers=headers)
    data = response.get_json()
    assert response.status_code == 200
    assert len(data) == 2
    team2 = data[0]
    team1 = data[1]
    assert team1['id'] == team_1['id']
    assert team1['name'] == team_1['name']
    assert team2['id'] == team_2['id']
    assert team2['name'] == team_2['name']


def test_teams_get_only_current_users_teams(flask_test_client):
    user_data = {
        'username': 'test_user',
        'email': 'test@user.com',
        'password': '123123asd',
    }
    user2_data = {
        'username': 'test_user2',
        'email': 'test2@user.com',
        'password': '123123asd',
    }
    user = db_services.UserService.create(user_data)
    user2 = db_services.UserService.create(user2_data)
    access_token = user.create_access_token()
    headers = {'Authorization': f'Bearer {access_token}'}
    team_1_data = {
        'name': 'test_team_1',
        'abbreviation': 'tt1',
        'user_id': user['id'],
    }
    team_2_data = {
        'name': 'test_team_2',
        'abbreviation': 'tt2',
        'user_id': user['id'],
    }
    team_3_data = {
        'name': 'test_team_3',
        'abbreviation': 'tt3',
        'user_id': user2['id'],
    }
    team_1 = db_services.TeamService.create(team_1_data).dump()
    team_2 = db_services.TeamService.create(team_2_data).dump()
    _ = db_services.TeamService.create(team_3_data).dump()
    response: Response = flask_test_client.get('/teams/', headers=headers)
    data = response.get_json()
    assert response.status_code == 200
    assert len(data) == 2
    team2 = data[0]
    team1 = data[1]
    assert team1['id'] == team_1['id']
    assert team1['name'] == team_1['name']
    assert team2['id'] == team_2['id']
    assert team2['name'] == team_2['name']


def test_team_get_without_jwt(flask_test_client):
    user_data = {
        'username': 'test_user',
        'email': 'test@user.com',
        'password': '123123asd',
    }
    user = db_services.UserService.create(user_data)
    team_data_1 = {
        'name': 'test_team_1',
        'abbreviation': 'tt1',
        'user_id': user['id'],
    }
    team_1 = db_services.TeamService.create(team_data_1).dump()
    response: Response = flask_test_client.get(f'/teams/{team_1["id"]}')
    assert response.status_code == 401


def test_team_get_with_jwt(flask_test_client):
    user_data = {
        'username': 'test_user',
        'email': 'test@user.com',
        'password': '123123asd',
    }
    user = db_services.UserService.create(user_data)
    access_token = user.create_access_token()
    headers = {'Authorization': f'Bearer {access_token}'}
    team_data_1 = {
        'name': 'test_team_1',
        'abbreviation': 'tt1',
        'user_id': user['id'],
    }
    team_1 = db_services.TeamService.create(team_data_1).dump()
    response: Response = flask_test_client.get(
        f'/teams/{team_1["id"]}', headers=headers
    )
    data = response.get_json()
    assert response.status_code == 200
    assert data['id'] == team_1['id']
    assert data['name'] == team_data_1['name']
    assert data['abbreviation'] == team_data_1['abbreviation']


def test_team_get_with_jwt_not_associated_user(flask_test_client):
    user_data = {
        'username': 'test_user',
        'email': 'test@user.com',
        'password': '123123asd',
    }
    user = db_services.UserService.create(user_data)
    user_data_2 = {
        'username': 'test_user2',
        'email': 'test2@user.com',
        'password': '123123asd',
    }
    user2 = db_services.UserService.create(user_data_2)
    access_token = user.create_access_token()
    headers = {'Authorization': f'Bearer {access_token}'}
    team_data_1 = {
        'name': 'test_team_1',
        'abbreviation': 'tt1',
        'user_id': user2['id'],
    }
    team_1 = db_services.TeamService.create(team_data_1).dump()
    response: Response = flask_test_client.get(
        f'/teams/{team_1["id"]}', headers=headers
    )
    assert response.status_code == 401
