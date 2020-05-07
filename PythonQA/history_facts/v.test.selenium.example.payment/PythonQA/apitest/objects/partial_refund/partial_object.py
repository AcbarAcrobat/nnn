import ast
import json
from random import choice, randint
from string import ascii_lowercase


class PartialObject:

    def data(self, env, token):
        url = env['BUSINESS_URL'] + 'api/v1/refunds'
        print('\n---Post request of creating a refund---' + '\nURL: ' + url)
        headers = {'Authorization': "Bearer " + env['BEARER'],
                   'Content-Type': 'application/json',
                   'Content-Encoding': 'utf-8'}
        data = {"token": token}
        return url, headers, data

    def status_code(self, answer):
        print(str(answer))
        return answer.status_code == 200

