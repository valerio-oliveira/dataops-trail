import random
from utils.randoms import *
from utils.html import *


def run_stress_test(host, repeating):
    i = 1
    while i <= repeating:
        name = get_name()
        birthday = get_date().strftime("%Y-%m-%d")
        if random.choice([True, False]):
            get(host, name)
        else:
            post(host, name, birthday)
        i = i+1


run_stress_test(host="54.161.73.197", repeating=300)

exit()
