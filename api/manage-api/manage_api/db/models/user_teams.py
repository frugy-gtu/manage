from .base import Base
from .db import db, UUID


class UserTeams(Base):
    team_id = db.Column(UUID(as_uuid=True), db.ForeignKey('team.id'), nullable=False)
    user_id = db.Column(UUID(as_uuid=True), db.ForeignKey('user.id'), nullable=False)
