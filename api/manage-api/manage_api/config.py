import os


class Config(object):
    # app
    APP_VERSION = '0.1.0'
    CONFIG_NAME = 'base'
    APP_DIR = os.path.dirname(os.path.realpath(__file__))
    BASE_DIR = os.path.dirname(APP_DIR)
    HOST = '0.0.0.0'
    PORT = 8000
    TESTING = False
    DEBUG = False

    # sqlalchemy
    SQLALCHEMY_ECHO = False
    SQLALCHEMY_TRACK_MODIFICATIONS = True

    # jwt
    SECRET_KEY = 'rMxFGtrOkF1@m5fEU#5x2A32Ygwu8P6x5ATr^PwA'
    JWT_ACCESS_TOKEN_EXPIRES = False

    # celery
    CELERY_TASK_DEFAULT_QUEUE = 'manage_api'

    # Cors
    CORS_HEADERS = 'Content-Type'

    # cache
    CACHE_REDIS_URL = 'redis://localhost:6379/1'

    # confidential
    SQLALCHEMY_DATABASE_URI = ''


class ProductionConfig(Config):
    CONFIG_NAME = 'production'
    DEBUG = False


class TestingConfig(Config):
    CONFIG_NAME = 'testing'
    DEBUG = True

    BASE_URL = 'https://manage.frugy.com'


class DevelopmentConfig(Config):
    CONFIG_NAME = 'development'
    DEBUG = True

    BASE_URL = 'http://manage.loc:' + str(Config.PORT)


config = {
    'development': DevelopmentConfig,
    'testing': TestingConfig,
    'production': ProductionConfig,
    'default': DevelopmentConfig,
}
