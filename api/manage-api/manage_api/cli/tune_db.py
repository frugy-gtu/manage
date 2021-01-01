import sys

from flask import current_app
from flask.cli import AppGroup
from sqlalchemy import text

from manage_api.db import models as m

cli = AppGroup('tune-db')


@cli.command('post-init')
def tune_database():
    try:
        sql = text('CREATE EXTENSION pgcrypto;')
        m.db.engine.execute(sql)
    except Exception:
        exc = sys.exc_info()
        print(exc)

    file_path = current_app.config.get('BASE_DIR') + '/migrations/script.py.mako'
    content = open(file_path).read()

    if (
        'import sqlalchemy_utils' not in content
        and 'import sqlalchemy as sa' in content
    ):
        content = content.replace(
            'import sqlalchemy as sa',
            'import sqlalchemy as sa\nimport sqlalchemy_utils',
        )

    f = open(file_path, 'w')
    f.write(content)
    f.close()
