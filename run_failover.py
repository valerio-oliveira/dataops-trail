import os

os.system('echo "--- START FAILOVER" >> logs.txt')
os.system('date >> logs.txt')
os.system('echo "---" >> logs.txt')

os.chdir('ansible/')
os.system('ansible-playbook -i inventories --forks 1 failover.yml')
os.chdir('../')

os.system('echo "---" >> logs.txt')
os.system('date >> logs.txt')
os.system('echo "--- END FAILOVER" >> logs.txt')
