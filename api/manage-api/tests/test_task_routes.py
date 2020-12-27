from flask import Response
from flask.testing import FlaskClient
from manage_api.db import models as db_models
from manage_api.db import services as db_services


def create_user():
    user_data = {
        'username': 'test_user',
        'email': 'test@user.com',
        'password': '123123asd',
    }
    user = db_services.UserService.create(user_data)
    return user


def create_user_and_project(user=None):
    if user is None:
        user = create_user()
    team_1_data = {
        'name': 'test_team_1',
        'abbreviation': 'tt1',
        'user_id': user['id'],
    }
    team_1 = db_services.TeamService.create(team_1_data).dump()
    project_data_1 = {'name': 'test_project_1', 'team_id': team_1['id']}
    project_1 = db_services.ProjectService.create(project_data_1).dump()
    return user, project_1


def test_tasks_put(flask_test_client):
    response: Response = flask_test_client.put('/tasks/')
    assert response.status_code == 405


def test_tasks_delete(flask_test_client):
    response: Response = flask_test_client.delete('/tasks/')
    assert response.status_code == 405


def test_tasks_get_without_jwt(flask_test_client):
    response: Response = flask_test_client.get('/tasks/')
    assert response.status_code == 401


def test_tasks_get_with_jwt(flask_test_client):
    user, project = create_user_and_project()
    access_token = user.create_access_token()
    headers = {'Authorization': f'Bearer {access_token}'}
    task_group_data_1 = {'name': 'test_task_group_1', 'project_id': project['id']}
    task_group_1 = db_services.TaskGroupService.create(task_group_data_1)
    task_1_data = {
        'name': 'test_task',
        'task_group_id': task_group_1['id'],
        'deadline': '2020-12-28T11:59:22.490Z',
        'user_id': user['id'],
    }
    task_1 = db_services.TaskService.create(task_1_data)
    task_2_data = {
        'name': 'test_task2',
        'task_group_id': task_group_1['id'],
        'deadline': '2020-12-28T11:58:22.490Z',
        'user_id': user['id'],
    }
    task_2 = db_services.TaskService.create(task_2_data)
    response: Response = flask_test_client.get('/tasks/', headers=headers)
    data = response.get_json()
    assert response.status_code == 200
    assert len(data) == 2
    r_task_1 = data[1]
    r_task_2 = data[0]
    assert r_task_1['id'] == str(task_1['id'])
    assert r_task_2['id'] == str(task_2['id'])
    assert r_task_1['name'] == str(task_1['name'])
    assert r_task_2['name'] == str(task_2['name'])


def test_tasks_get_with_jwt_filter_task_group(flask_test_client):
    user, project = create_user_and_project()
    access_token = user.create_access_token()
    headers = {'Authorization': f'Bearer {access_token}'}
    task_group_data_1 = {'name': 'test_task_group_1', 'project_id': project['id']}
    task_group_data_2 = {'name': 'test_task_group_2', 'project_id': project['id']}
    task_group_1 = db_services.TaskGroupService.create(task_group_data_1)
    task_group_2 = db_services.TaskGroupService.create(task_group_data_2)
    task_1_data = {
        'name': 'test_task',
        'task_group_id': task_group_1['id'],
        'deadline': '2020-12-28T11:59:22.490Z',
        'user_id': user['id'],
    }
    task_1 = db_services.TaskService.create(task_1_data)
    task_2_data = {
        'name': 'test_task2',
        'task_group_id': task_group_2['id'],
        'deadline': '2020-12-28T11:58:22.490Z',
        'user_id': user['id'],
    }
    _ = db_services.TaskService.create(task_2_data)
    params = {'task_group_id': task_group_1['id']}
    response: Response = flask_test_client.get(
        '/tasks/', headers=headers, query_string=params
    )
    data = response.get_json()
    assert response.status_code == 200
    assert len(data) == 1
    r_task = data[0]
    assert r_task['id'] == str(task_1['id'])
    assert r_task['name'] == str(task_1['name'])


def test_tasks_get_with_jwt_filter_project(flask_test_client):
    user, project = create_user_and_project()
    _, project2 = create_user_and_project(user)
    access_token = user.create_access_token()
    headers = {'Authorization': f'Bearer {access_token}'}
    task_group_data_1 = {'name': 'test_task_group_1', 'project_id': project['id']}
    task_group_data_2 = {'name': 'test_task_group_2', 'project_id': project2['id']}
    task_group_1 = db_services.TaskGroupService.create(task_group_data_1)
    task_group_2 = db_services.TaskGroupService.create(task_group_data_2)
    task_1_data = {
        'name': 'test_task',
        'task_group_id': task_group_1['id'],
        'deadline': '2020-12-28T11:59:22.490Z',
        'user_id': user['id'],
    }
    task_1 = db_services.TaskService.create(task_1_data)
    task_2_data = {
        'name': 'test_task2',
        'task_group_id': task_group_2['id'],
        'deadline': '2020-12-28T11:58:22.490Z',
        'user_id': user['id'],
    }
    _ = db_services.TaskService.create(task_2_data)
    params = {'project_id': project['id']}
    response: Response = flask_test_client.get(
        '/tasks/', headers=headers, query_string=params
    )
    data = response.get_json()
    assert response.status_code == 200
    assert len(data) == 1
    r_task = data[0]
    assert r_task['id'] == str(task_1['id'])
    assert r_task['name'] == str(task_1['name'])
