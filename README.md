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
- [x] [Project topology](#project-topology)
- [x] [Application environment](#application-environment)
  - [x] [Dockerizing](#dockerizing)
- [x] [Terraform setup](#terraform-setup)
- [x] [Deployment](#deployment)
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

The infrastructure was provisioned with Terraform 1.1.5, whereas the the software layer was deployed using Ansible v. 2.12.1.

The Web application was built into a Docker image with Docker v. 20.10.12 and is available on Dockerhub, from where the playbook gets it.

Moreover, this project is subdivided into tree subprojects:

- Application project: includes the REST application code and Dockerfile
- Terraform project: creates the infrastructure layer
- Ansible project: handles the software layer deployment

### Region 1 contains:

- An EC2 service host with HAProxy load balancer and
- An EC2 application host running 3 instances of the Web application (Django/Python v. 3.2.5)
- An EC2 database host running the Main PostgreSQL v. 13.5 database

### Region 2 contains:

- A seccond service host with HAProxy load balancer
- Another application host running 3 more instances of the Web application (Django/Python v. 3.2.5)
- The database host running the Replica PostgreSQL v. 13.5 database

The application cluster takes advantage of the low latency between the Regions, delivered by the VPC Peer, and enables all docker images (three in each Region) to be part of the application cluster.

---

## Project topology

The follows this topology:

<div>
  <p align="left">
    <img src="hometask.png" alt="Logo">
  </p>
</div>

## Application environment

The .env file currently present in the application folder exists just to build the Docker image. It will be replaced during the deployment process.

### Details

After provisioning the infrastructure, among other files Terraform will create two files, "site1.env" and "site2.env", which will later be copied to the service host.

Ansible will then replace the .env file by the "site1.env" file content into all application containers.

The "site2.env" file will be kept in case of Site1 gets unavailable.

### Dockerizing

The application image was built and deployed into my Docker hub repository.

Docker image in Dockerhub

```Docker
docker push valerionet/haproxyht:tagname
```

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

## Terraform setup

Just after pulling this project to your local machine, in order to be able to use Terraform, you need to create the "variables.auto.tfvars" file into ./terraform/aws directory, and set variable values as described below. I assume you already have installed and configured Terraform and Ansible in your machine.

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

## Deployment

Make sure you have created the "variables.auto.tfvars" file, just as described in the topic above, before you run the deployment.

Tu run both Infra provisioning with Terraform and Software provisioning with Ansible:

```bash
puthon3 run_deploy.py
```

To proceed the failover:

```bash
puthon3 run_failover.py
```

To destroy the environment:

```bash
puthon3 destroy_all.py
```

Use the following Python scripts to make the executions easier.

### Manual process

Initializing Terraform

```shell
❯ terraform init
```

Checking the project plan

```shell
❯ terraform plan -out "revolut_plan"
```

Applying the named plan

```shell
❯ terraform apply "revolut_plan"
```

Destroying the infrastructure created

```shell
❯ terraform destroy
```

---

## Ansible in action

As the most of the work is performed by the Ansible playbook, execution details for each role are not written yet. It will get updated little by little.

Run the following command into the ./ansible directory:

```shell
ansible-playbook -i inventories --forks 1 deploy.yml
```

### Database server

Validating the PostgreSQL instalation and the database creation:

```bash
❯ ssh -i ./REVOLUT/exam_01/PEM/aws admin@x.x.x.x

admin@site1-db-x:~$ sudo su - postgres

postgres@site1-db-x:~$ psql -d revolutdb -c "select * from base.users;"

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
