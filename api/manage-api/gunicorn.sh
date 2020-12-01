#!/usr/bin/env bash

gunicorn "manage_api:create_app()" -w5 --reload --access-logfile - --bind 0.0.0.0:8000