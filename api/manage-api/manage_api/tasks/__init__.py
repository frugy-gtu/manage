import time

from manage_api.tasks.celery_bridge import celery


@celery.task()
def ping(pong):
    time.sleep(2)
    return pong
