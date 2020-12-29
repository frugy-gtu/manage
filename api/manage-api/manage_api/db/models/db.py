from flask_sqlalchemy import SQLAlchemy
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import joinedload, selectinload, contains_eager, subqueryload


db = SQLAlchemy()

__all__ = [
    'db',
    'update_db',
    'joinedload',
    'selectinload',
    'subqueryload',
    'contains_eager',
]


def update_db(commit: bool = True) -> None:
    if commit:
        db.session.commit()
    else:
        db.session.flush()
