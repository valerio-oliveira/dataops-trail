import os
import time

os.system('cd ./terraform/aws/ ; clear ; echo "------- TERRAFORM START -------" ; date ; echo "-------------------------------" ; terraform apply -auto-approve ; echo "-------------------------------" ; date ; echo "------ TERRAFORM FINISH -------"')
time.sleep(3)
os.system('cd ./ansible ; echo "-------- ANSIBLE START --------" ; date ; echo "-------------------------------" ; ansible-playbook -i inventories --forks 1 deploy.yml; echo "-------------------------------" ; date ; echo "------- ANSIBLE FINISH --------"')
