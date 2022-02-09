import os
os.system('cd ./ansible ; echo "------- FAILOVER START --------" ; date ; echo "-------------------------------" ; ansible-playbook -i inventories --forks 1 failover.yml; echo "-------------------------------" ; date ; echo "------- FAILOVER FINISH -------"')
