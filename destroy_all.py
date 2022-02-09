import os

os.chdir('terraform/aws/')
os.system('terraform apply -auto-approve -destroy')
os.chdir('../../')
