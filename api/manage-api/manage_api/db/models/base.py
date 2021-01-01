from datetime import datetime
from marshmallow import Schema, fields
from .db import db, UUID


class DateTimeV2(fields.DateTime):
    def _deserialize(self, value, attr, data, **kwargs):
        if isinstance(value, datetime):
            return value
        return super()._deserialize(value, attr, data, **kwargs)


class Base(db.Model):
    __abstract__ = True
    id = db.Column(
        UUID(as_uuid=True),
        primary_key=True,
        server_default=db.text('gen_random_uuid()'),
    )
    created_at = db.Column(
        db.DateTime(timezone=True), index=False, default=db.func.now()
    )
    updated_at = db.Column(
        db.DateTime(timezone=True),
        index=False,
        default=db.func.now(),
        onupdate=db.func.now(),
    )
    is_deleted = db.Column(
        db.Boolean,
        nullable=False,
        index=True,
        default=False,
        server_default=db.text('false'),
    )


class BaseSchema(Schema):
    id = fields.UUID(required=True, allow_none=False, dump_only=True)
    created_at = DateTimeV2(required=True, allow_none=False, dump_only=True)
    updated_at = DateTimeV2(required=True, allow_none=False, dump_only=True)
    is_deleted = fields.Bool(required=True, allow_none=False, dump_only=True)

    class Meta:
        exclude = ('updated_at', 'is_deleted')
