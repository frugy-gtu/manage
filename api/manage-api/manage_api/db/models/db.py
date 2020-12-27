from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

__all__ = ['db', 'update_db']


def update_db(commit: bool = True) -> None:
    if commit:
        db.session.commit()
    else:
        db.session.flush()
