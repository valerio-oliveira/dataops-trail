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

## Table of contents

This table of contents is under construction. It will get updated as it reflects the project's progress.

- [x] [Presentation](#presention)
- [x] [Project tree](#project-tree)
- [x] [Project topology](#project-topology)
- [x] [Application environment](#application-environment)
- [x] [Dockerizing](#dockerizing)
- [x] [Terraformation](#terraformation)
- [x] [Ansible in action](#ansible-in-action)
  - [x] [Database server](#database-server)
  - [x] [Database replication](#database-replication)
  - [x] [Application server](#application-server)
  - [x] [Load balancing with Haproxy](#load-balancing-with-haproxy)
  - [ ] 👉 [Monitoring with Zabbix and Grafana](#monitoring-with-zabbix-and-grafana)
  - [ ] [CI/CD with Jenkins](#cicd-with-jenkins)
- [ ] [Orchestration with Kubernetes](#orchestration-with-kubernetes)
- [ ] [References](#references)

---

## Presentation

This project consists in a high availability cluster running on two AWS Regions.

The infrastructure was created with Terraform 1.1.5, whereas the deployment was performed on AWS EC2 Debian v. 10 virtual machines using Ansible v. 2.12.1.

The Web application was built into a Docker image using Docker v. 20.10.12 and is available on Dockerhub, from where the playbook get it to build the REST application.

Moreover, this project is subdivided into tree projects:

- Application project: includes the REST application code and Dockerfile
- Terraform project: creates the infrastructure layer
- Ansible project: handles the application deployment its dependencies

### Region 1 contains:

- An EC2 service host with HAProxy load balancer and
- An EC2 application host running 3 instances of the Web application (Django/Python v. 3.2.5)
- An EC2 database host running the Main PostgreSQL v. 13.5 database

### Region 2 contains:

- A seccond service host with HAProxy load balancer
- Another application host running 3 more instances of the Web application (Django/Python v. 3.2.5)
- The database host running the Replica PostgreSQL v. 13.5 database

The application cluster take advantage of the low latency the two Regions

---

## Project tree

This is the project tree so far:

```shell
❯ tree -D -I __pycache__
.
├── [Feb  9 00:42]  ansible
│   ├── [Feb  8 11:35]  ansible.cfg
│   ├── [Feb  9 00:02]  deploy.yml
│   ├── [Feb  9 00:27]  failover.yml
│   ├── [Feb  8 09:30]  inventories
│   │   └── [Feb  8 23:12]  hosts
│   ├── [Feb  9 00:19]  roles
│   │   ├── [Feb  7 23:26]  appserver
│   │   │   ├── [Feb  9 00:15]  files
│   │   │   │   ├── [Feb  8 23:12]  site1.env
│   │   │   │   └── [Feb  9 00:15]  site2.env
│   │   │   ├── [Jan 31 08:15]  handlers
│   │   │   ├── [Feb  6 14:56]  tasks
│   │   │   │   ├── [Feb  8 22:40]  app.yml
│   │   │   │   └── [Feb  8 21:48]  main.yml
│   │   │   └── [Feb  7 23:28]  templates
│   │   ├── [Nov 29 01:16]  database
│   │   │   ├── [Nov 29 01:16]  handlers
│   │   │   └── [Nov 29 01:17]  tasks
│   │   │       └── [Feb  6 18:28]  main.yml
│   │   ├── [Nov 29 01:16]  dbserver
│   │   │   ├── [Nov 22 19:33]  handlers
│   │   │   │   └── [Feb  1 16:35]  main.yml
│   │   │   └── [Feb  6 11:22]  tasks
│   │   │       ├── [Feb  6 11:22]  access.yml
│   │   │       ├── [Feb  6 00:47]  install.yml
│   │   │       ├── [Feb  6 11:57]  main.yml
│   │   │       └── [Feb  6 00:48]  setup.yml
│   │   ├── [Feb  6 14:55]  docker
│   │   │   ├── [Feb  6 14:55]  handlers
│   │   │   └── [Feb  6 18:49]  tasks
│   │   │       ├── [Feb  6 19:34]  install.yml
│   │   │       └── [Feb  6 18:53]  main.yml
│   │   ├── [Feb  6 14:57]  each-host
│   │   │   ├── [Feb  5 23:48]  handlers
│   │   │   │   └── [Feb  5 23:48]  main.yml
│   │   │   └── [Feb  5 23:48]  tasks
│   │   │       └── [Feb  5 23:55]  main.yml
│   │   ├── [Feb  9 00:19]  failover-app
│   │   │   ├── [Feb  9 00:19]  handlers
│   │   │   └── [Feb  9 00:20]  tasks
│   │   │       └── [Feb  9 00:34]  main.yml
│   │   ├── [Feb  9 00:32]  failover-db
│   │   │   ├── [Feb  8 23:33]  handlers
│   │   │   └── [Feb  9 00:21]  tasks
│   │   │       └── [Feb  9 00:33]  main.yml
│   │   ├── [Feb  6 15:05]  haproxy
│   │   │   ├── [Feb  9 00:00]  files
│   │   │   ├── [Feb  6 02:21]  handlers
│   │   │   └── [Feb  7 21:10]  tasks
│   │   │       ├── [Feb  7 11:35]  install.yml
│   │   │       └── [Feb  7 11:38]  main.yml
│   │   ├── [Nov 29 04:18]  replication
│   │   │   ├── [Feb  1 16:33]  handlers
│   │   │   │   └── [Feb  1 16:36]  mail.yml
│   │   │   └── [Nov 29 04:18]  tasks
│   │   │       └── [Feb  6 10:40]  main.yml
│   │   └── [Feb  8 11:26]  zabbix-agent
│   │       ├── [Feb  1 09:46]  handlers
│   │       ├── [Feb  2 22:24]  tasks
│   │       │   └── [Feb  8 11:52]  main.yml
│   │       ├── [Feb  8 11:29]  templates
│   │       │   └── [Feb  8 11:44]  zabbix_agentd.conf.j2
│   │       └── [Feb  8 11:31]  vars
│   │           └── [Feb  8 11:31]  debian.yml
│   ├── [Feb  9 00:43]  stop_main_db.yml
│   ├── [Feb  7 23:31]  templates
│   │   └── [Feb  8 00:21]  hosts
│   └── [Feb  9 00:00]  terraform.tfstate
├── [Nov 28 16:12]  __ansible.__cfg__
├── [Feb  2 17:20]  application
│   ├── [Nov 17 02:54]  db.sqlite3
│   ├── [Feb  8 15:38]  Dockerfile
│   ├── [Jan 31 02:03]  hometaskapp
│   │   ├── [Nov 17 00:17]  admin.py
│   │   ├── [Nov 17 00:17]  apps.py
│   │   ├── [Nov 21 21:27]  dao
│   │   │   ├── [Nov 21 21:27]  conpg.py
│   │   │   └── [Nov 19 15:57]  username.py
│   │   ├── [Nov 17 00:17]  __init__.py
│   │   ├── [Nov 17 02:54]  migrations
│   │   │   └── [Nov 17 00:17]  __init__.py
│   │   ├── [Nov 17 00:17]  models.py
│   │   ├── [Nov 17 00:17]  tests.py
│   │   ├── [Nov 17 03:41]  urls.py
│   │   └── [Jan 31 02:03]  views.py
│   ├── [Nov 20 01:43]  hometaskproject
│   │   ├── [Nov 17 00:17]  asgi.py
│   │   ├── [Nov 17 00:17]  __init__.py
│   │   ├── [Nov 20 01:43]  settings.py
│   │   ├── [Nov 17 01:10]  urls.py
│   │   └── [Nov 17 00:17]  wsgi.py
│   ├── [Nov 17 00:17]  manage.py
│   └── [Feb  5 00:26]  requirements.txt
├── [Feb  9 00:18]  destroy_all.py
├── [Feb  8 21:31]  hometask.png
├── [Feb  8 22:13]  README.md
├── [Nov 21 12:18]  r.gif
├── [Feb  8 23:36]  run_deploy.py
├── [Feb  9 00:39]  run_failover.py
├── [Nov 26 10:38]  terraform
│   └── [Feb  9 00:03]  aws
│       ├── [Feb  7 11:48]  main.tf
│       ├── [Feb  8 21:32]  outputs.tf
│       ├── [Dec  2 14:38]  per-region
│       │   ├── [Feb  7 17:51]  main.tf
│       │   ├── [Feb  6 01:16]  outputs.tf
│       │   └── [Feb  6 23:16]  variables.tf
│       ├── [Feb  7 18:11]  provider.tf
│       ├── [Dec  3 00:17]  security
│       │   ├── [Feb  6 01:14]  main.tf
│       │   ├── [Feb  6 22:50]  outputs.tf
│       │   └── [Feb  6 01:13]  variables.tf
│       ├── [Feb  9 00:03]  terraform.tfstate
│       ├── [Feb  9 00:00]  terraform.tfstate.backup
│       ├── [Feb  8 22:15]  variables.auto.tfvars
│       ├── [Feb  7 23:27]  variables.tf
│       └── [Dec  1 09:22]  vm
│           ├── [Feb  5 22:13]  main.tf
│           ├── [Feb  5 22:45]  outputs.tf
│           └── [Feb  5 22:42]  variables.tf
└── [Feb  9 00:44]  test_failover.py

49 directories, 73 files
```

## Project topology

The infrastructure was provisioned as well as the software layer was deployed following this topology:

<div>
  <p align="left">
    <img src="hometask.png" alt="Logo">
  </p>
</div>

## Application environment

The .env file currently present in the application folder exists just to build the application's Docker image.

Docker image in Dockerhub

```Docker
docker push valerionet/haproxyht:tagname
```

After provisioning the infrastructure, among other files Terraform will create two .env files (site1.env and site2.env), which will later be copied to the service host.

Ansible will then replace the .env file into the application container by the site1.env file content. The site2.env file will be kept in case of Site1 gets unavailable, and the database failover have to be performed.

## Dockerizing

The application image was built and deployed into my Docker hub repository as follow:

The application's Dockerfile

```docker
FROM python:3

LABEL maintainer="Valerio Oliveira <https://github.com/valerio-oliveira>"
LABEL build_date="2022-01-29"

EXPOSE 8000
WORKDIR /usr/src/app

COPY . .

RUN pip3 install --no-cache-dir -r requirements.txt
RUN python3 manage.py makemigrations
RUN python3 manage.py migrate

CMD [ "python3", "manage.py", "runserver", "0.0.0.0:8000" ]
```

Building the application docker image locally

```shell
docker build -t valerionet/haproxyht:latest .
```

Deploying to the Docker hub

```shell
docker push valerionet/haproxyht:latest
```

---

## Terraformation

In order to be able to provision use Terraform, you need to create the "variables.auto.tfvars" file into ./terraform/aws directory, and set the variables values as described below.

variables.auto.tfvars

```terraform
terraform_access_key = "..."        # insert here your access key for terraform
terraform_secret_key = "..."        # insert here your secret key for terraform
application_ports    = [22, 8001, 8002, 8003]
database_ports       = [22, 5432]
service_ports        = [22, 8000]
ansible_inventories  = "../../ansible/inventories"
ssh_public_key       = "..."        # insert here the ssh public key for remote hosts' admin user
appserver_secret_key = "django-..." # insert here the django server secret key
dbport               = 5432
dbname               = "revolutdb"  # set a name for the application database as you wish
dbuser               = "dbuser"     # set a name for the application's user
dbpass               = "..."        # set a pasword for the application's user
dbappname            = "Birthday Application"
haproxy_conf         = "../../ansible/roles/haproxy/files"
```

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

As the most of the key happens into the Ansible playbook, execution details for each role will get updated little by little.

Run the following command into the ./ansible directory:

```shell
ansible-playbook -i inventories --forks 1 deploy.yml
```

### Database server

Validating the PostgreSQL instalation and the database creation:

```bash
❯ ssh -i ./REVOLUT/exam_01/PEM/aws admin@3.82.150.254

admin@site1-db-19:~$ sudo su - postgres

postgres@site1-db-19:~$ psql -d revolutdb -c "select * from base.users;"

 username | birthday
----------+----------
(0 rows)

```

### Database replication

Validating replication

---

### Application server

---

### Monitoring with Zabbix and Grafana

---

### Load balancing with Haproxy

---

### CI/CD with Jenkins

---

## Orchestration with Kubernetes

---

## References

These are some of the many links I made used of.

[Installing Python](https://linuxhint.com/install-python-3-9-linux-mint/)

[Installing Django](https://docs.djangoproject.com/en/3.2/topics/install/)

[Installing Docker](https://idroot.us/install-docker-linux-mint-20/)

[Ansible official docs for PostgreSQL](https://docs.ansible.com/ansible/2.9/modules/list_of_database_modules.html#postgresql)

[Ansible playbook for PostgreSQL](https://gist.github.com/valerio-oliveira/c5f97b92e348a6b6fdda6731c5283e0c)

[Docker container pull creation](https://github.com/do-community/ansible-playbooks/tree/master/docker_ubuntu1804)

[Install docker on debian with Ansible](https://yasha.solutions/install-docker-on-debian-with-ansible/)
