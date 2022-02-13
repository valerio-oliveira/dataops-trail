import os

os.chdir('../')

os.system('echo "--- Destroying" >> logs.txt')
os.system('date >> logs.txt')

os.chdir('terraform/aws/')
os.system('terraform apply -auto-approve -destroy')
os.chdir('../../')

os.system('echo "--- End destroying" >> logs.txt')
os.system('date >> logs.txt')
