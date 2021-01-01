```sh
poetry install
export FLASK_APP=manage_api
flask db init
flask tune-db post-init
flask db migrate
flask db upgrade
./gunicorn.sh
```