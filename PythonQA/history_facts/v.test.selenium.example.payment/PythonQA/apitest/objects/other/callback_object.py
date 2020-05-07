import ast
import json
import requests
from random import choice, randint
from string import ascii_lowercase
from time import sleep
from apitest.objects.common import CommonData


class CallbackObject:

    def webhook(self, env):
        self.common = CommonData()
        answer, response = self.common.post(data={}, url=env['WEBHOOK_URL'] + 'token', headers='')
        webhook_token = json.loads(str(json.dumps(ast.literal_eval(str(response)))))['uuid']
        return webhook_token

    def data(self, env, webhook_token):
        url = env['BUSINESS_URL'] + 'api/v1/payments'
        print('\n---Post request of creating a payment---' + '\nURL: ' + url)
        global headers
        headers = {'Authorization': "Bearer " + env['BEARER'],
                   'Content-Type': 'application/json',
                   'Content-Encoding': 'utf-8'}
        product_name = random_word(randint(3, 15))
        global extraReturnParam, orderNumber
        extraReturnParam = "AutoTest" + str(random_number(4))
        orderNumber = "AutoTest" + str(random_number(4))
        data = {"product": product_name,
                "amount": 200,
                "currency": 'RUB',
                "extraReturnParam": extraReturnParam,
                "orderNumber": orderNumber,
                "locale": "en",
                "redirectSuccessUrl": "http://success.com",
                "redirectFailUrl": "http://reject.com/",
                "callback_url": env['WEBHOOK_URL'] + webhook_token}
        return data, url, headers

    def status_code(self, answer):
        print(str(answer))
        return answer.status_code == 200

    def callback_send(self, env, token):
        data = {"token": token}
        url = env['BUSINESS_URL'] + 'api/v1/resend_notification'
        answer = requests.post(url=url, data=json.dumps(data), headers=headers)
        response = answer.json()
        return answer, response

    def callback_send_check(self, env, webhook_token, hook):
        self.common = CommonData()
        content = None
        if hook != 0:
            sleep(10)
        for number in range(1, 10):
            answer, response = self.common.get(url=env['WEBHOOK_URL'] + 'token/'
                                               + webhook_token + '/requests', headers=headers)
            try:
                data = json.loads(str(json.dumps(ast.literal_eval(str(answer.json())))))['data']
                content = json.loads(str(json.dumps(ast.literal_eval(str(answer.json())))))['data'][hook]['content']
                print('Webhook data: ' + str(data))
            except KeyError:
                sleep(10)
            if content:
                break
        return content

    def callback_check(self, content, token, currency, amount):
        content_data = json.loads(str(content))
        token_check = content_data['token']
        type = content_data['type']
        status = content_data['status']
        extraReturnParam_callback = content_data['extraReturnParam']
        orderNumber_callback = content_data['orderNumber']
        currency_callback = content_data['currency']
        amount_callback = content_data['amount']
        sanitizedMask = content_data['sanitizedMask']
        bankCountryISO = content_data['bankCountryISO']
        signature = content_data['signature']
        availableForRefundAmount = content_data['availableForRefundAmount']
        availableForRefundCurrency = content_data['availableForRefundCurrency']
        return True if type == 'pay' and 'approved' == status and extraReturnParam == extraReturnParam_callback \
                       and orderNumber == orderNumber_callback and currency == currency_callback \
                       and amount == amount_callback and '****' in sanitizedMask and bankCountryISO and signature \
                       and token == token_check and str(availableForRefundAmount) == str(amount)  \
                       and currency in availableForRefundCurrency else False

    def callback_refund_check(self, content, currency, amount):
        content_data = json.loads(str(content))
        type = content_data['type']
        status_callback = content_data['status']
        currency_callback = content_data['currency']
        amount_callback = content_data['amount']
        signature = content_data['signature']
        if type == 'pay':
            availableForRefundAmount = content_data['availableForRefundAmount']
            availableForRefundCurrency = content_data['availableForRefundCurrency']
            return True if 'refunded' in status_callback and availableForRefundAmount == 0 and \
                           currency in availableForRefundCurrency and currency == currency_callback \
                           and amount == amount_callback and signature else False
        else:
            return True if 'approved' in status_callback and currency == currency_callback \
                           and amount == amount_callback and signature else False

def random_number(n):
    start = 10**(n-1)
    end = (10**n)-1
    return randint(start, end)


def random_word(m):
    return ''.join(choice(ascii_lowercase) for i in range(m))