import os
os.chdir('ansible/')
os.system('echo "---------- STOP MAIN ----------" ; ansible-playbook -i inventories --forks 1 stop_main_db.yml; echo "-------------------------------"')
os.chdir('../')
