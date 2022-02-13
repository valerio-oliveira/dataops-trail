import os

os.chdir('../')

os.system('echo "--- Stop main database" >> logs.txt')
os.system('date >> logs.txt')

os.chdir('ansible/')
os.system('ansible-playbook -i inventories --forks 1 stop_main_db.yml')
os.chdir('../')
