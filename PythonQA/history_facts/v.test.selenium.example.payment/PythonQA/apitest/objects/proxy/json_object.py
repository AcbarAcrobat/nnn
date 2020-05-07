import json
import base64
import datetime
from random import choice, randint
from string import ascii_uppercase


class JsonCreate:

    def __init__(self, env):
        self.request_time = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        self.merchant_id = env['PROXY_MERCHANT_ID']
        self.merchant_account_id = env['PROXY_ACCOUNT_ID']
        self.account_username = env['PROXY_ACCOUNT_NAME']
        self.account_password = env['PROXY_ACCOUNT_PASSWORD']
        self.api_version = '1.0.0'
        self.request_id = 'DEMOREQUEST' + str(random_number(15))
        self.tx_source = '1'
        self.recurrent_type = '1'
        self.order_id = self.request_id
        self.order_desctiption = 'Autotest' + str(random_number(13))
        self.amount = str(randint(20, 100))
        self.currency_code = 'RUB'
        self.first_name = random_word(5)
        self.last_name = random_word(5)
        self.address1 = random_word(5)
        self.address2 = random_word(5)
        self.city = random_word(5)
        self.zipcode = str(random_number(5))
        self.state_code = 'MH'
        self.country_code = str(random_number(5))
        self.mobile = str(random_number(10))
        self.phone = str(random_number(8))
        self.email = 'Autotest' + random_word(5) + '@sms.com'
        self.fax = '+' + str(random_number(13))
        self.statement_text = 'AutoTest' + str(random_number(3))
        self.cancel_url = env['INBOX_SMS_URL']
        self.return_url = env['PROXY'] + '/api/v1/test'
        self.notification_url = env['INBOX_SMS_URL']
        self.cvv = env['CARD_CVV']
        self.expiration_month = env['CARD_QIWI_EXPRIRES'][0:2]
        self.expiration_year = env['CARD_QIWI_EXPRIRES'][3:7]
        self.card_holder_name = env['CARD_HOLDER']
        self.cc_number = env['CARD_NUMBER']

    def creation(self):
        global amount, json_data
        amount = self.amount
        print('Amount: ' + str(self.amount))
        json_data = json.dumps({"merchantIdHash": self.merchant_id,
                                "merchantAccountIdHash": self.merchant_account_id,
                                "encryptedAccountUsername": self.account_username,
                                "encryptedAccountPassword": self.account_password,
                                "lang": "EN", "requestTime": self.request_time,
                                "transactionInfo": {"apiVersion": self.api_version,
                                                    "requestId": self.request_id, "txSource": self.tx_source,
                                                    "recurrentType": self.recurrent_type,
                                                    "orderData": {"orderId": self.order_id,
                                                                  "orderDescription": self.order_desctiption,
                                                                  "amount": self.amount,
                                                                  "currencyCode": self.currency_code,
                                                                  "billingAddress": {"firstName": self.first_name,
                                                                                     "lastName": self.last_name,
                                                                                     "address1": self.address1,
                                                                                     "address2": self.address2,
                                                                                     "city": self.city,
                                                                                     "zipcode": self.zipcode,
                                                                                     "stateCode": self.state_code,
                                                                                     "countryCode": self.country_code,
                                                                                     "mobile": self.mobile,
                                                                                     "phone": self.phone,
                                                                                     "email": self.email,
                                                                                     "fax": self.fax}},
                                                    "statementText": self.statement_text,
                                                    "cancelUrl": self.cancel_url, "returnUrl": self.return_url,
                                                    "notificationUrl": self.notification_url}})
        return json_data, amount

    def creation_refund(self, previous_txid):
        json_refund_data = json.dumps({"requestTime": self.request_time,
                                       "merchantIdHash": self.merchant_id,
                                       "merchantAccountIdHash": self.merchant_account_id,
                                       "encryptedAccountUsername": self.account_username,
                                       "encryptedAccountPassword": self.account_password,
                                       "apiVersion": self.api_version,
                                       "requestId": self.request_id,
                                       "previousTxId": previous_txid,
                                       "amount": str(10),
                                       "statementText": self.statement_text})
        return json_refund_data

    def creation_h2h(self, json_data):
        card = {"cvv": self.cvv, "expirationMonth": self.expiration_month,
                "expirationYear": self.expiration_year,
                "cardHolderName": self.card_holder_name,
                "ccNumber": self.cc_number}
        dict = json.loads(json_data)
        dict['transactionInfo']['orderData']['cc'] = card
        json_h2h_data = json.dumps(dict)
        return json_h2h_data

    def append(self, json_data, signature):
        dict = json.loads(json_data)
        dict['signature'] = str(signature)
        request_json = json.dumps(dict)
        return request_json

    def base(self, request_json):
        encoded = base64.b64encode(request_json.encode('utf-8')).decode("utf-8")
        return encoded


def random_number(n):
    start = 10**(n-1)
    end = (10**n)-1
    return randint(start, end)


def random_word(m):
    return ''.join(choice(ascii_uppercase) for i in range(m))

