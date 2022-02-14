import requests


def get_url(host, name):
    return 'http://' + host + ':8000/hello/'+name


def post(host, name, birthday):
    url = get_url(host, name)
    msg = {'dateOfBirth': birthday}
    requests.post(url, data=msg)


def get(host, name):
    url = get_url(host, name)
    return requests.get(url)
