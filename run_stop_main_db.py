import os

os.system('echo "--- STOP MAIN DATABASE" >> logs.txt')
os.system('date >> logs.txt')
os.system('echo "---" >> logs.txt')

os.chdir('ansible/')
os.system('ansible-playbook -i inventories --forks 1 stop_main_db.yml')
os.chdir('../')
