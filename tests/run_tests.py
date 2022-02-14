#!/usr/bin/python

import threading
import random
from utils.randoms import *
from utils.html import *

num_threads = 150
num_requests = 100


def get_hosts_value(var_name):
    with open("../ansible/inventories/hosts") as conf:
        for line in conf:
            if "site1_svc_public_ip" in line:
                name, value = line.split("=")
                return str(value).strip()


load_balancer_ip = get_hosts_value("site1_svc_public_ip")


def run_test(host, repeating):
    i = 1
    while i <= repeating:
        name = get_name()
        birthday = get_date().strftime("%Y-%m-%d")
        if random.choice([True, False]):
            get(host, name)
        else:
            post(host, name, birthday)
        i = i+1


def run_stress_test():
    try:
        for i in range(1, num_threads):
            threading.Thread(target=run_test, args=(
                load_balancer_ip, num_requests,)).start()
    except:
        print("Error: unable to start thread")
    # while 1:
    #     pass


run_stress_test()

exit()
