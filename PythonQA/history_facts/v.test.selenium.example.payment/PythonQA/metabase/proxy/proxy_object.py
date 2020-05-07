import ast
import json


class MetaProxyTable:

    def list_division(self, card_list):
        data = json.dumps(ast.literal_eval(str(card_list)))
        for search in range(0, len(card_list)):
            name = json.loads(str(data))[search]['name']
            if name == 'test_last_transaction':
                transaction_query = json.loads(str(data))[search]
        return transaction_query

    def query(self, base, transaction_query):
        query_id = json.loads(str(json.dumps(ast.literal_eval(str(transaction_query)))))['id']
        last_transaction = (base.post('/card/' + str(query_id) + '/query/json'))[1]
        return last_transaction

    def transaction_check(self, last_transaction, amount):
        data = json.dumps(ast.literal_eval(str(last_transaction)))
        print(str(data))
        proxy_payment_status = json.loads(str(data))[0]['status']
        proxy_payment_amount = json.loads(str(data))[0]['amount']
        print("proxy_payment_status: " + str(proxy_payment_status))
        print("proxy_payment_amount: " + str(proxy_payment_amount))
        return True if 'approved' in proxy_payment_status \
                       and amount == str(round(round(proxy_payment_amount)/100)) else False

