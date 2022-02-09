import os
import time

os.chdir('terraform/aws/')
os.system('clear ; echo "------- TERRAFORM START -------" ; date ; echo "-------------------------------" ; terraform apply -auto-approve ; echo "-------------------------------" ; date ; echo "------ TERRAFORM FINISH -------"')
os.chdir('../../')
time.sleep(3)
os.system('echo "-------- ANSIBLE START --------" ; date ; echo "-------------------------------" ; ansible-playbook -i inventories --forks 1 deploy.yml; echo "-------------------------------" ; date ; echo "------- ANSIBLE FINISH --------"')
