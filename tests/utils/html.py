import json
import requests


def get_url(host, name):
    return 'http://' + host + ':8000/hello/'+name


headers = {
    'content-type':	'application/json',
}


def post(host, name, birthday):
    url = get_url(host, name)
    data = {'dateOfBirth': birthday}
    print('post', url, data)
    requests.post(url, headers=headers,
                  data=json.dumps(data), timeout=15, verify=True)


def get(host, name):
    url = get_url(host, name)
    print('get', url, requests.get(url).content)
