import ast
import json
import requests
import datetime
from requests import exceptions


class WeblistPage:

    def __init__(self, driver):
        self.driver = driver

    def list(self, env):
        weblist = [env['CORE_URL'], env['BUSINESS_URL'], env['SETTINGS_URL'], env['DEMO_URL'],
                   env['OFFICE_URL'], env['METABASE_URL'], env['PROXY'], env['INBOX_SMS_URL'],
                   env['DOCS_URL'], env['KIBANA_URL'], env['FLEXY_URL'], env['GITLAB_URL'],
                   env['MANAGE_URL'], env['ADMIN_URL']]
        return weblist

    def weblog(self, weblist):
        for web in weblist:
            self.driver.get(web)
            log = self.driver.get_log('browser')
            data = json.dumps(ast.literal_eval(str(log)))
            list = json.loads(str(data))
            error_list = []
            if len(list) > 0:
                for item in range(-1, len(list) - 1):
                    level = json.loads(str(data))[item]['level']
                    if level == 'SEVERE':
                        message = json.loads(str(data))[item]['message']
                        source = json.loads(str(data))[item]['source']
                        timestamp = json.loads(str(data))[item]['timestamp']
                        timestamp = str(timestamp).replace(' ', '')[:-3]
                        time = datetime.datetime.utcfromtimestamp(int(timestamp))
                        error = '\nWeb: ' + web + '\nDate: ' \
                                + str(time) + '\nMessage: ' + message + '\nSource: ' + source
                        print(error + '\n')
                        error_list.append(error)
                        return error_list

    def status(self, weblist):
        error_list = []
        for web in weblist:
            try:
                answer = requests.get(web, timeout=30)
                if answer.status_code != 200 and answer.status_code != 401:
                    time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                    error = '\nWeb: ' + web + '\nDate: ' + str(time) + '\nResponse: ' + str(answer.status_code)
                    print(error + '\n')
                    error_list.append(error)
            except exceptions.RequestException as error:
                error_list.append(error)
        return error_list

