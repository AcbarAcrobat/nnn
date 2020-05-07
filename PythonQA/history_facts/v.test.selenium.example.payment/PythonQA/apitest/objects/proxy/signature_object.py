import json
import base64
import hashlib
import Cryptodome
from Cryptodome.Cipher import AES


class SignatureCreation:

    def input_creation(self, json_data):
        list1 = ["requestTime", "merchantIdHash", "merchantAccountIdHash",
                 "encryptedAccountUsername", "encryptedAccountPassword"]
        elist1 = []
        list2 = ["apiVersion", "requestId", "txSource", "recurrentType"]
        elist2 = []
        list3 = ["orderId", "orderDescription", "amount", "currencyCode"]
        elist3 = []
        list4 = ["firstName", "lastName", "address1", "address2", "city",
                 "zipcode", "stateCode", "countryCode", "mobile", "phone", "email", "fax"]
        elist4 = []
        list5 = ["statementText", "cancelUrl", "returnUrl", "notificationUrl"]
        elist5 = []
        for x in list1:
            elist1.append(json.loads(str(json_data))[x])
        list1.clear()
        list1 = ''.join(elist1)
        for x in list2:
            elist2.append(json.loads(str(json_data))['transactionInfo'][x])
        list2.clear()
        list2 = ''.join(elist2)
        for x in list3:
            elist3.append(json.loads(str(json_data))['transactionInfo']['orderData'][x])
        list3.clear()
        list3 = ''.join(elist3)
        for x in list4:
            elist4.append(json.loads(str(json_data))['transactionInfo']['orderData']['billingAddress'][x])
        list4.clear()
        list4 = ''.join(elist4)
        for x in list5:
            elist5.append(json.loads(str(json_data))['transactionInfo'][x])
        list5.clear()
        list5 = ''.join(elist5)
        list = [list1, list2, list3, list4, list5]
        input_string = ''.join(list)
        return input_string

    def input_h2h_creation(self, json_h2h_data):
        list1 = ["requestTime", "merchantIdHash", "merchantAccountIdHash",
                 "encryptedAccountUsername", "encryptedAccountPassword"]
        elist1 = []
        list2 = ["apiVersion", "requestId", "txSource", "recurrentType"]
        elist2 = []
        list3 = ["orderId", "orderDescription", "amount", "currencyCode"]
        elist3 = []
        list4 = ["ccNumber", "cardHolderName", "cvv", "expirationMonth", "expirationYear"]
        elist4 = []
        list5 = ["firstName", "lastName", "address1", "address2", "city",
                 "zipcode", "stateCode", "countryCode", "mobile", "phone", "email", "fax"]
        elist5 = []
        list6 = ["statementText", "cancelUrl", "returnUrl", "notificationUrl"]
        elist6 = []
        for x in list1:
            elist1.append(json.loads(str(json_h2h_data))[x])
        list1.clear()
        list1 = ''.join(elist1)
        for x in list2:
            elist2.append(json.loads(str(json_h2h_data))['transactionInfo'][x])
        list2.clear()
        list2 = ''.join(elist2)
        for x in list3:
            elist3.append(json.loads(str(json_h2h_data))['transactionInfo']['orderData'][x])
        list3.clear()
        list3 = ''.join(elist3)
        for x in list4:
            elist4.append(json.loads(str(json_h2h_data))['transactionInfo']['orderData']['cc'][x])
        list4.clear()
        list4 = ''.join(elist4)
        for x in list5:
            elist5.append(json.loads(str(json_h2h_data))['transactionInfo']['orderData']['billingAddress'][x])
        list5.clear()
        list5 = ''.join(elist5)
        for x in list6:
            elist6.append(json.loads(str(json_h2h_data))['transactionInfo'][x])
        list6.clear()
        list6 = ''.join(elist6)
        list = [list1, list2, list3, list4, list5, list6]
        input_h2h_string = ''.join(list)
        return input_h2h_string

    def input_refund_creation(self, json_refund_data):
        refund_data = ['requestTime', 'merchantIdHash', 'merchantAccountIdHash', 'encryptedAccountUsername',
                       'encryptedAccountPassword', 'apiVersion', 'requestId', 'previousTxId',
                       'amount', 'statementText']
        data = []
        for x in refund_data:
            data.append(json.loads(str(json_refund_data))[x])
        refund_data.clear()
        input_refund_string = ''.join(data)
        return input_refund_string


    def signature_creation(self, env, input_string):
        block_size = Cryptodome.Cipher.AES.block_size
        pad = block_size - (len(input_string) % block_size)
        request_string = str(input_string) + (chr(pad) * pad)
        crypto_text = Cryptodome.Cipher.AES.\
            new(env['PROXY_ACCOUNT_KEY'].encode("utf8"), AES.MODE_ECB).encrypt(request_string.encode("utf8"))
        signature = base64.b64encode(hashlib.sha256(crypto_text).digest()).decode("utf-8")
        return signature

