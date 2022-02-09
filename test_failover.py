import os
import time
import run_deploy
import run_failover
import destroy_all

run_deploy
time.sleep(3)
os.system('cd ./ansible ; echo "------- FORCE FAILOVER --------" ; ansible-playbook -i inventories --forks 1 stop_main_db.yml; echo "-------------------------------"')
time.sleep(3)
run_failover
time.sleep(420)  # wait 7 min
destroy_all
