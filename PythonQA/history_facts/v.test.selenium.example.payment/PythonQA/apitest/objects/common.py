import requests
import json


class CommonData:

    def post(self, data, url, headers):
        print('Request: ' + str(data))
        answer = requests.post(url, data=json.dumps(data), headers=headers)
        response = answer.json()
        print('Response: ' + str(response))
        return answer, response

    def post_loads(self, data, url, headers):
        print('Request: ' + str(data))
        answer = requests.post(url=url, json=json.loads(data), headers=headers)
        response = answer.json()
        print('Response: ' + str(response))
        return answer, response

    def get(self, url, headers):
        answer = requests.get(url, headers=headers)
        response = answer.json()
        print('Response: ' + str(response))
        return answer, response

