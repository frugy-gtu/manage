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


def test_teams_post_without_jwt(flask_test_client):
    team_data = {
        'name': 'test_team_1',
        'abbreviation': 'tt1',
    }
    response: Response = flask_test_client.post('/teams/', json=team_data)
    assert response.status_code == 401


def test_teams_post_with_jwt(flask_test_client):
    user_data = {
        'username': 'test_user',
        'email': 'test@user.com',
        'password': '123123asd',
    }
    user = db_services.UserService.create(user_data)
    access_token = user.create_access_token()
    headers = {'Authorization': f'Bearer {access_token}'}
    team_data = {
        'name': 'test_team_1',
        'abbreviation': 'tt1',
    }
    response: Response = flask_test_client.post(
        '/teams/', json=team_data, headers=headers
    )
    data = response.get_json()
    assert response.status_code == 201
    assert data['abbreviation'] == team_data['abbreviation']
    assert data['name'] == team_data['name']


def test_teams_post_with_jwt_existing_name(flask_test_client):
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
    team_data_2 = {
        'name': 'test_team_1',
        'abbreviation': 'tt2',
    }
    response: Response = flask_test_client.post(
        '/teams/', json=team_data_2, headers=headers
    )
    data = response.get_json()
    assert response.status_code == 400
    assert db_models.Team.query.count() == 1


def test_teams_post_with_jwt_existing_name(flask_test_client):
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
    team_data_2 = {
        'name': 'test_team_1',
        'abbreviation': 'tt2',
    }
    response: Response = flask_test_client.post(
        '/teams/', json=team_data_2, headers=headers
    )
    assert response.status_code == 400
    assert db_models.Team.query.count() == 1


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


def test_team_put_without_jwt(flask_test_client):
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
    team_update_data = {
        'name': 'test_team_new_name',
    }
    response: Response = flask_test_client.put(
        f'/teams/{team_1["id"]}',
        json=team_update_data,
    )
    assert response.status_code == 401


def test_team_put_with_jwt(flask_test_client):
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
    team_update_data = {
        'name': 'test_team_new_name',
    }
    response: Response = flask_test_client.put(
        f'/teams/{team_1["id"]}', json=team_update_data, headers=headers
    )
    data = response.get_json()
    assert response.status_code == 200
    assert data['id'] == team_1['id']
    assert data['name'] == team_update_data['name']
    assert data['abbreviation'] == team_data_1['abbreviation']
    team = db_models.Team.query.get(data['id'])
    assert team is not None
    assert team.name == team_update_data['name']


def test_team_put_with_jwt_not_manager(flask_test_client):
    user_data = {
        'username': 'test_user',
        'email': 'test@user.com',
        'password': '123123asd',
    }
    user = db_services.UserService.create(user_data)
    access_token = user.create_access_token()
    user_data_2 = {
        'username': 'test_user2',
        'email': 'test2@user.com',
        'password': '123123asd',
    }
    user2 = db_services.UserService.create(user_data_2)
    headers = {'Authorization': f'Bearer {access_token}'}
    team_data_1 = {
        'name': 'test_team_1',
        'abbreviation': 'tt1',
        'user_id': user2['id'],
    }
    team_1 = db_services.TeamService.create(team_data_1).dump()
    team_update_data = {
        'name': 'test_team_new_name',
    }
    response: Response = flask_test_client.put(
        f'/teams/{team_1["id"]}', json=team_update_data, headers=headers
    )
    data = response.get_json()
    assert response.status_code == 401
    team = db_models.Team.query.get(team_1['id'])
    assert team is not None
    assert team.name != team_update_data['name']
    assert team.name == team_data_1['name']


def test_team_delete_without_jwt(flask_test_client):
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
    response: Response = flask_test_client.delete(
        f'/teams/{team_1["id"]}',
    )
    assert response.status_code == 401


def test_team_delete_with_jwt(flask_test_client):
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
    response: Response = flask_test_client.delete(
        f'/teams/{team_1["id"]}', headers=headers
    )
    data = response.get_json()
    assert response.status_code == 200
    assert data['id'] == team_1['id']
    assert data['name'] == team_1['name']
    assert data['abbreviation'] == team_1['abbreviation']
    team = db_models.Team.query.get(team_1['id'])
    assert team is None


def test_team_delete_with_jwt_contains_project(flask_test_client):
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
    project_data_1 = {'name': 'test_project_1', 'team_id': team_1['id']}
    _ = db_services.ProjectService.create(project_data_1)
    response: Response = flask_test_client.delete(
        f'/teams/{team_1["id"]}', headers=headers
    )
    data = response.get_json()
    assert response.status_code == 412
    assert db_models.Team.query.count() == 1


def test_team_delete_with_jwt_not_manager(flask_test_client):
    user_data = {
        'username': 'test_user',
        'email': 'test@user.com',
        'password': '123123asd',
    }
    user = db_services.UserService.create(user_data)
    access_token = user.create_access_token()
    headers = {'Authorization': f'Bearer {access_token}'}
    user_data_2 = {
        'username': 'test_user2',
        'email': 'test2@user.com',
        'password': '123123asd',
    }
    user2 = db_services.UserService.create(user_data_2)
    team_data_1 = {
        'name': 'test_team_1',
        'abbreviation': 'tt1',
        'user_id': user2['id'],
    }
    team_1 = db_services.TeamService.create(team_data_1).dump()
    response: Response = flask_test_client.delete(
        f'/teams/{team_1["id"]}', headers=headers
    )
    data = response.get_json()
    assert response.status_code == 401
    team = db_models.Team.query.get(team_1['id'])
    assert team is not None


def test_team_projects_get_without_jwt(flask_test_client):
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
    project_data_1 = {'name': 'test_project_1', 'team_id': team_1['id']}
    project_data_2 = {'name': 'test_project_1', 'team_id': team_1['id']}
    _ = db_services.ProjectService.create(project_data_1).dump()
    _ = db_services.ProjectService.create(project_data_2).dump()
    response: Response = flask_test_client.get(f'/teams/{team_1["id"]}/projects')
    assert response.status_code == 401


def test_team_projects_get_with_jwt(flask_test_client):
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
    project_data_1 = {'name': 'test_project_1', 'team_id': team_1['id']}
    project_data_2 = {'name': 'test_project_1', 'team_id': team_1['id']}
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    project_2 = db_services.ProjectService.create(project_data_2).dump()
    response: Response = flask_test_client.get(
        f'/teams/{team_1["id"]}/projects', headers=headers
    )
    data = response.get_json()
    assert response.status_code == 200
    assert len(data) == 2
    project1 = data[1]
    project2 = data[0]
    assert project1['id'] == project_1['id']
    assert project1['name'] == project_1['name']
    assert project2['id'] == project_2['id']
    assert project2['name'] == project_2['name']


def test_team_projects_get_with_jwt_cuurent_teams_project(flask_test_client):
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
    project_data_1 = {'name': 'test_project_1', 'team_id': team_1['id']}
    project_data_2 = {'name': 'test_project_1', 'team_id': team_1['id']}
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    project_2 = db_services.ProjectService.create(project_data_2).dump()
    response: Response = flask_test_client.get(
        f'/teams/{team_1["id"]}/projects', headers=headers
    )
    data = response.get_json()
    assert response.status_code == 200
    assert len(data) == 2
    project1 = data[1]
    project2 = data[0]
    assert project1['id'] == project_1['id']
    assert project1['name'] == project_1['name']
    assert project2['id'] == project_2['id']
    assert project2['name'] == project_2['name']


def test_team_projects_post_without_jwt(flask_test_client):
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
    project_data_1 = {'name': 'test_project_1'}
    response: Response = flask_test_client.post(
        f'/teams/{team_1["id"]}/projects', json=project_data_1
    )
    data = response.get_json()
    assert response.status_code == 401


def test_team_projects_post_with_jwt(flask_test_client):
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
    project_data_1 = {'name': 'test_project_1'}
    response: Response = flask_test_client.post(
        f'/teams/{team_1["id"]}/projects', json=project_data_1, headers=headers
    )
    data = response.get_json()
    print(data)
    assert response.status_code == 201
    assert db_models.Project.query.count() == 1
    project = db_models.Project.query.get(data['id'])
    assert project is not None
    assert project.name == project_data_1['name']


def test_team_projects_post_with_jwt_not_manager(flask_test_client):
    user_data = {
        'username': 'test_user',
        'email': 'test@user.com',
        'password': '123123asd',
    }
    user = db_services.UserService.create(user_data)
    access_token = user.create_access_token()
    headers = {'Authorization': f'Bearer {access_token}'}
    user2_data = {
        'username': 'test_user2',
        'email': 'test2@user.com',
        'password': '123123asd',
    }
    user2 = db_services.UserService.create(user2_data)
    team_data_1 = {
        'name': 'test_team_1',
        'abbreviation': 'tt1',
        'user_id': user2['id'],
    }
    team_1 = db_services.TeamService.create(team_data_1).dump()
    project_data_1 = {'name': 'test_project_1'}
    response: Response = flask_test_client.post(
        f'/teams/{team_1["id"]}/projects', json=project_data_1, headers=headers
    )
    print(response.get_json())
    assert response.status_code == 401
    assert db_models.Project.query.count() == 0
