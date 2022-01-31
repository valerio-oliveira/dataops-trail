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

It is been a while since my last update to this project. After a lot of working and studies obligations, and other compromises, I'm rolling up my sleeves again after a hiatus of two months.

This project is a landmark on my career as a DataOps Engineer, a role that I didn't even know that exists one week before I started it, and pushed me to decide to learn and embrace the DevOps practices and tools: concepts that I know from my coleagues of a DevOps squad close to me.

Just to mention my previous experience before taking this chalenge, appart from being a database administrator I am a software developer, and I've recently achieved the Azure AZ-900 and DP-900 certifications, both giving me a general understanding of cloud computing.

## Table of contents

This table of contents is under construction. Unchecked items are not documented yet, besides checked items may probably be weakly documented.

- [x] [Project description](#project-description)
- [x] [Project tree](#project-tree)
- [x] [Installing tools](#installing-tools)
- [x] [Application environment](#application-environment)
- [x] [Dockerizing](#dockerizing)
- [x] [Terraformation](#terraformation)
- [ ] [Ansible in action](#ansible-in-action)
  - [Ansible environment setup](#ansible-environment-setup)
  - [Running playbook 01 - database main](#running-playbook-01-database-main)
  - Application server
- [ ] [Failover solution](#failover-solution)
- [ ] [Automation with Jenkins](#automation-with-jenkins)
- [ ] [Redis in memory database](#redis-in-memory-database)
- [ ] [Orchestration with Kubernetes](#orchestration-with-kubernetes)
- [ ] [Queue controlling](#queue-controlling)
- [ ] [References](#references)

---

## Project description

I started my learning path by writing a simple Python + Django API, and I've mounted a Docker image with it. The application is able to access a PostgreSQL database on a different Host.

My most recent step was learning to use Terraform, and both the application host and the database host are now provisioned on the AWS cloud, in different EC2 instances but at the same availability zone. I chose to use a modular aproach for the Terraform project, once this is considered the best practice for companies with multiple teams using the IaaS tool.

So far, it took me most of the forst week strugling to provision my VMs. I figured out later that among my many mistakes, also a default subnet has to be created for my brand new AWS account's VPC.

Now, it is time to use Ansible for provisioning, configuring, and deploying my API and the PostgreSQL database. The learning courve for Ansible is surprisingly low. Learning and applying the PostgreSQL instalation, the database creation, and set up took few hours.

I was supposed to

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
├── [Nov 22 17:55]  ansible
│   ├── [Nov 21 22:32]  ansible.cfg
│   ├── [Nov 21 22:57]  api.yml
│   ├── [Nov 26 09:47]  inventories
│   │   ├── [Nov 22 22:04]  hosts
│   │   ├── [Nov 26 09:48]  tf_host_aws_us-east-1.yml
│   │   └── [Nov 26 09:48]  tf_host_aws_us-east-2.yml
│   ├── [Nov 22 22:09]  postgres.yml
│   └── [Nov 21 23:43]  roles
│       ├── [Nov 21 22:57]  api
│       │   └── [Nov 21 22:58]  tasks
│       │       └── [Nov 21 22:58]  main.yml
│       └── [Nov 22 21:03]  postgres
│           ├── [Nov 22 19:53]  defaults
│           │   └── [Nov 22 19:53]  main.yml
│           ├── [Nov 22 19:53]  files
│           ├── [Nov 22 19:33]  handlers
│           │   └── [Nov 23 00:35]  main.yml
│           ├── [Nov 22 19:52]  meta
│           │   └── [Nov 22 19:52]  main.yml
│           ├── [Nov 22 17:49]  tasks
│           │   └── [Nov 23 00:54]  main.yml
│           ├── [Nov 22 18:24]  templates
│           │   └── [Nov 22 20:36]  pg_hba.conf.j2
│           └── [Nov 22 17:55]  vars
│               └── [Nov 23 00:54]  main.yml
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
├── [Nov 24 13:58]  README.md
├── [Nov 21 12:18]  r.gif
└── [Nov 26 10:38]  terraform
    └── [Nov 26 09:40]  aws
        ├── [Nov 26 09:24]  main.tf
        ├── [Nov 25 00:49]  net
        │   └── [Nov 26 00:53]  main.tf
        ├── [Nov 25 16:11]  net-vpc-peering
        │   └── [Nov 26 01:05]  main.tf
        ├── [Nov 26 09:14]  outputs.tf
        ├── [Nov 26 01:32]  per-region
        │   ├── [Nov 26 09:37]  main.tf
        │   └── [Nov 26 09:48]  outputs.tf
        ├── [Nov 25 15:32]  provider.tf
        ├── [Nov 25 17:32]  security
        │   └── [Nov 25 18:36]  main.tf
        ├── [Nov 26 09:40]  terraform.tfstate
        ├── [Nov 26 09:40]  terraform.tfstate.backup
        ├── [Nov 26 09:41]  variables.auto.tfvars
        ├── [Nov 26 09:24]  variable.tf
        └── [Nov 25 18:31]  vm
            └── [Nov 26 09:37]  main.tf
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

As I keep learning, I've made changes to the Terraform project a dozen of times. The main setback here was learning the networking concepts. Now, Terraform project creates the environment in two different regions. The model works as follows:

Set the following variables which will be user by Terrafor.

> variables.auto.tfvars
>
> ```terraform
> application_ports    = [22, 80]
> database_ports    = [22, 5432]
> ansible_directory = "../../ansible/inventories"
>
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

### Ansible environment setup

Setting up PEM file on Ansible

> /etc/ansible/ansible.cfg
>
> ```shell
> # Add the path of your .PEM file.
> private_key_file = /path/my_pem_file.pem
>
> # Enable this param in order to avoid issues
> allow_world_readable_tmpfiles=true
> ```

Variables

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
> roles_path = /.../ansible/roles/ # your roles folder path
> [privilege_escalation]
> become = true
> become_method = sudo
> become_user = admin # Your remote user
> become_ask_pass = false
> ```

### Running playbook 01 database main

Bellow we have the playbook execution steps skiping warning messages in order to keep it shorter.

```bash
❯ ansible-playbook -i inventories 01-database-main.yml

PLAY [database-main] ****************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************
ok: [3.82.150.254]

TASK [postgresql-install : Install base packages] ***********************************************************************************
ok: [3.82.150.254] => (item=htop)
changed: [3.82.150.254] => (item=tree)
changed: [3.82.150.254] => (item=lsof)
changed: [3.82.150.254] => (item=gnupg2)
changed: [3.82.150.254] => (item=mcedit)
changed: [3.82.150.254] => (item=dstat)

TASK [postgresql-install : Add postgresql signing key] ******************************************************************************
changed: [3.82.150.254]

TASK [postgresql-install : Add postgresql repository into sources list] *************************************************************
changed: [3.82.150.254]

TASK [postgresql-install : Update packages] *****************************************************************************************
ok: [3.82.150.254]

TASK [postgresql-install : Install postgresql packages] *****************************************************************************
changed: [3.82.150.254] => (item=postgresql-13)
changed: [3.82.150.254] => (item=python3-psycopg2)

TASK [postgresql-install : Configure postgresql.conf - set "listen_addresses"] ******************************************************
changed: [3.82.150.254]

TASK [postgresql-install : Configure postgresql.conf - set "log_destination"] *******************************************************
changed: [3.82.150.254]

TASK [postgresql-install : Configure postgresql.conf - set "logging_collector"] *****************************************************
changed: [3.82.150.254]

TASK [postgresql-install : Configure postgresql.conf - set "log_statement"] *********************************************************
changed: [3.82.150.254]

TASK [postgresql-install : Grant peer authentication to "dbuser"] *******************************************************************
changed: [3.82.150.254]

TASK [postgresql-install : Create replication user] *********************************************************************************
changed: [3.82.150.254]

TASK [postgresql-install : Grant replication access] ********************************************************************************
changed: [3.82.150.254]

TASK [database : Create PostgreSQL DB] **********************************************************************************************
changed: [3.82.150.254]

TASK [database : Create PostgreSQL user and grant access] ***************************************************************************
changed: [3.82.150.254]

TASK [database : Create schema "base"] **********************************************************************************************
changed: [3.82.150.254]

TASK [database : Create table "users"] **********************************************************************************************
changed: [3.82.150.254]

TASK [database : Create user "dbuser"] **********************************************************************************************
changed: [3.82.150.254]

TASK [database : Grant usage on "base"] *********************************************************************************************
changed: [3.82.150.254]

TASK [database : Grant table access on table "users"] *******************************************************************************
changed: [3.82.150.254]

RUNNING HANDLER [postgresql-install : restart postgresql] ***************************************************************************
changed: [3.82.150.254]

PLAY RECAP **************************************************************************************************************************
3.82.150.254               : ok=21   changed=19   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```

Validating the PostgreSQL instalation and the database creation:

```bash
❯ ssh -i ./REVOLUT/exam_01/PEM/aws admin@3.82.150.254
Linux ip-172-20-1-19 4.19.0-14-cloud-amd64 #1 SMP Debian 4.19.171-2 (2021-01-30) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Fri Jan 28 19:07:51 2022 from 177.51.22.51
admin@ip-172-20-1-19:~$ sudo su - postgres
postgres@ip-172-20-1-19:~$ psql -d revolutdb -c "select * from base.users;"
 username | birthday
----------+----------
(0 rows)

postgres@ip-172-20-1-19:~$

```

---

## Failover solution

---

## Automation with Jenkins

---

## Redis in memory database

---

## Orchestration with Kubernetes

---

## Queue controlling

---

## References

These are some of the many links I made used of.

[Installing Python](https://linuxhint.com/install-python-3-9-linux-mint/)

[Installing Django](https://docs.djangoproject.com/en/3.2/topics/install/)

[Installing Docker](https://idroot.us/install-docker-linux-mint-20/)

[Ansible official docs for PostgreSQL](https://docs.ansible.com/ansible/2.9/modules/list_of_database_modules.html#postgresql)

[Ansible playbook for PostgreSQL](https://gist.github.com/valerio-oliveira/c5f97b92e348a6b6fdda6731c5283e0c)

[Docker container pull creation](https://github.com/do-community/ansible-playbooks/tree/master/docker_ubuntu1804)
