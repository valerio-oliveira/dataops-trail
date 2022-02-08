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
- [x] [Project topology](#project-topology)
- [x] [Application environment](#application-environment)
- [x] [Dockerizing](#dockerizing)
- [x] [Terraformation](#terraformation)
- [x] [Ansible in action](#ansible-in-action)
  - [x] [Database server](#database-server)
  - [x] [Replication](#replication-solution)
  - [x] [Application server](#application-server)
  - [x] [Load balancing with Haproxy](#load-balancing-with-haproxy)
  - [ ] [CI/CD with Jenkins](#cicd-with-jenkins)
- [ ] [Orchestration with Kubernetes](#orchestration-with-kubernetes)
- [ ] [References](#references)

---

## Presentation

This project consists of a high availability cluster running on two AWS Regions.

The infrastructure was created with Terraform 1.1.5, whereas the deployment was performed on AWS EC2 Debian v. 10 virtual machines using Ansible v. 2.12.1.

The Web application was built to a container using Docker v. 20.10.12 and is available on Dockerhub, from where the playbook builds the REST service.

### Region 1 contains:

- A service host with HAProxy load balancer
- An application host running the Web application (Django/Python v. 3.2.5)
- The database host running the Main PostgreSQL v. 13.5 database

### Region 2 contains:

- A seccond service host with HAProxy load balancer
- Another application host running the Web application (Django/Python v. 3.2.5)
- The database host running the Replica PostgreSQL v. 13.5 database

---

## Project tree

This project is subdivided into tree projects:

- Application project: includes the REST application code and Dockerfile
- Terraform project: creates the infrastructure layer
- Ansible project: handles the deployment of applications and their dependencies

This is the project tree so far:

```shell
❯ tree -D -I __pycache__
.
├── [Feb  7 23:31]  ansible
│   ├── [Feb  8 11:35]  ansible.cfg
│   ├── [Feb  8 14:50]  deploy.yml
│   ├── [Feb  8 09:30]  inventories
│   │   └── [Feb  8 11:55]  hosts
│   ├── [Feb  8 14:45]  roles
│   │   ├── [Feb  7 23:26]  appserver
│   │   │   ├── [Feb  8 00:17]  files
│   │   │   │   ├── [Feb  8 10:19]  site1.env
│   │   │   │   └── [Feb  8 10:21]  site2.env
│   │   │   ├── [Jan 31 08:15]  handlers
│   │   │   ├── [Feb  6 14:56]  tasks
│   │   │   │   ├── [Feb  8 07:54]  app.yml
│   │   │   │   └── [Feb  6 18:53]  main.yml
│   │   │   └── [Feb  7 23:28]  templates
│   │   ├── [Nov 29 01:16]  database
│   │   │   ├── [Nov 29 01:16]  handlers
│   │   │   └── [Nov 29 01:17]  tasks
│   │   │       └── [Feb  6 18:28]  main.yml
│   │   ├── [Nov 29 01:16]  dbserver
│   │   │   ├── [Nov 22 19:33]  handlers
│   │   │   │   └── [Feb  1 16:35]  main.yml
│   │   │   └── [Feb  6 11:22]  tasks
│   │   │       ├── [Feb  6 11:22]  access.yml
│   │   │       ├── [Feb  6 00:47]  install.yml
│   │   │       ├── [Feb  6 11:57]  main.yml
│   │   │       └── [Feb  6 00:48]  setup.yml
│   │   ├── [Feb  6 14:55]  docker
│   │   │   ├── [Feb  6 14:55]  handlers
│   │   │   └── [Feb  6 18:49]  tasks
│   │   │       ├── [Feb  6 19:34]  install.yml
│   │   │       └── [Feb  6 18:53]  main.yml
│   │   ├── [Feb  6 14:57]  each-host
│   │   │   ├── [Feb  5 23:48]  handlers
│   │   │   │   └── [Feb  5 23:48]  main.yml
│   │   │   └── [Feb  5 23:48]  tasks
│   │   │       └── [Feb  5 23:55]  main.yml
│   │   ├── [Feb  6 15:05]  haproxy
│   │   │   ├── [Feb  8 14:50]  files
│   │   │   ├── [Feb  6 02:21]  handlers
│   │   │   └── [Feb  7 21:10]  tasks
│   │   │       ├── [Feb  7 11:35]  install.yml
│   │   │       └── [Feb  7 11:38]  main.yml
│   │   ├── [Nov 29 04:18]  replication
│   │   │   ├── [Feb  1 16:33]  handlers
│   │   │   │   └── [Feb  1 16:36]  mail.yml
│   │   │   └── [Nov 29 04:18]  tasks
│   │   │       └── [Feb  6 10:40]  main.yml
│   │   └── [Feb  8 11:26]  zabbix-agent
│   │       ├── [Feb  1 09:46]  handlers
│   │       ├── [Feb  2 22:24]  tasks
│   │       │   └── [Feb  8 11:52]  main.yml
│   │       ├── [Feb  8 11:29]  templates
│   │       │   └── [Feb  8 11:44]  zabbix_agentd.conf.j2
│   │       └── [Feb  8 11:31]  vars
│   │           └── [Feb  8 11:31]  debian.yml
│   └── [Feb  7 23:31]  templates
│       └── [Feb  8 00:21]  hosts
├── [Nov 28 16:12]  __ansible.__cfg__
├── [Feb  2 17:20]  application
│   ├── [Nov 17 02:54]  db.sqlite3
│   ├── [Feb  2 17:39]  Dockerfile
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
│   └── [Feb  5 00:26]  requirements.txt
├── [Feb  5 11:40]  README.md
├── [Nov 21 12:18]  r.gif
└── [Nov 26 10:38]  terraform
    └── [Feb  8 14:50]  aws
        ├── [Feb  7 11:48]  main.tf
        ├── [Feb  8 10:05]  outputs.tf
        ├── [Dec  2 14:38]  per-region
        │   ├── [Feb  7 17:51]  main.tf
        │   ├── [Feb  6 01:16]  outputs.tf
        │   └── [Feb  6 23:16]  variables.tf
        ├── [Feb  7 18:11]  provider.tf
        ├── [Dec  3 00:17]  security
        │   ├── [Feb  6 01:14]  main.tf
        │   ├── [Feb  6 22:50]  outputs.tf
        │   └── [Feb  6 01:13]  variables.tf
        ├── [Feb  8 14:50]  terraform.tfstate
        ├── [Feb  8 14:50]  terraform.tfstate.backup
        ├── [Feb  7 23:27]  variables.auto.tfvars
        ├── [Feb  7 23:27]  variables.tf
        └── [Dec  1 09:22]  vm
            ├── [Feb  5 22:13]  main.tf
            ├── [Feb  5 22:45]  outputs.tf
            └── [Feb  5 22:42]  variables.tf

43 directories, 63 files
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

After provisioning the infrastructure on the Cloud, among other files Terraform will create two .env files (site1.env and site2.env), which will later be copied to the service host.

Ansible will then replace the .env file into the application container by the site1.env file content. The site2.env file content will be kept in case of Site1 gets unavailable, and the database failover have to be performed.

## Dockerizing

The application was build using the following command:

Building the application docker image

```

```

Dockerfile

```docker
FROM python:3
WORKDIR /usr/src/app
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
CMD ["python", "manage.py", "runserver", "0.0.0.0:80"]
```

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

Set the variables used by Terrafor.

variables.auto.tfvars

```terraform
terraform_access_key = "..."        # insert here your access key for terraform
terraform_secret_key = "..."        # insert here your secret key for terraform
application_ports    = [22, 80, 8000]
database_ports       = [22, 80, 5432]
service_ports        = [22, 80, 8000, 5432]
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
