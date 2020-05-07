import ast
import json
from urllib import parse
from time import sleep
from apitest.objects.common import CommonData


class CheckUrlObject:

    def __init__(self, response_url):
        self.response_url = response_url

    def url_parse(self):
        parse.urlsplit(self.response_url)
        data = dict(parse.parse_qsl(parse.urlsplit(self.response_url).query))
        return data

    def check_url(self):
        return 'success' in self.response_url

    def email_presence(self, email_check):
        return True if email_check else False

    def check_amount(self, amount, data):
        amount_external = json.loads(str(json.dumps(ast.literal_eval(str(data)))))['amount']
        return True if str(amount) == amount_external else False

    def check_currency(self, currency, data):
        currency_external = json.loads(str(json.dumps(ast.literal_eval(str(data)))))['currency']
        gateway_currency_external = json.loads(str(json.dumps(ast.literal_eval(str(data)))))['gatewayCurrency']
        return True if currency == currency_external == gateway_currency_external else False

    def data_return(self, response):
        data = json.dumps(ast.literal_eval(str(response)))
        currency = json.loads(str(data))['payment']['currency']
        amount = json.loads(str(data))['payment']['amount']
        processingUrl = json.loads(str(data))['processingUrl']
        token = json.loads(str(data))['token']
        status = json.loads(str(data))['payment']['status']
        return currency, amount, processingUrl, token, status

    def payment_status(self, status):
        return True if 'approved' == status else False

    def temp_email(self, env, temp_email_key):
        self.common = CommonData()
        sleep(30)
        answer, response = self.common.get(url=env['TEMP_EMAIL_URL'] + '=getlist&key=' + temp_email_key, headers='')
        try:
            message = json.loads(str(json.dumps(ast.literal_eval(str(response)))))['message']
        except KeyError:
            error = json.loads(str(json.dumps(ast.literal_eval(str(response)))))['error']
            if error:
                sleep(60)
                answer, response = self.common.get(url=env['TEMP_EMAIL_URL'] + '=getlist&key=' + temp_email_key,
                                                   headers='')
                message = json.loads(str(json.dumps(ast.literal_eval(str(response)))))[0]
        return message

    def temp_email_check(self, message):
        return True if 'Notification Purchase' in str(message) else False

