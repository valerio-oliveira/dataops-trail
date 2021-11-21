import datetime
from psycopg2 import sql

from .conpg import connect

section = 'hello_db'


def get_birthday(username: str):
    try:
        conn = connect(section)
        cur = conn.cursor()

        _username = username.lower()

        query_base = """select birthday from base.users where username=%s;"""

        cur.execute(query_base, [_username])
        result = cur.fetchone()

        if not result is None:
            result = result[0]

        print("result", result, type(result))
        return result
    finally:
        if cur is not None:
            cur.close()
        if conn is not None:
            conn.close()


def set_birthday(username: str, birthday: datetime.date):
    try:
        conn = connect(section)
        cur = conn.cursor()

        result = False
        _username = username.lower()
        _birthday = birthday.strftime("%Y-%m-%d")

        table_col_names = ['username', 'birthday']
        values = [_username, _birthday]

        col_names = sql.SQL(', ').join(sql.Identifier(n)
                                       for n in table_col_names)
        place_holders = sql.SQL(', ').join(
            sql.Placeholder() * len(table_col_names))

        query_base = sql.SQL("insert into {table_schema}.{table_name} ({col_names}) \n" +
                             "values ({values}) \n" +
                             "on conflict (username) do \n" +
                             "  update set birthday=EXCLUDED.birthday"
                             ).format(
            table_schema=sql.Identifier("base"),
            table_name=sql.Identifier("users"),
            col_names=col_names,
            values=place_holders
        )

        cur.execute(query_base, values)

        result = "OK"
        conn.commit()

        return result
    except conn.DatabaseError as e:
        return e
    finally:
        if cur is not None:
            cur.close()
        if conn is not None:
            conn.close()
