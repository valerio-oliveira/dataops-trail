import psycopg2

from decouple import config


def connect(section):

    conn = None
    try:
        conn = psycopg2.connect(
            host=config('dbhost'),
            port=config('dbport'),
            database=config('dbname'),
            user=config('dbuser'),
            password=config('dbpass'),
            application_name=config('dbappname'),
        )
        return conn
    except (Exception, psycopg2.DatabaseError) as error:
        raise(error)
