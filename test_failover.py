import os
import time
import run_deploy
import run_failover

run_deploy
time.sleep(3)
os.system('cd ./ansible ; echo "------- FORCE FAILOVER --------" ; ansible-playbook -i inventories --forks 1 stop_main_db.yml; echo "-------------------------------"')
time.sleep(3)
run_failover
