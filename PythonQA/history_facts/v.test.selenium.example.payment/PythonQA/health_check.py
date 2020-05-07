import os
import ast
import json
import unittest
import requests
import datetime
from time import sleep


class HealthCheck(unittest.TestCase):

    def test_health(self):
        demo = core = business = settings = metabase = False

        for core_wait in range(20):
            try:
                status = json.loads(str(json.dumps(ast.literal_eval(str(get(os.environ['CORE_URL']))))))['success']
                if status == True:
                    core = True
            except requests.ConnectionError:
                print('No CORE response. Wait 30s...')
                sleep(30)
            if core:
                print('CORE - OK')
                break
        for business_wait in range(20):
            try:
                date = json.loads(str(json.dumps(ast.literal_eval(str(get(os.environ['BUSINESS_URL']))))))['version']
                if str(datetime.datetime.now().year) in date:
                    business = True
            except requests.ConnectionError:
                print('No BUSINESS response. Wait 30s...')
                sleep(30)
            if business:
                print('BUSINESS - OK')
                break
        for demo_wait in range(20):
            try:
                if (get(os.environ['DEMO_URL'])).status_code == 200:
                    demo = True
            except requests.ConnectionError:
                print('No DEMO response. Wait 30s...')
                sleep(30)
            if demo:
                print('DEMO - OK')
                break
        for settings_wait in range(20):
            try:
                date = json.loads(str(json.dumps(ast.literal_eval(str(get(os.environ['SETTINGS_URL']))))))['version']
                if str(datetime.datetime.now().year) in date:
                    settings = True
            except requests.ConnectionError:
                print('No SETTINGS response. Wait 30s...')
                sleep(30)
            if settings:
                print('SETTINGS - OK')
                break
        for metabase_wait in range(20):
            try:
                if (get(os.environ['METABASE_ENPOINT']+'/activity/')).status_code == 401:
                    for meta in range(20):
                        try:
                            get(os.environ['METABASE_PING'],  timeout=0.1)
                            status = json.loads\
                                (str(json.dumps(ast.literal_eval(str(get(os.environ['METABASE_PING']))))))['Success']
                            if status:
                                print('METABASE - OK')
                                metabase = True
                                break
                        except requests.exceptions.ConnectTimeout:
                            print('Setup of METABASE in the process. Wait 20s...')
                            sleep(20)
                else:
                    print('Configure the METABASE in the process. Wait 30s...')
                    sleep(30)
            except requests.ConnectionError:
                print('No METABASE response. Wait 30s...')
                sleep(30)
            if metabase:
                break


def get(url, timeout=None):
    headers = {'Content-Type': 'application/json',
               'Content-Encoding': 'utf-8'}
    answer = requests.get(url, headers=headers, timeout=timeout)
    try:
        response = answer.json()
    except json.JSONDecodeError:
        response = answer
    return response

if __name__ == "__main__":
    unittest.main()

