import time
import run_deployment
import run_stop_main_db
import run_failover
import run_destroy

run_deployment
time.sleep(3)
run_stop_main_db
time.sleep(3)
run_failover
time.sleep(60*7)  # wait 7 min before destroy.
run_destroy
