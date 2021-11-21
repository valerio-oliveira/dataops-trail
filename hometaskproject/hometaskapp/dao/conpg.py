import psycopg2

from decouple import config


def connect(section):

    conn = None
    try:
        conn = psycopg2.connect(
            host=config('host'),
            port=config('port'),
            database=config('database'),
            user=config('user'),
            password=config('password'),
            application_name=config('application_name'),
        )
        return conn
    except (Exception, psycopg2.DatabaseError) as error:
        raise(error)
