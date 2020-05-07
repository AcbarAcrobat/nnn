import ast
import json


class MetaRefundTable:

    def list_division(self, card_list):
        data = json.dumps(ast.literal_eval(str(card_list)))
        for search in range(0, len(card_list)):
            name = json.loads(str(data))[search]['name']
            if name == 'test_refund':
                transaction_query = json.loads(str(data))[search]
            elif name == 'test_last_logs':
                logs_query = json.loads(str(data))[search]
        return transaction_query, logs_query

    def query(self, base, transaction_query, logs_query):
        query_id = json.loads(str(json.dumps(ast.literal_eval(str(transaction_query)))))['id']
        test_last_transaction = (base.post('/card/' + str(query_id) + '/query/json'))[1]
        query_id = json.loads(str(json.dumps(ast.literal_eval(str(logs_query)))))['id']
        test_last_logs = (base.post('/card/' + str(query_id) + '/query/json'))[1]
        return test_last_transaction, test_last_logs

    def transaction_check(self, test_last_transaction):
        data = json.dumps(ast.literal_eval(str(test_last_transaction)))
        print(data)
        for list in range(0, 2):
            operation_type = json.loads(str(data))[list]['operation_type']
            if 'refund' in operation_type:
                refund = json.loads(str(data))[list]
                pay = json.loads(str(data))[list+1]
        refund_status = refund['status']
        pay_status = pay['status']
        print('refund_status: ' + refund_status + '=approved?')
        print('pay_status: ' + pay_status + '=refund?')
        return True if 'approved' in refund_status and 'refund' in pay_status else False

    def transaction_payler_check(self, test_last_transaction):
        data = json.dumps(ast.literal_eval(str(test_last_transaction)))
        gatewey_list = []
        for list in range(0, 2):
            gatewey_list.append(json.loads(str(data))[list]['gatewayable_type'])
        print('\n '+ str(gatewey_list))
        return True if 'PaylerPayment' in str(gatewey_list) else False

    def logs_check(self, test_last_logs):
        data = json.dumps(ast.literal_eval(str(test_last_logs)))
        for search in range(0, 4):
            try:
                kind = json.loads(str(data))[search]['kind']
                if kind == 'refund':
                    status = json.loads(str(data))[search]['status']
            except IndexError:
                pass
        return True if status == '200' else False

    def logs_payler_check(self, test_last_logs):
        data = json.dumps(ast.literal_eval(str(test_last_logs)))
        for search in range(0, 3):
            gateway = json.loads(str(data))[search]['gateway']
            if gateway == 'payler':
                status = json.loads(str(data))[search]['status']
        return True if status == '200' and 'payler' in gateway else False



    def logs_partial_refund_check(self, test_last_logs, amount):
        data = json.dumps(ast.literal_eval(str(test_last_logs)))
        print(str(data))
        for search in range(0, 3):
            gateway = json.loads(str(data))[search]['gateway']
            kind = json.loads(str(data))[search]['kind']
            if kind == 'refund':
                gateway_status = json.loads(str(data))[search]['status']
                gateway_request = json.loads(str(data))[search]['request']
            else:
                notification_request = json.loads(str(data))[search]['request']
        print(gateway)
        print(str(round(amount/2)))
        print(str(notification_request))
        print(str(int((amount/2)/100)))
        print(str(gateway_request))
        if gateway == 'qiwi':
            return True if str(round(amount/2)) in str(notification_request) and str(gateway_status) == '200' \
                           and str(int((amount/2)/100)) in str(gateway_request) else False
        else:
            return True if str(round(int(amount)/2)) in str(notification_request) and str(gateway_status) == '200' \
                           and str(round(int(amount)/2)) in str(gateway_request) else False

    def transaction_partial_refund_check(self, test_last_transaction, amount):
        data = json.dumps(ast.literal_eval(str(test_last_transaction)))
        print(str(data))
        for list in range(0, 2):
            operation_type = json.loads(str(data))[list]['operation_type']
            if 'refund' in operation_type:
                refund = json.loads(str(data))[list]
        return True if 'approved' in refund['status'] and str(round(amount/2)) == str(refund['amount']) else False

