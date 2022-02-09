import os
import time

os.system('cd ./ansible ; echo "---------- STOP MAIN ----------" ; ansible-playbook -i inventories --forks 1 stop_main_db.yml; echo "-------------------------------"')
