<p align="center">
  <img src="r.png" alt="Logo" width=72 height=72>
</p>

  <h2 align="center">Home Task</h2>
  
  <h3 align="center">Author: Valério Oliveira</h2>
<div align="center">  
  <a href="https://www.linkedin.com/in/valerio-oliveira/?locale=en_US">Visit my LinkedIn</a> · <a href="mailto:valerio.net@gmail.com">E-mail me</a>
</div>
<br>

---

## Presentation

This project is a landmark on my career as a DataOps Engineer, a role which one week ago I didn't even know that exists, and that pushed me to decide to learn and embrace the DevOps practices and tools: concepts that I know from my coleagues of a DevOps squad close to me. On the other hand, I've recently achieved the Azure AZ-900 and DP-900 certifications, which gave me a general understanding of cloud computing.

## Project Description

Appart from being a database administrator, I am a software developer. So, I started my learning path by writing a simple Python + Django API, and I've mounted a Docker image with it. The application is able to access a PostgreSQL database on a different Host.

My most recent step was learning to use Terraform, and both the application host and the database host are now provisioned on the AWS cloud, in different EC2 instances but at the same availability zone. I chose to use a modular aproach for the Terraform project, once this is considered the best practice for companies with multiple teams using the IaaS tool.

So far, it took me most of the week strugling to provision my VMs. I figured out later that among my many mistakes, also a default subnet has to be created for my brand new AWS account's vpc.

Now, I'm about to learn and use Ansible to setup both the working environment. Alongside, I'll setup a high availability sollution, replicating the environment to a different Region.

## Next steps

My first step as soon as the application gets operational, will be to setup a CI/CD pipeline using either Github Actions or Jenkins. So, as a way to achieve low latency on the database requests, I will refactor the API, to make use of REDIS in-memory database.

After that, it will be Kubernetes' turn to take action, scaling instances of the API. So, I will set up Celery for queue controlling.

Wish me luck!

---

## Table of contents

This table of contents is under construction. Items without a link aren't documented yet, as well as items with a link may propably be weakly documented.

- [ ] Installing Django
- [ ] Creating and setting up a Django Project
- [ ] Creating and setting up a Django Application
- [ ] Installing Docker
- [x] [Application setup](#application-setup)
- [ ] [REDIS setup](#redis-setup)
- [x] [Dockerfile setup](#docker-setup)

---

## Application setup

On the root folder of this project, create the ".env" file and paste in it the content above. then follow the hints in order to fill the variables values.

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

Than, enter project directory and create the application:

```shell
$ cd homeproject
$ django-admin startapp homeproject
```

Finally, ync Django project's database for the first time:

```shell
$ python manage.py migrate
```

---

## REDIS setup

Redis is an in-memory database. It is largely used for lowering latency on requisitions between the application and, in this case, the PostgreSQL database.

---

## Docker setup

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

So, yet on the root directory, build an image named "api".

```shell
$ docker build -t api .
```

If all the application's dependencies were declared on the "requirements.txt" file, the new image will be creasted, and the next step will be building a container named "capi":

```shell
$ docker run --name capi -d -p 80:80 --net host api
```

Eliminating the container:

```shell
$ docker rm -f capi
```

Destroying the image:

```shell
$ docker rmi api
```

---
