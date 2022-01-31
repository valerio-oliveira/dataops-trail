from datetime import datetime
from dateutil.relativedelta import relativedelta
import json
from django.http import HttpResponse
from django.views.decorators.csrf import csrf_exempt

from hometaskapp.dao.username import get_birthday, set_birthday


def index(request):
    response = [{'error': 'You should inform a user name.'}]
    return HttpResponse(response, content_type="application/json")


@csrf_exempt
def hello(request, username):
    if not username.isalpha():
        response = [{'error': 'User name must contain only letters.'}]
        return HttpResponse(response, content_type="application/json")

    today = datetime.today().date()

    if request.method == 'POST':
        body_unicode = request.body.decode('utf-8')
        body = json.loads(body_unicode)
        bodydate = body.get("dateOfBirth")

        if bodydate is None:
            response = [{"error": "dateOfBirth not defined."}]
            return HttpResponse(response, content_type="application/json")

        try:
            birthday = datetime.strptime(bodydate, "%Y-%m-%d").date()
        except ValueError:
            response = [{'error': 'Invalid date.'}]
            return HttpResponse(response, content_type="application/json")

        if birthday >= today:
            response = [{'error': 'dateOfBirth cannot be in the future.'}]
            return HttpResponse(response, content_type="application/json")

        print("birthday", birthday, type(birthday))
        result = set_birthday(username=username, birthday=birthday)
        print("result", result, type(result))
        if result != "OK":
            response = [
                {'error': f'Something went wrong! Please, contact the candidate. \n {result}'}]
            return HttpResponse(response, content_type="application/json")

        return HttpResponse(status=204)
    elif request.method == "GET":
        birthday = get_birthday(username=username)
        if birthday is None:
            result = "Sorry! User unknown."
        else:
            print("birthday", birthday, type(birthday))
            birth_day = birthday.day
            birth_mon = birthday.month

            if today.month == birth_mon and today.day == birth_day:
                result = f"Hello, {username}! Happy birthday!"
            else:
                delta = next_birthday(birthday) - today
                days = delta.days
                result = f"Hello, {username}! Your birthday is in {days} day(s)"

        response = [{"message": result}]

        return HttpResponse(response, content_type="application/json")


def next_birthday(birthday):
    today = datetime.today().date()
    years = today.year - birthday.year
    if today.month > birthday.month or (today.month == birthday.month and today.day > birthday.day):
        years += 1

    return birthday + relativedelta(years=years)
