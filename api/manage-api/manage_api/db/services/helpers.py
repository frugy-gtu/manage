from __future__ import annotations
from collections import OrderedDict as ODict
from typing import List, Dict, Any, TypeVar, Type
from sqlalchemy import and_
from manage_api.db.models.base import Base
from manage_api.db.models.db import selectinload
from manage_api.misc.types import filter_type


T = TypeVar('T', bound=Type[Base])


def query_builder(
    dbmodel: T,
    *,
    joined_relations: List[str] = None,
    filters: Dict[filter_type, Dict[str, Any]] = None,
    order_by: ODict[str, bool] = None,
):
    query = dbmodel.query
    if joined_relations:
        options = []
        for relation in joined_relations:
            if hasattr(dbmodel, relation):
                if relation in dbmodel.load_strategies:
                    options.append(
                        dbmodel.load_strategies[relation](getattr(dbmodel, relation))
                    )
                else:
                    options.append(selectinload(getattr(dbmodel, relation)))
        query = query.options(*options)
    if filters:
        equals = filters.get('==', {})
        not_equals = filters.get('!=', {})
        lts = filters.get('<', {})
        gts = filters.get('>', {})
        ltes = filters.get('<=', {})
        gtes = filters.get('>=', {})
        ins = filters.get('in', {})
        ilikes = filters.get('ilike', {})
        inner_filters = []
        for k, v in equals.items():
            if hasattr(dbmodel, k):
                inner_filters.append(getattr(dbmodel, k) == v)
        query = query.filter(and_(*inner_filters))
        inner_filters = []
        for k, v in not_equals.items():
            if hasattr(dbmodel, k):
                inner_filters.append(getattr(dbmodel, k) != v)
        query = query.filter(and_(*inner_filters))
        inner_filters = []
        for k, v in lts.items():
            if hasattr(dbmodel, k):
                inner_filters.append(getattr(dbmodel, k) < v)
        query = query.filter(and_(*inner_filters))
        inner_filters = []
        for k, v in ltes.items():
            if hasattr(dbmodel, k):
                inner_filters.append(getattr(dbmodel, k) <= v)
        query = query.filter(and_(*inner_filters))
        inner_filters = []
        for k, v in gts.items():
            if hasattr(dbmodel, k):
                inner_filters.append(getattr(dbmodel, k) > v)
        query = query.filter(and_(*inner_filters))
        inner_filters = []
        for k, v in gtes.items():
            if hasattr(dbmodel, k):
                inner_filters.append(getattr(dbmodel, k) >= v)
        query = query.filter(and_(*inner_filters))
        inner_filters = []
        for k, v in ins.items():
            if hasattr(dbmodel, k):
                inner_filters.append(getattr(dbmodel, k).in_(v))
        query = query.filter(and_(*inner_filters))
        inner_filters = []
        for k, v in ilikes.items():
            if hasattr(dbmodel, k):
                inner_filters.append(getattr(dbmodel, k).ilike(v))
        query = query.filter(and_(*inner_filters))
    if order_by:
        for k, descending in order_by.items():
            if hasattr(dbmodel, k):
                if descending:
                    query = query.order_by(getattr(dbmodel, k).desc())
                else:
                    query = query.order_by(getattr(dbmodel, k).asc())
    query = query.order_by(dbmodel.created_at.desc())
    return query
