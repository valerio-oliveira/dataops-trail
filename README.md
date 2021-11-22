<div>
  <h2 align="center">Home Task</h2>

  <h3 align="center">Author: Valério Oliveira</h2>

  <div align="center">  
    <a href="https://www.linkedin.com/in/valerio-oliveira/?locale=en_US">Visit my LinkedIn</a> · <a href="mailto:valerio.net@gmail.com">E-mail me</a>
  </div>
  <p align="center">
    <img src="r.gif" alt="Logo" width=240 height=172>
  </p>
</div>

## Presentation

This project is a landmark on my career as a DataOps Engineer, a role that I didn't even know that exists one week ago and pushed me to decide to learn and embrace the DevOps practices and tools: concepts that I know from my coleagues of a DevOps squad close to me.

Just to mention my previous experience before taking this chalenge, appart from being a database administrator I am a software developer, and I've recently achieved the Azure AZ-900 and DP-900 certifications, both gave me a general understanding of cloud computing.

## Table of contents

This table of contents is under construction. Items without a link aren't documented yet, as well as items with a link may propably be weakly documented.

- [x] [Project Description](#project-escription)
- [x] [Project tree](#project-tree)
- [x] [Installing tools](#installing-tools)
- [x] [Application environment](#application-setup)
- [x] [Dockerizing](#dockerizing)
- [x] [Terraformation](#terraformation)
- [ ] [Ansible in action](#ansible-in-action)
  - 🔹 [Database server](#database-server)
  - [ ] [Application server](#database-server)
- [ ] [Failover solution](#failover-solution)
- [ ] [Automation with Jenkins](#automation-with-enkins)
- [ ] [Redis setup](#redis-setup)
- [ ] [Orchestration with Kubernetes](#orchestration-with-Kubernetes)
- [ ] [Queue controlling](#queue-controlling)

---

## Project Description

I started my learning path by writing a simple Python + Django API, and I've mounted a Docker image with it. The application is able to access a PostgreSQL database on a different Host.

My most recent step was learning to use Terraform, and both the application host and the database host are now provisioned on the AWS cloud, in different EC2 instances but at the same availability zone. I chose to use a modular aproach for the Terraform project, once this is considered the best practice for companies with multiple teams using the IaaS tool.

So far, it took me most of the week strugling to provision my VMs. I figured out later that among my many mistakes, also a default subnet has to be created for my brand new AWS account's vpc.

Now, it is time to use Ansible for provisioning, configuring and deploying my API and PostgreSQL. The learning courve for Ansible is surprisingly low. Learning and applying the PostgreSQL instalation, the database creation, and set up is taking few hours.

### Next steps

My first step as soon as the application gets operational, will be setting up a high availability sollution, replicating the environment to a different Region. so, I'll setup a pipeline using either Github Actions or Jenkins. This seems to be a core feature of the whole process.

Then, as a way to achieve low latency on database requests, I will refactor the persistence level of the API, and make use of Redis in-memory database.

After that, it will be time to move the API to a Kubernetes cluster, getting able to scale my API. As my final step, I will set up queue controlling using either RabitMQ, Celery, or Apache Kafka.

Wish me luck!

---

## Project tree

This is the tree of contents so far:

```shell
❯ tree -D -I __pycache__
.
├── [Nov 22 01:21]  ansible
│   ├── [Nov 21 22:32]  ansible.cfg
│   ├── [Nov 21 22:57]  api.yml
│   ├── [Nov 21 22:19]  inventories
│   │   └── [Nov 21 22:24]  hosts
│   ├── [Nov 22 00:43]  postgres.yml
│   ├── [Nov 21 23:43]  roles
│   │   ├── [Nov 21 22:57]  api
│   │   │   └── [Nov 21 22:58]  tasks
│   │   │       └── [Nov 21 22:58]  main.yml
│   │   └── [Nov 21 22:20]  postgres
│   │       └── [Nov 22 00:30]  tasks
│   │           └── [Nov 22 01:17]  main.yml
│   └── [Nov 22 01:16]  vars.yml
├── [Nov 21 21:11]  aws
│   ├── [Nov 21 20:46]  aws.tf
│   ├── [Nov 21 02:04]  modules
│   │   ├── [Nov 19 08:20]  apis
│   │   │   ├── [Nov 21 20:25]  main.tf
│   │   │   ├── [Nov 21 15:58]  outputs.tf
│   │   │   └── [Nov 21 20:26]  variables.tf
│   │   └── [Nov 21 02:03]  databases
│   │       ├── [Nov 21 21:38]  main.tf
│   │       ├── [Nov 21 15:38]  outputs.tf
│   │       └── [Nov 21 16:18]  variables.tf
│   ├── [Nov 21 20:26]  outputs.tf
│   ├── [Nov 21 20:47]  revolut_plan
│   ├── [Nov 21 20:48]  terraform.tfstate
│   ├── [Nov 21 20:48]  terraform.tfstate.backup
│   ├── [Nov 21 20:47]  variables.auto.tfvars
│   └── [Nov 21 20:47]  variables.tf
├── [Nov 21 22:09]  hometaskproject
│   ├── [Nov 17 02:54]  db.sqlite3
│   ├── [Nov 20 18:10]  Dockerfile
│   ├── [Nov 19 11:49]  hometaskapp
│   │   ├── [Nov 17 00:17]  admin.py
│   │   ├── [Nov 17 00:17]  apps.py
│   │   ├── [Nov 21 21:27]  dao
│   │   │   ├── [Nov 21 21:27]  conpg.py
│   │   │   └── [Nov 19 15:57]  username.py
│   │   ├── [Nov 17 00:17]  __init__.py
│   │   ├── [Nov 17 02:54]  migrations
│   │   │   └── [Nov 17 00:17]  __init__.py
│   │   ├── [Nov 17 00:17]  models.py
│   │   ├── [Nov 17 00:17]  tests.py
│   │   ├── [Nov 17 03:41]  urls.py
│   │   └── [Nov 19 11:49]  views.py
│   ├── [Nov 20 01:43]  hometaskproject
│   │   ├── [Nov 17 00:17]  asgi.py
│   │   ├── [Nov 17 00:17]  __init__.py
│   │   ├── [Nov 20 01:43]  settings.py
│   │   ├── [Nov 17 01:10]  urls.py
│   │   └── [Nov 17 00:17]  wsgi.py
│   ├── [Nov 17 00:17]  manage.py
│   └── [Nov 20 16:05]  requirements.txt
├── [Nov 22 01:33]  README.md
├── [Nov 21 12:18]  r.gif
└── [Nov 21 16:58]  vo-revolut-exam-01.pem
```

## Installing tools

All instalations described here are applicable to Debian based distributions, Linux Mint in my case. If you need to install these tools on a diffent O.S., please, reffer to the correspinding documentations.

Installing Python

```shell
❯ sudo apt update
❯ sudo apt install software-properties-common
❯ sudo add-apt-repository ppa:deadsnakes/ppa
❯ sudo apt install python
```

Django

```shell
❯ sudo apt-get install pip3
❯ sudo apt-get install pip
❯ pip install django
```

Other Python dependencies

```shell
❯ pip3 install psycopg2
❯ pip3 install psycopg2-binary
❯ pip install python-decouple
```

Installing Docker

```shell
❯ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
❯ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(. /etc/os-release; echo "$UBUNTU_CODENAME") stable"
❯ sudo apt update
❯ sudo apt install docker
❯ sudo usermod -aG docker $USER
```

Installing PostgreSQL (just for refference)

```shell
❯ sudo apt install postgresql-14 postgresql-contrib-14
```

Installing Terraform

```shell
❯ sudo apt update
❯ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
❯ sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
❯ sudo apt install terraform
```

Installing Ansible

```shell
❯ python -m pip install --user ansible
❯ python -m pip install --user paramiko
❯ sudo apt install software-properties-common
❯ sudo apt install ansible
```

---

## Application environment

On the root folder of the hometastproject project, just create an ".env" file and paste the content above in it. Then, follow the hints in order to fill the variables values.

IMPORTANT! Be careful on not adding any space between the equal sign and the value of each variable.

> .env
>
> ```py
> # ------------
> # django
> # ------------
> # Replace the content of the string with the secret key of your own Django "settings.py" file.
> SECRET_KEY='django-insecure-wak-...'
>
> # ------------
> # database
> # ------------
> # Set the credentials for the PostgreSQL database
> host=             # IP or DNS of the database Host
> port=             # (default 5432)
> database=         # Database name
> user=             # Role name
> password=         # Database role password
> application_name=Birthday Application
> ```

## Dockerizing

The steps bellow shall be tak0en in the API project's directory.

> Dockerfile
>
> ```docker
> FROM python:3
>
> WORKDIR /usr/src/app
> COPY requirements.txt ./
> RUN pip install --no-cache-dir -r requirements.txt
>
> COPY . .
>
> CMD ["python", "manage.py", "runserver", "0.0.0.0:80"]
> ```

Building an image named "api"

```shell
❯ docker build -t api .
```

If all the application's dependencies were declared on the "requirements.txt" file, the new image will be creasted.

In order to test the application, the next step will be running a container.

Running a container named "capi"

```shell
❯ docker run --name capi -d -p 80:80 --net host api
```

Eliminating the container

```shell
❯ docker rm -f capi
```

Destroying the image

```shell
❯ docker rmi api
```

---

## Terraformation

Set the following variables which will be user by Terrafor.

> variables.auto.tfvars
>
> ```terraform
> vm_connetion_ports_api = [22, 80]
> vm_connetion_ports_db  = [22, 5432]
>
> counter = 1
>
> ssh_key_name   = ""     # Create and put here the name of the key used by Terraform
> sec_group_name = ""     # Name your security group
>
> username = ""           # Your user name
>
> ssh_private_key = "~/.ssh/my_aws"      # Your private key's location
> ssh_public_key  = "~/.ssh/my_aws.pub"  # Your public key's location
>
> provider_access_key = "AKI..." # Replace with your AWS access key
> provider_secret_key = "..."    # Replace with your AWS secret key
> ```

The steps bellow shall be taken in the "aws" directory.

At the first time running a Terraform project, Terraform has to be initialized.

Initializing

```shell
❯ terraform init
```

Plannning

```shell
❯ terraform plan -out "revolut_plan"
```

Applying

```shell
❯ terraform apply "revolut_plan"
```

Destroying

```shell
❯ terraform destroy
```

---

## Ansible in action

Despite provisioning both VM and applications can be done using only either Terraform or Ansible, it is a good practice to create VMs using Terraform, and using Ansible for installing and configuring the cloud applications.

Setting up .pem file to access to the remote hosts

> /etc/ansible/ansible.cfg
>
> ```shell
> # Add the path of your .PEM file.
> private_key_file = /path/my_pem_file.pem
> ```

Environment variables

> vars.yml
>
> ```yml
> postgresql_version: 14 # PostgreSQL version
> postgresql_host_ip: # The internal IP
> postgresql_port: 5432 # PostgreSQL port
> postgresql_db_name: # The database name
> postgresql_db_user: # The database user's name
> postgresql_db_user_password: # The database user's password
>
> application_name: Birthday API
> ```

> ansible.cfg
>
> ```yml
> [defaults]
> host_key_checking = false
> remote_user = admin
> ask_pass = false
> private_key_file = /.../my_pem_file.pem # path of your pem file
> roles_path = /.../ansible/roles/ #Your roles folder path
> [privilege_escalation]
> become = true
> become_method = sudo
> become_user = admin # Your remote user
> become_ask_pass = false
> ```

---

## Failover solution

---

## Automation with Jenkins

---

## Redis setup

---

## Orchestration with Kubernetes

---

## Queue controlling

---

## Refferences

These are some links I made used of.

[Installing Python](https://linuxhint.com/install-python-3-9-linux-mint/)

[Installing Django](https://docs.djangoproject.com/en/3.2/topics/install/)

[Installing Docker](https://idroot.us/install-docker-linux-mint-20/)

[Ansible official docs for PostgreSQL](https://docs.ansible.com/ansible/2.9/modules/list_of_database_modules.html#postgresql)

[Ansible playbook for PostgreSQL](https://gist.github.com/valerio-oliveira/c5f97b92e348a6b6fdda6731c5283e0c)
