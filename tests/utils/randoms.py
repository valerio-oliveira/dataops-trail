import random
from datetime import date, timedelta
from dateutil.relativedelta import relativedelta

max_years = 50
min_years = 20

names = ['arthur', 'albert', 'bob', 'brian', 'carl', 'cinthya', 'dough', 'daniel', 'eduard', 'erick',
         'frank', 'fiona', 'gavin', 'george', 'henry', 'hector', 'iris', 'isabel', 'john', 'julian',
         'katie', 'kyle', 'leo', 'luna', 'mateo', 'mia', 'noah', 'nicole', 'olivia', 'oscar',
         'peter', 'phil', 'quinn', 'quentin', 'rosie', 'ryan', 'sophie', 'stella', 'taylor', 'theo',
         'ulysses', 'uriel', 'valerio', 'victoria', 'will', 'wade']


def get_date():
    start_date = date.today() - relativedelta(years=max_years)
    end_date = date.today() - relativedelta(years=min_years)
    delta = end_date - start_date
    random_number = random.randint(1, delta.days)
    new_date = start_date + timedelta(days=random_number)
    return new_date


def get_name():
    return random.choice(names)
