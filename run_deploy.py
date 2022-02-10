import os
import time

os.chdir('ansible/')
dir_name = './inventories/'
dir_exists = os.path.exists(dir_name)
if not dir_exists:
    os.makedirs(dir_name)

os.chdir('terraform/aws/')
os.system('terraform init')
os.system('clear ; echo "------- TERRAFORM START -------" ; date ; echo "-------------------------------" ; terraform apply -auto-approve ; echo "-------------------------------" ; date ; echo "------ TERRAFORM FINISH -------"')
os.chdir('../../')
time.sleep(3)

os.chdir('ansible/')
os.system('echo "-------- ANSIBLE START --------" ; date ; echo "-------------------------------" ; ansible-playbook -i inventories --forks 1 deploy.yml; echo "-------------------------------" ; date ; echo "------- ANSIBLE FINISH --------"')
os.chdir('../')
