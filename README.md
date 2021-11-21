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

## Project Description

In this DataOps project, I mounted a Docker image containing a simple Python + Django API application. The application is able to access a PostgreSQL database on a different Host. For lowering latency, I sat up a REDIS in-memory database.

Than, using Terraform, both the application host and the database host are provisioned to the AWS cloud, in different EC2 instances but in the same availability zone.

Finally, a database replication cluster is provisioned, with a PostgreSQL instance in a third EC2 instance, now in a different Region.

---

## What is not in this project yet:

The following items will be added in a near future:

- Automatic fail over in case of the main database server stops working;
- Provisioning the application in a Kubernets cluster;
- Using Github Actions for CI/CD;

</p>

---

## Table of contents

This table of contents is under construction. Items without a link aren't documented yet.

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
