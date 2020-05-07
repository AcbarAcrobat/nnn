import ast
import json
from random import choice, randint
from string import ascii_lowercase
from apitest.objects.common import CommonData


class PostCreate:

    def data(self, env, currency=None):
        url = env['BUSINESS_URL'] + 'api/v1/payments'
        print('\n---Post request of creating a payment---' + '\nURL: ' + url)
        headers = {'Authorization': "Bearer " + env['BEARER'],
                   'Content-Type': 'application/json',
                   'Content-Encoding': 'utf-8'}
        product_name = random_word(randint(3, 15))
        if not currency:
            currency = choice(["RUB", "USD"])
        if currency == "USD":
            amount_number = 10
        elif currency == "EUR":
            amount_number = 15
        else:
            amount_number = 200
        data = {"product": product_name,
                "amount": amount_number,
                "currency": currency,
                "extraReturnParam": "AutoTest_" + str(random_number(4)),
                "orderNumber": "AutoTest_" + str(random_number(4)),
                "locale": "en",
                "redirectSuccessUrl": "http://success.com",
                "redirectFailUrl": "http://reject.com/",
                "callback_url": "http://callback.com/"}
        return data, url, headers, currency

    def status_code(self, answer):
        print(str(answer))
        return answer.status_code == 200

    def data_customers(self, env, data, card=None, email=None):
        if card:
            data['card'] = card
        dict = json.dumps(ast.literal_eval(str(data)))
        dict = json.loads(dict)
        if email:
            test_email = email
        else:
            test_email = 'Test-' + str(random_number(4)) + env["CARD_EMAIL"]
        dict["customer"] = {"email": test_email,
                            "address": env["CARD_ADDRESS"],
                            "ip": "77.239.107.0"}
        customer_data = dict
        return customer_data, test_email

    def card_object(self, env, direction, currency):
        if 'production' in direction:
            if currency == 'RUB':
                expires = env['CARD_MEGAFON_EXPRIRES']
                pan_card = env['CARD_MEGAFON_NUMBER']
                cvv_card = env['CARD_MEGAFON_CVV']
            else:
                expires = env['CARD_EPAYMANTS_EXPRIRES']
                pan_card = env['CARD_EPAYMANTS_NUMBER']
                cvv_card = env['CARD_EPAYMANTS_CVV']
        else:
            if currency == 'RUB':
                expires = '03/2020'
            else:
                expires = '04/2020'
            pan_card = env['CARD_NUMBER']
            cvv_card = env['CARD_CVV']
        card = {"pan": pan_card,
                "expires": expires,
                "holder": env['CARD_HOLDER'],
                "cvv": cvv_card}
        return card

    def card_h2h(self, env, currency, direction, pan_card=None, expires=None, cvv_card=None):
        if 'production' in direction:
            if currency == 'RUB':
                pan_card = env['CARD_MEGAFON_NUMBER']
                expires = env['CARD_MEGAFON_EXPRIRES']
                cvv_card = env['CARD_MEGAFON_CVV']
            else:
                pan_card = env['CARD_EPAYMANTS_NUMBER']
                expires = env['CARD_EPAYMANTS_EXPRIRES']
                cvv_card = env['CARD_EPAYMANTS_CVV']
        card = {"pan": pan_card,
                "expires": expires,
                "holder": env['CARD_HOLDER'],
                "cvv": cvv_card}
        return card

    def data_currency(self, data, currency):
        dict = json.dumps(ast.literal_eval(str(data)))
        dict = json.loads(dict)
        dict["currency"] = currency
        return dict

    def temp_email(self, env):
        self.common = CommonData()
        answer, response = self.common.get(url=env['TEMP_EMAIL_URL'] + '=new', headers='')
        temp_email = json.loads(str(json.dumps(ast.literal_eval(str(response)))))['email']
        temp_email_key = json.loads(str(json.dumps(ast.literal_eval(str(response)))))['key']
        return temp_email, temp_email_key


def random_number(n):
    start = 10**(n-1)
    end = (10**n)-1
    return randint(start, end)


def random_word(m):
    return ''.join(choice(ascii_lowercase) for i in range(m))

