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
