import hashlib
from urllib import parse
from apitest.objects.common import CommonData


class SignatureObject:

    def get_payment_info(self, env, token):
        headers = {'Authorization': "Bearer " + env['BEARER'],
                   'Content-Type': 'application/json',
                   'Content-Encoding': 'utf-8'}
        answer, response = CommonData.get(self, env['BUSINESS_URL'] + '/api/v1/payments/' + token, headers)
        return answer, response

    def get_values(self, response):
        redirect_data = dict(parse.parse_qsl(parse.urlsplit(response['payment']['redirect_success_url']).query))
        token = response['payment']['token']
        payment_type = response['payment']['operation_type']
        status = response['payment']['status']
        extraReturnParam = response['payment']['extra_return_param']
        orderNumber = response['payment']['order_number']
        amount = response['payment']['amount']
        currency = response['payment']['currency']
        gatewayAmount = redirect_data['gatewayAmount']
        gatewayCurrency = redirect_data['gatewayCurrency']
        try:
            threeDSStatus = redirect_data['threeDSStatus']
        except KeyError:
            threeDSStatus = None
        sanitizedMask = redirect_data['sanitizedMask']
        try:
            countryISOByIp = redirect_data['countryISOByIp']
        except KeyError:
            countryISOByIp = None
        bankCountryISO = redirect_data['bankCountryISO']
        signature_check = redirect_data['signature']
        value_list = []
        values = [token, payment_type, status, extraReturnParam, orderNumber,
                  amount, currency, gatewayAmount, gatewayCurrency, threeDSStatus,
                  sanitizedMask, countryISOByIp, bankCountryISO]
        for value in values:
            if value != None:
                value_list.append(value)
        return value_list, signature_check

    def string_calculate(self, value_list):
        size_list = []
        for value in value_list:
            size_list.append(str(len(str(value))) + str(value))
        signature_string = ''.join(size_list)
        return signature_string

    def signature_calculate(self, env, signature_string):
        signature_string = signature_string + env['BEARER']
        signature = hashlib.md5(signature_string.encode('utf-8')).hexdigest()
        return signature

    def signature_check(self, signature_check, signature):
        return True if signature_check == signature else False

