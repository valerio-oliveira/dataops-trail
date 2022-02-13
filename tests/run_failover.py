import os

os.chdir('../')

os.system('echo "--- Start failover" >> logs.txt')
os.system('date >> logs.txt')

os.chdir('ansible/')
os.system('ansible-playbook -i inventories --forks 1 failover.yml')
os.chdir('../')

os.system('echo "--- End failover" >> logs.txt')
os.system('date >> logs.txt')
