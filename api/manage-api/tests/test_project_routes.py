from flask import Response
from flask.testing import FlaskClient
from manage_api.db import models as db_models
from manage_api.db import services as db_services


def test_project_put(flask_test_client):
    response: Response = flask_test_client.put('/projects/')
    assert response.status_code == 405


def test_projects_delete(flask_test_client):
    response: Response = flask_test_client.delete('/projects/')
    assert response.status_code == 405


def test_projects_post(flask_test_client):

    response: Response = flask_test_client.post('/projects/')
    assert response.status_code == 405


def test_projects_get_without_jwt(flask_test_client):
    response: Response = flask_test_client.get('/projects/')
    assert response.status_code == 401


def test_projects_get_with_jwt(flask_test_client):
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
    team_1 = db_services.TeamService.create(team_1_data).dump()
    project_data_1 = {'name': 'test_project_1', 'team_id': team_1['id']}
    project_data_2 = {'name': 'test_project_1', 'team_id': team_1['id']}
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    project_2 = db_services.ProjectService.create(project_data_2).dump()
    response: Response = flask_test_client.get('/projects/', headers=headers)
    data = response.get_json()
    assert response.status_code == 200
    assert len(data) == 2
    project1 = data[1]
    project2 = data[0]
    assert project1['id'] == project_1['id']
    assert project1['name'] == project_1['name']
    assert project2['id'] == project_2['id']
    assert project2['name'] == project_2['name']


def test_projects_get_with_jwt_multiple_teams(flask_test_client):
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
    project_data_1 = {'name': 'test_project_1', 'team_id': team_1['id']}
    project_data_2 = {'name': 'test_project_2', 'team_id': team_2['id']}
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    project_2 = db_services.ProjectService.create(project_data_2).dump()
    response: Response = flask_test_client.get(f'/projects/', headers=headers)
    data = response.get_json()
    assert response.status_code == 200
    assert len(data) == 2
    project1 = data[1]
    project2 = data[0]
    assert project1['id'] == project_1['id']
    assert project1['name'] == project_1['name']
    assert project2['id'] == project_2['id']
    assert project2['name'] == project_2['name']


def test_projects_get_with_jwt_not_associated_user(flask_test_client):
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
    team_1_data = {
        'name': 'test_team_1',
        'abbreviation': 'tt1',
        'user_id': user['id'],
    }
    team_2_data = {
        'name': 'test_team_2',
        'abbreviation': 'tt2',
        'user_id': user2['id'],
    }
    team_1 = db_services.TeamService.create(team_1_data).dump()
    team_2 = db_services.TeamService.create(team_2_data).dump()
    project_data_1 = {'name': 'test_project_1', 'team_id': team_1['id']}
    project_data_2 = {'name': 'test_project_2', 'team_id': team_2['id']}
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    _ = db_services.ProjectService.create(project_data_2).dump()
    response: Response = flask_test_client.get(f'/projects/', headers=headers)
    data = response.get_json()
    assert response.status_code == 200
    assert len(data) == 1
    project = data[0]
    assert project['id'] == project_1['id']
    assert project['name'] == project_1['name']


def test_projects_get_without_jwt(flask_test_client):
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
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    response: Response = flask_test_client.get(f'/projects/{project_1["id"]}')
    assert response.status_code == 401


def test_projects_get_with_jwt(flask_test_client):
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
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    response: Response = flask_test_client.get(
        f'/projects/{project_1["id"]}', headers=headers
    )
    data = response.get_json()
    assert response.status_code == 200
    assert data['id'] == project_1['id']
    assert data['name'] == project_data_1['name']


def test_projects_get_with_jwt_not_associated_user(flask_test_client):
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
    project_data_1 = {'name': 'test_project_1', 'team_id': team_1['id']}
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    response: Response = flask_test_client.get(
        f'/projects/{project_1["id"]}', headers=headers
    )
    assert response.status_code == 401


def test_project_put_without_jwt(flask_test_client):
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
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    project_update_data = {
        'name': 'test_project_new_name',
    }
    response: Response = flask_test_client.put(
        f'/projects/{project_1["id"]}',
        json=project_update_data,
    )
    assert response.status_code == 401


def test_project_put_with_jwt(flask_test_client):
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
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    project_update_data = {
        'name': 'test_project_new_name',
    }
    response: Response = flask_test_client.put(
        f'/projects/{project_1["id"]}', json=project_update_data, headers=headers
    )
    data = response.get_json()
    assert response.status_code == 200
    assert data['id'] == project_1['id']
    assert data['name'] == project_update_data['name']
    project = db_models.Project.query.get(data['id'])
    assert project is not None
    assert project.name == project_update_data['name']


def test_project_put_with_jwt_not_manager(flask_test_client):
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
    project_data_1 = {'name': 'test_project_1', 'team_id': team_1['id']}
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    project_update_data = {
        'name': 'test_project_new_name',
    }
    response: Response = flask_test_client.put(
        f'/projects/{project_1["id"]}', json=project_update_data, headers=headers
    )
    _ = response.get_json()
    assert response.status_code == 401
    project = db_models.Project.query.get(project_1['id'])
    assert project is not None
    assert project.name != project_update_data['name']
    assert project.name == project_data_1['name']


def test_project_delete_without_jwt(flask_test_client):
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
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    response: Response = flask_test_client.delete(
        f'/projects/{project_1["id"]}',
    )
    assert response.status_code == 401


def test_project_delete_with_jwt(flask_test_client):
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
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    response: Response = flask_test_client.delete(
        f'/projects/{project_1["id"]}', headers=headers
    )
    data = response.get_json()
    assert response.status_code == 200
    assert data['id'] == project_1['id']
    assert data['name'] == project_1['name']
    assert db_models.Project.query.count() == 0
    project = db_models.Project.query.get(project_1['id'])
    assert project is None


def test_project_delete_with_jwt_contains_task_group(flask_test_client):
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
    project_1 = db_services.ProjectService.create(project_data_1)
    task_group_data_1 = {'name': 'test_task_group_1', 'project_id': project_1['id']}
    _ = db_services.TaskGroupService.create(task_group_data_1)
    response: Response = flask_test_client.delete(
        f'/projects/{project_1["id"]}', headers=headers
    )
    assert response.status_code == 412
    assert db_models.Project.query.count() == 1


def test_project_delete_with_jwt_not_manager(flask_test_client):
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
    project_data_1 = {'name': 'test_project_1', 'team_id': team_1['id']}
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    response: Response = flask_test_client.delete(
        f'/projects/{project_1["id"]}', headers=headers
    )
    assert response.status_code == 401
    assert db_models.Project.query.count() == 1
    team = db_models.Project.query.get(project_1['id'])
    assert team is not None


def test_project_task_groups_put(flask_test_client):
    user_data = {
        'username': 'test_user',
        'email': 'test@user.com',
        'password': '123123asd',
    }
    user = db_services.UserService.create(user_data).dump()
    team_data_1 = {
        'name': 'test_team_1',
        'abbreviation': 'tt1',
        'user_id': user['id'],
    }
    team_1 = db_services.TeamService.create(team_data_1)
    project_data_1 = {'name': 'test_project_1', 'team_id': team_1['id']}
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    response: Response = flask_test_client.put(
        f'/projects/{project_1["id"]}/task-groups'
    )
    assert response.status_code == 405


def test_project_task_groups_delete(flask_test_client):
    user_data = {
        'username': 'test_user',
        'email': 'test@user.com',
        'password': '123123asd',
    }
    user = db_services.UserService.create(user_data).dump()
    team_data_1 = {
        'name': 'test_team_1',
        'abbreviation': 'tt1',
        'user_id': user['id'],
    }
    team_1 = db_services.TeamService.create(team_data_1)
    project_data_1 = {'name': 'test_project_1', 'team_id': team_1['id']}
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    response: Response = flask_test_client.delete(
        f'/projects/{project_1["id"]}/task-groups'
    )
    assert response.status_code == 405


def test_project_task_groups_get_without_jwt(flask_test_client):
    user_data = {
        'username': 'test_user',
        'email': 'test@user.com',
        'password': '123123asd',
    }
    user = db_services.UserService.create(user_data).dump()
    team_data_1 = {
        'name': 'test_team_1',
        'abbreviation': 'tt1',
        'user_id': user['id'],
    }
    team_1 = db_services.TeamService.create(team_data_1)
    project_data_1 = {'name': 'test_project_1', 'team_id': team_1['id']}
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    task_group_data_1 = {'name': 'test_task_group_1', 'project_id': project_1['id']}
    _ = db_services.TaskGroupService.create(task_group_data_1)
    task_group_data_2 = {'name': 'test_task_group_2', 'project_id': project_1['id']}
    _ = db_services.TaskGroupService.create(task_group_data_2)
    response: Response = flask_test_client.get(
        f'/projects/{project_1["id"]}/task-groups'
    )
    assert response.status_code == 401


def test_project_task_groups_get_with_jwt(flask_test_client):
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
    team_1 = db_services.TeamService.create(team_data_1)
    project_data_1 = {'name': 'test_project_1', 'team_id': team_1['id']}
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    task_group_data_1 = {'name': 'test_task_group_1', 'project_id': project_1['id']}
    task_group_1 = db_services.TaskGroupService.create(task_group_data_1)
    task_group_data_2 = {'name': 'test_task_group_2', 'project_id': project_1['id']}
    task_group_2 = db_services.TaskGroupService.create(task_group_data_2)
    response: Response = flask_test_client.get(
        f'/projects/{project_1["id"]}/task-groups', headers=headers
    )
    data = response.get_json()
    assert response.status_code == 200
    assert len(data) == 2
    r_task_group_1 = data[1]
    r_task_group_2 = data[0]
    assert r_task_group_1['id'] == str(task_group_1['id'])
    assert r_task_group_1['name'] == task_group_1['name']
    assert r_task_group_2['id'] == str(task_group_2['id'])
    assert r_task_group_2['name'] == task_group_2['name']


def test_project_task_groups_get_with_jwt_not_associated_user(flask_test_client):
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
    team_1 = db_services.TeamService.create(team_data_1)
    project_data_1 = {'name': 'test_project_1', 'team_id': team_1['id']}
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    task_group_data_1 = {'name': 'test_task_group_1', 'project_id': project_1['id']}
    _ = db_services.TaskGroupService.create(task_group_data_1)
    task_group_data_2 = {'name': 'test_task_group_2', 'project_id': project_1['id']}
    _ = db_services.TaskGroupService.create(task_group_data_2)
    response: Response = flask_test_client.get(
        f'/projects/{project_1["id"]}/task-groups', headers=headers
    )
    assert response.status_code == 401


def test_project_task_groups_post_without_jwt(flask_test_client):
    user_data = {
        'username': 'test_user',
        'email': 'test@user.com',
        'password': '123123asd',
    }
    user = db_services.UserService.create(user_data).dump()
    team_data_1 = {
        'name': 'test_team_1',
        'abbreviation': 'tt1',
        'user_id': user['id'],
    }
    team_1 = db_services.TeamService.create(team_data_1)
    project_data_1 = {'name': 'test_project_1', 'team_id': team_1['id']}
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    task_group_data_1 = {'name': 'test_task_group_1'}
    response: Response = flask_test_client.post(
        f'/projects/{project_1["id"]}/task-groups', json=task_group_data_1
    )
    assert response.status_code == 401
    assert db_models.TaskGroup.query.count() == 0


def test_project_task_groups_post_with_jwt(flask_test_client):
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
    team_1 = db_services.TeamService.create(team_data_1)
    project_data_1 = {'name': 'test_project_1', 'team_id': team_1['id']}
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    task_group_data_1 = {'name': 'test_task_group_1'}
    response: Response = flask_test_client.post(
        f'/projects/{project_1["id"]}/task-groups',
        json=task_group_data_1,
        headers=headers,
    )
    data = response.get_json()
    assert response.status_code == 201
    assert db_models.TaskGroup.query.count() == 1
    task_group = db_models.TaskGroup.query.first()
    assert task_group.name == task_group_data_1['name']
    assert str(task_group.project_id) == project_1['id']


def test_project_task_groups_post_with_jwt_not_manager(flask_test_client):
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
    team_1 = db_services.TeamService.create(team_data_1)
    project_data_1 = {'name': 'test_project_1', 'team_id': team_1['id']}
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    task_group_data_1 = {'name': 'test_task_group_1'}
    response: Response = flask_test_client.post(
        f'/projects/{project_1["id"]}/task-groups',
        json=task_group_data_1,
        headers=headers,
    )
    assert response.status_code == 401
    assert db_models.TaskGroup.query.count() == 0


def test_project_task_group_get(flask_test_client):
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
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    task_group_data_1 = {'name': 'test_task_group_1', 'project_id': project_1['id']}
    task_group_1 = db_services.TaskGroupService.create(task_group_data_1)
    task_group_update_data = {
        'name': 'test_task_group_new_name',
    }
    response: Response = flask_test_client.get(
        f'/projects/{project_1["id"]}/task-groups/{task_group_1["id"]}'
    )
    assert response.status_code == 405


def test_project_task_group_post(flask_test_client):
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
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    task_group_data_1 = {'name': 'test_task_group_1', 'project_id': project_1['id']}
    task_group_1 = db_services.TaskGroupService.create(task_group_data_1)
    response: Response = flask_test_client.post(
        f'/projects/{project_1["id"]}/task-groups/{task_group_1["id"]}'
    )
    assert response.status_code == 405


def test_project_task_group_put_without_jwt(flask_test_client):
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
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    task_group_data_1 = {'name': 'test_task_group_1', 'project_id': project_1['id']}
    task_group_1 = db_services.TaskGroupService.create(task_group_data_1)
    task_group_update_data = {
        'name': 'test_task_group_new_name',
    }
    response: Response = flask_test_client.put(
        f'/projects/{project_1["id"]}/task-groups/{task_group_1["id"]}',
        json=task_group_update_data,
    )
    assert response.status_code == 401


def test_project_task_group_put_with_jwt(flask_test_client):
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
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    task_group_data_1 = {'name': 'test_task_group_1', 'project_id': project_1['id']}
    task_group_1 = db_services.TaskGroupService.create(task_group_data_1)
    task_group_update_data = {
        'name': 'test_task_group_new_name',
    }
    response: Response = flask_test_client.put(
        f'/projects/{project_1["id"]}/task-groups/{task_group_1["id"]}',
        json=task_group_update_data,
        headers=headers,
    )
    data = response.get_json()
    assert response.status_code == 200
    assert data['id'] == str(task_group_1['id'])
    assert data['name'] == task_group_update_data['name']
    task_group = db_models.TaskGroup.query.get(data['id'])
    assert task_group is not None
    assert task_group.name == task_group_update_data['name']


def test_project_task_group_put_with_jwt_not_manager(flask_test_client):
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
    project_data_1 = {'name': 'test_project_1', 'team_id': team_1['id']}
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    task_group_data_1 = {'name': 'test_task_group_1', 'project_id': project_1['id']}
    task_group_1 = db_services.TaskGroupService.create(task_group_data_1)
    task_group_update_data = {
        'name': 'test_task_group_new_name',
    }
    response: Response = flask_test_client.put(
        f'/projects/{project_1["id"]}/task-groups/{task_group_1["id"]}',
        json=task_group_update_data,
        headers=headers,
    )
    _ = response.get_json()
    assert response.status_code == 401
    task_group = db_models.TaskGroup.query.get(task_group_1['id'])
    assert task_group is not None
    assert task_group.name != task_group_update_data['name']
    assert task_group.name == task_group_data_1['name']


def test_project_task_group_delete_without_jwt(flask_test_client):
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
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    task_group_data_1 = {'name': 'test_task_group_1', 'project_id': project_1['id']}
    task_group_1 = db_services.TaskGroupService.create(task_group_data_1).dump()
    response: Response = flask_test_client.delete(
        f'/projects/{project_1["id"]}/task-groups/{task_group_1["id"]}',
    )
    assert response.status_code == 401


def test_project_task_group_delete_with_jwt(flask_test_client):
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
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    task_group_data_1 = {'name': 'test_task_group_1', 'project_id': project_1['id']}
    task_group_1 = db_services.TaskGroupService.create(task_group_data_1).dump()
    url = f'/projects/{project_1["id"]}/task-groups/{task_group_1["id"]}'
    response: Response = flask_test_client.delete(
        f'/projects/{project_1["id"]}/task-groups/{task_group_1["id"]}', headers=headers
    )
    data = response.get_json()
    assert response.status_code == 200
    assert data['id'] == task_group_1['id']
    assert data['name'] == task_group_1['name']
    assert db_models.TaskGroup.query.count() == 0
    task_group = db_models.TaskGroup.query.get(task_group_1['id'])
    assert task_group is None


def test_project_task_group_delete_with_jwt_contains_task(flask_test_client):
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
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    task_group_data_1 = {'name': 'test_task_group_1', 'project_id': project_1['id']}
    task_group_1 = db_services.TaskGroupService.create(task_group_data_1).dump()
    task_data = {
        'name': 'test_task',
        'task_group_id': task_group_1['id'],
        'deadline': '2020-12-28T11:59:22.490Z',
        'user_id': user['id'],
    }
    _ = db_services.TaskService.create(task_data).dump()
    response: Response = flask_test_client.delete(
        f'/projects/{project_1["id"]}/task-groups/{task_group_1["id"]}', headers=headers
    )
    data = response.get_json()
    assert response.status_code == 200
    assert data['id'] == task_group_1['id']
    assert data['name'] == task_group_1['name']
    assert db_models.TaskGroup.query.count() == 0
    assert db_models.Task.query.count() == 0
    task_group = db_models.TaskGroup.query.get(task_group_1['id'])
    assert task_group is None


def test_project_task_group_delete_with_jwt_not_manager(flask_test_client):
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
    project_data_1 = {'name': 'test_project_1', 'team_id': team_1['id']}
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    task_group_data_1 = {'name': 'test_task_group_1', 'project_id': project_1['id']}
    task_group_1 = db_services.TaskGroupService.create(task_group_data_1).dump()
    response: Response = flask_test_client.delete(
        f'/projects/{project_1["id"]}/task-groups/{task_group_1["id"]}', headers=headers
    )
    assert response.status_code == 401
    assert db_models.TaskGroup.query.count() == 1
    task_group = db_models.TaskGroup.query.get(task_group_1['id'])
    assert task_group is not None


def test_project_states_get_without_jwt(flask_test_client):
    user_data = {
        'username': 'test_user',
        'email': 'test@user.com',
        'password': '123123asd',
    }
    user = db_services.UserService.create(user_data)
    team_data = {
        'name': 'test_team_1',
        'abbreviation': 'tt1',
        'user_id': user['id'],
    }
    team = db_services.TeamService.create(team_data)
    team.update_states(['state1', 'state2', 'state3'])
    project_data = {'name': 'test_project_1', 'team_id': team['id']}
    project = db_services.ProjectService.create(project_data)
    response: Response = flask_test_client.get(
        f'/projects/{project["id"]}/states',
    )
    assert response.status_code == 401


def test_project_states_get_with_jwt(flask_test_client):
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
        'user_id': user['id'],
    }
    team = db_services.TeamService.create(team_data)
    state_data = ['state1', 'state2', 'state3']
    team.update_states(state_data)
    project_data = {'name': 'test_project_1', 'team_id': team['id']}
    project = db_services.ProjectService.create(project_data)
    response: Response = flask_test_client.get(
        f'/projects/{project["id"]}/states', headers=headers
    )
    data = response.get_json()
    assert response.status_code == 200
    assert len(data) == 3
    states = db_models.State.query.order_by(db_models.State.rank).all()
    assert len(states) == 3
    for i in range(3):
        assert states[i].name == state_data[i]
        assert states[i].project_id == project['id']
