
# # ------------
# # Python API
# # ------------
# FROM python:3

# WORKDIR /usr/src/app
# COPY requirements.txt ./
# RUN pip install --no-cache-dir -r requirements.txt

# COPY . .

# CMD ["python", "manage.py", "runserver", "0.0.0.0:80"]
# ------------
# Python API
# ------------
FROM python:3

LABEL maintainer="Valerio Oliveira <https://github.com/valerio-oliveira>"
LABEL build_date="2021-11-30"

EXPOSE 8000

WORKDIR /usr/src/app
#COPY requirements.txt ./

COPY . .
RUN pip install --no-cache-dir -r requirements.txt

# RUN apk add --no-cache gcc python3-dev musl-dev

# ADD . /django_ec2

# WORKDIR /django_ec2

# RUN pip install -r requirements.txt

RUN python3 manage.py makemigrations

RUN python3 manage.py migrate

CMD [ "python3", "manage.py", "runserver", "0.0.0.0:8000" ]
#CMD [ "python", "manage.py", "runserver", "0.0.0.0:8000" ]



