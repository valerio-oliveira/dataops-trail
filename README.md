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

This table of contents is under construction.

- [x] [Presentation](#presention)
- [x] [Project tree](#project-tree)
- [x] [Installing tools](#installing-tools)
- [x] [Application environment](#application-environment)
- [x] [Dockerizing](#dockerizing)
- [x] [Terraformation](#terraformation)
- [x] [Ansible in action](#ansible-in-action)
  - [x] [Database server](#database-server)
  - [x] [Replication](#replication-solution)
  - [x] [Application server](#application-server)
  - [ ] [Load balancing with Haproxy](#load-balancing-with-haproxy)
  - [ ] [CI/CD with Jenkins](#automation-with-jenkins)
- [ ] [Orchestration with Kubernetes](#orchestration-with-kubernetes)
- [ ] [References](#references)

---

## Presentation

This project consists of HA solution cluster running on two AWS Regions.

### Region 1 contains:

- Load balancer HAProxy
- 1 node Web server Django/Python v. 3.2.5
- Main PostgreSQL v. 13.5 database

### Region 2 contains:

- Load balancer HAProxy
- 1 node Web server Django/Python v. 3.2.5
- Standby PostgreSQL v. 13.5 database

The infrastructure was created with Terraform 1.1.5, whereas deployment was performed on AWS EC2 Debian 10 virtual machines using Docker v. 20.10.12 and Ansible v. 2.12.1 locally installed.

---

## Project tree

This project is divided into tree projects:

- Application project: includes the REST application code and Dockerfile

- Terraform project: utilized to create the infrastructure layer

- Ansible project: handles the deployment of applications and their dependencies

This is the project tree so far:

```shell
❯ tree -D -I __pycache__
.
├── [Jan 31 11:19]  ansible
│   ├── [Jan 31 08:33]  01-postgres.yml
│   ├── [Jan 31 09:52]  02-database.yml
│   ├── [Jan 31 11:19]  03-application.yml
│   ├── [Jan 31 11:33]  ansible.cfg
│   ├── [Jan 31 08:15]  appserver
│   │   ├── [Jan 31 08:15]  handlers
│   │   └── [Jan 31 08:13]  tasks
│   │       └── [Jan 31 11:39]  main.yml
│   ├── [Nov 29 01:16]  database-create
│   │   ├── [Nov 29 01:16]  handlers
│   │   └── [Nov 29 01:17]  tasks
│   │       └── [Nov 29 01:51]  main.yml
│   ├── [Nov 29 01:16]  dbserver-install
│   │   ├── [Nov 22 19:33]  handlers
│   │   │   └── [Jan 30 00:18]  main.yml
│   │   └── [Nov 29 00:44]  tasks
│   │       └── [Jan 30 17:29]  main.yml
│   ├── [Dec  1 01:50]  dbserver-reset-replication
│   │   ├── [Dec  1 01:50]  handlers
│   │   └── [Dec  1 01:50]  tasks
│   │       └── [Jan 31 10:09]  main.yml
│   ├── [Nov 29 04:18]  dbserver-run-replication
│   │   ├── [Jan 30 17:28]  handlers
│   │   └── [Nov 29 04:18]  tasks
│   │       └── [Jan 31 01:23]  main.yml
│   ├── [Jan 31 09:16]  inventories
│   │   ├── [Jan 31 05:11]  hosts
│   │   ├── [Jan 31 09:16]  hosts_addresses
│   │   └── [Jan 31 09:16]  hosts_ident
│   └── [Jan 31 00:01]  monitoring
│       └── [Jan 31 00:01]  tasks
│           └── [Jan 31 00:01]  main.yml
├── [Nov 28 16:12]  __ansible.__cfg__
├── [Nov 30 22:44]  application
│   ├── [Nov 17 02:54]  db.sqlite3
│   ├── [Jan 31 09:15]  Dockerfile
│   ├── [Jan 31 02:03]  hometaskapp
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
│   │   └── [Jan 31 02:03]  views.py
│   ├── [Nov 20 01:43]  hometaskproject
│   │   ├── [Nov 17 00:17]  asgi.py
│   │   ├── [Nov 17 00:17]  __init__.py
│   │   ├── [Nov 20 01:43]  settings.py
│   │   ├── [Nov 17 01:10]  urls.py
│   │   └── [Nov 17 00:17]  wsgi.py
│   ├── [Nov 17 00:17]  manage.py
│   └── [Nov 30 22:21]  requirements.txt
├── [Jan 31 11:22]  README.md
├── [Nov 21 12:18]  r.gif
└── [Nov 26 10:38]  terraform
    └── [Jan 31 09:16]  aws
        ├── [Jan 30 02:51]  main.tf
        ├── [Jan 31 05:20]  outputs.tf
        ├── [Dec  2 14:38]  per-region
        │   ├── [Jan 28 17:23]  main.tf
        │   ├── [Dec  2 21:44]  outputs.tf
        │   └── [Dec  2 21:44]  variables.tf
        ├── [Nov 25 15:32]  provider.tf
        ├── [Dec  3 00:17]  security
        │   ├── [Dec  3 00:48]  main.tf
        │   ├── [Nov 27 11:09]  outputs.tf
        │   └── [Dec  3 00:17]  variables.tf
        ├── [Jan 31 00:47]  templates
        ├── [Jan 31 09:16]  terraform.tfstate
        ├── [Jan 31 09:14]  terraform.tfstate.backup
        ├── [Jan 31 09:19]  variables.auto.tfvars
        ├── [Jan 31 05:13]  variables.tf
        └── [Dec  1 09:22]  vm
            ├── [Dec  2 21:37]  main.tf
            ├── [Dec  2 20:54]  outputs.tf
            └── [Dec  2 15:00]  variables.tf
```

## Preparation

1: Make sure the SSH keys were created for current user (root) with proper permissions.

## 2:

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

As I keep learning, I've made changes to the Terraform project a dozen times. The main setback here was learning the networking concepts. Now, Terraform project creates the environment in two different regions. The model works as follows:

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

### Running playbook 01 postgres

````

Validating the PostgreSQL instalation and the database creation:

```bash
❯ ssh -i ./REVOLUT/exam_01/PEM/aws admin@3.82.150.254

admin@ip-172-20-1-19:~$ sudo su - postgres

postgres@ip-172-20-1-19:~$ psql -d revolutdb -c "select * from base.users;"

 username | birthday
----------+----------
(0 rows)

````

### Running playbook 02 database

---

### Running playbook 03 application

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

[Install docker on debian with Ansible](https://yasha.solutions/install-docker-on-debian-with-ansible/)
