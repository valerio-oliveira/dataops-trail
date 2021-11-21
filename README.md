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

## Project Description

I started my learning path by writing a simple Python + Django API, and I've mounted a Docker image with it. The application is able to access a PostgreSQL database on a different Host.

My most recent step was learning to use Terraform, and both the application host and the database host are now provisioned on the AWS cloud, in different EC2 instances but at the same availability zone. I chose to use a modular aproach for the Terraform project, once this is considered the best practice for companies with multiple teams using the IaaS tool.

So far, it took me most of the week strugling to provision my VMs. I figured out later that among my many mistakes, also a default subnet has to be created for my brand new AWS account's vpc.

Now, it is time to use Ansible and enable IaaS on provisioning, configuring and deploying my API and PostgreSQL. Alongside, I'll setup a high availability sollution, replicating the environment to a different Region.

## Next steps

My first step as soon as the application gets operational, will be to setup a pipeline using either Github Actions or Jenkins. Then, as a way to achieve low latency on database requests, I will refactor the persistence level of the API, and make use of REDIS in-memory database.

After that, it will be time to move the API to a Kubernetes cluster, getting able to scale my API. As my final step, I will set up queue controlling using either RabitMQ, Celery, or Apoache Kafka.

Wish me luck!

---

## Table of contents

This table of contents is under construction. Items without a link aren't documented yet, as well as items with a link may propably be weakly documented.

- [x] [Installing tools](#installing-tools)
- [x] [Application environment](#application-setup)
- [x] [Dockerizing](#dockerizing)
- [x] [Terraforming](#terraforming)
- [ ] [Ansible in action](#ansible-in-action)
- [ ] [REDIS setup](#redis-setup)

---

## Installing tools

All instalations described here are applicable to Debian based distributions, Linux Mint in my case. If you need to install these tools on a diffent O.S., please, reffer to the correspinding documentations.

Installing Python

```shell
$ sudo apt update
$ sudo apt install software-properties-common
$ sudo add-apt-repository ppa:deadsnakes/ppa
$ sudo apt install python
```

Django

```shell
$ sudo apt-get install pip3
$ sudo apt-get install pip
$ pip install django
```

Other Python dependencies

```shell
$ pip3 install psycopg2
$ pip3 install psycopg2-binary
$ pip install python-decouple
```

Installing Docker

```shell
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(. /etc/os-release; echo "$UBUNTU_CODENAME") stable"
$ sudo apt update
$ sudo apt install docker
$ sudo usermod -aG docker $USER
```

Installing PostgreSQL (just for refference)

```shell
$ sudo apt install postgresql-14 postgresql-contrib-14
```

Installing Terraform

```shell
$ sudo apt update
$ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
$ sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
$ sudo apt install terraform
```

Installing Ansible

```shell
$ python -m pip install --user ansible
$ python -m pip install --user paramiko
$ sudo apt install software-properties-common
$ sudo apt install ansible
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
$ docker build -t api .
```

If all the application's dependencies were declared on the "requirements.txt" file, the new image will be creasted.

In order to test the application, the next step will be running a container.

Running a container named "capi"

```shell
$ docker run --name capi -d -p 80:80 --net host api
```

Eliminating the container

```shell
$ docker rm -f capi
```

Destroying the image

```shell
$ docker rmi api
```

---

## Terraforming

variables.auto.tfvars

```terraform
vm_connetion_ports_api = [22, 80]
vm_connetion_ports_db  = [22, 5432]

counter = 1

ssh_key_name   = ""     # Create and put here the name of the key used by Terraform
sec_group_name = ""     # Name your security group

username = ""           # Your user name

ssh_private_key = "~/.ssh/my_aws"      # Your private key's location
ssh_public_key  = "~/.ssh/my_aws.pub"  # Your public key's location

provider_access_key = "AKI..." # Replace with your AWS access key
provider_secret_key = "..."    # Replace with your AWS secret key
```

The steps bellow shall be taken in the "aws" directory.

At the first time running a Terraform project, Terraform has to be initialized.

Initializing

```shell
$ terraform init
```

Plannning

```shell
$ terraform plan -out "revolut_plan"
```

Applying

```shell
$ terraform apply "revolut_plan"
```

Destroying

```shell
$ terraform destroy
```

---

## Ansible in action

Despite provisioning both VM and applications can be done using only Terraform, it is a good practice to use Ansible for installing and configuring the cloud applications.

---

## REDIS setup

Redis is an in-memory database. It is largely used for lowering latency on requisitions between the application and the database.

---

## Refferences

[Installing Python](https://linuxhint.com/install-python-3-9-linux-mint/)
<br>
[Installing Django](https://docs.djangoproject.com/en/3.2/topics/install/)
<br>
[Installing Docker](https://idroot.us/install-docker-linux-mint-20/)
