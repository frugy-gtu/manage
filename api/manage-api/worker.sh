#!/usr/bin/env bash

celery -A manage_api.tasks.celery worker -E --loglevel=INFO --concurrency=1 -n manage-api@%%h -Q manage_api