import os
import time

os.chdir('ansible/')
dir_name = './inventories/'
dir_exists = os.path.exists(dir_name)
if not dir_exists:
    os.makedirs(dir_name)
os.chdir('../')

os.system('echo "--- Creating everything" >> logs.txt')
os.system('date >> logs.txt')

os.system('echo "--- Provisioning infrastructure" >> logs.txt')

os.chdir('terraform/aws/')
os.system('terraform init')
os.system('terraform apply -auto-approve')
os.chdir('../../')

time.sleep(3)

os.system('echo "--- Deploying Web service" >> logs.txt')
os.system('date >> logs.txt')

os.chdir('ansible/')
os.system('ansible-playbook -i inventories --forks 1 deploy.yml')
os.chdir('../')

os.system('echo "--- End creating" >> logs.txt')
os.system('date >> logs.txt')
