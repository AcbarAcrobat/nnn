import ast
import json
from urllib import parse


class PaymentsObject:

    def list_division(self, card_list):
        data = json.dumps(ast.literal_eval(str(card_list)))
        for search in range(0, len(card_list)):
            name = json.loads(str(data))[search]['name']
            if name == 'test_last_transaction':
                test_last_transaction_query = json.loads(str(data))[search]
            elif name == 'test_last_logs':
                logs_query = json.loads(str(data))[search]
        return test_last_transaction_query, logs_query

    def list_pasta_division(self, card_list):
        data = json.dumps(ast.literal_eval(str(card_list)))
        for search in range(0, len(card_list)):
            name = json.loads(str(data))[search]['name']
            if name == 'test_last_three_transactions':
                test_last_three_transactions_query = json.loads(str(data))[search]
            elif name == 'test_last_logs':
                logs_query = json.loads(str(data))[search]
            elif name == 'test_refund':
                test_refund_query = json.loads(str(data))[search]
        return test_last_three_transactions_query, logs_query, test_refund_query

    def query(self, base, test_last_transaction_query, logs_query):
        query_id = json.loads(str(json.dumps(ast.literal_eval(str(logs_query)))))['id']
        test_last_logs = (base.post('/card/' + str(query_id) + '/query/json'))[1]
        query_id = json.loads(str(json.dumps(ast.literal_eval(str(test_last_transaction_query)))))['id']
        test_last_transactions = (base.post('/card/' + str(query_id) + '/query/json'))[1]
        return test_last_logs, test_last_transactions

    def pasta_query(self, base, test_last_three_transactions_query, logs_query, test_refund_query):
        query_id = json.loads(str(json.dumps(ast.literal_eval(str(logs_query)))))['id']
        test_last_logs = (base.post('/card/' + str(query_id) + '/query/json'))[1]
        query_id = json.loads(str(json.dumps(ast.literal_eval(str(test_last_three_transactions_query)))))['id']
        test_last_three_transactions = (base.post('/card/' + str(query_id) + '/query/json'))[1]
        query_id = json.loads(str(json.dumps(ast.literal_eval(str(test_refund_query)))))['id']
        test_refund = (base.post('/card/' + str(query_id) + '/query/json'))[1]
        return test_last_logs, test_last_three_transactions, test_refund

    def payment_check(self, test_last_transactions):
        data = json.dumps(ast.literal_eval(str(test_last_transactions)))
        gatewayable_type = json.loads(str(data))[0]['gatewayable_type']
        payment_status = json.loads(str(data))[0]['status']
        return True if 'ConnectumPayment' in gatewayable_type \
                       and 'approved' in payment_status else False

    def payment_euro_check(self, test_last_three_transactions, gateway):
        data = json.dumps(ast.literal_eval(str(test_last_three_transactions)))
        status = []
        currency = []
        gatewayable = []
        operation = []
        for list in range(0, 3):
            status.append(json.loads(str(data))[list]['status'])
            currency.append(json.loads(str(data))[list]['gateway_currency'])
            gatewayable.append(json.loads(str(data))[list]['gatewayable_type'])
            operation.append(json.loads(str(data))[list]['operation_type'])
        return True if 'approved' in str(status) and 'EUR' in str(currency) and gateway in str(gatewayable) \
                       and 'pay' in str(operation) else False

    def callback_check(self, test_last_logs):
        data = json.dumps(ast.literal_eval(str(test_last_logs)))
        callback = json.loads(str(data))[0]['request']
        return True if 'callback.com' in callback else False

    def refund_logs_check(self, test_last_logs):
        data = json.dumps(ast.literal_eval(str(test_last_logs)))
        kind = json.loads(str(data))[2]['kind']
        refund_status = json.loads(str(data))[2]['status']
        return True if 'refund' in kind and '200' in refund_status else False

    def euro_logs_check(self, test_last_logs, gateway):
        data = json.dumps(ast.literal_eval(str(test_last_logs)))
        gateway_list = []
        for list in range(0, 4):
            gateway_list.append(json.loads(str(data))[list]['gateway'])
            kind = json.loads(str(data))[list]['kind']
            if 'refund' in kind:
                refund_status = json.loads(str(data))[list]['status']
        return True if gateway in gateway_list and '200' in refund_status else False

    def refund_euro_check(self, test_refund_query):
        data = json.dumps(ast.literal_eval(str(test_refund_query)))
        print(data)
        for list in range(0, 2):
            operation_type = json.loads(str(data))[list]['operation_type']
            if operation_type == 'refund':
                refund_status = json.loads(str(data))[list]['status']
            else:
                pay_status = json.loads(str(data))[list]['status']
        return True if 'approved' in refund_status and 'refund' in pay_status else False

    def refund_transaction_check(self, test_last_transactions):
        data = json.dumps(ast.literal_eval(str(test_last_transactions)))
        operation_type = json.loads(str(data))[0]['operation_type']
        refund_status = json.loads(str(data))[0]['status']
        return True if 'refund' in operation_type and 'approved' in refund_status else False

    def logs_private_check(self, env, base, card_list):
        data = json.dumps(ast.literal_eval(str(card_list)))
        for search in range(0, len(card_list)):
            name = json.loads(str(data))[search]['name']
            if name == "test_last_payment":
                last_payment_query = json.loads(str(data))[search]
        query_id = json.loads(str(json.dumps(ast.literal_eval(str(last_payment_query)))))['id']
        test_last_payment = (base.post('/card/' + str(query_id) + '/query/json'))[1]
        data = json.dumps(ast.literal_eval(str(test_last_payment)))
        print('\n Logs private data: ' + str(data))
        request = json.loads(str(data))[0]['request']
        pan = False
        cvv = False
        bankcard_list = env['CARD_NUMBER'], env['CARD_MEGAFON_NUMBER'], env['CARD_EPAYMANTS_NUMBER'], \
                        env['CARD_ECOM_NUMBER'], env['CARD_PAYLER_NUMBER'], env['CARD_WIRECARD_NUMBER'], \
                        env['CARD_PASTA_NUMBER']
        for list in bankcard_list:
            if list in str(request):
                pan = True
        cvv_list = env['CARD_CVV'], env['CARD_MEGAFON_CVV'], env['CARD_EPAYMANTS_CVV'], env['CARD_PAYLER_CVV'], \
                   env['CARD_WIRECARD_CVV']
        for list in cvv_list:
            if 'cvv2=>"' + str(list) in str(request) or 'cvv=>"' + str(list) in str(request):
                cvv = True
        return False if pan or cvv else True

