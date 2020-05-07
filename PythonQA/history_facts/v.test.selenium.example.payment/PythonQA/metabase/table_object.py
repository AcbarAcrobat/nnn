import ast
import sys
import json


class MetaTable:

    def __init__(self, base):
        self.base = base

    def question_list(self):
        card_list = self.base.get('/card/')
        if str(card_list[1]) == '[]':
            with open(sys.path[0] + '/metabase/package.json') as f:
                data = json.load(f)
            for list in range(0, len(data['business'])):
                self.base.post('/card/', json=data['business'][list])
            for list in range(0, len(data['core'])):
                self.base.post('/card/', json=data['core'][list])
        return card_list[1]

    def list_division(self, card_list):
        data = json.dumps(ast.literal_eval(str(card_list)))
        for search in range(0, len(card_list)):
            name = json.loads(str(data))[search]['name']
            if name == 'test_last_card':
                card_query = json.loads(str(data))[search]
            elif name == 'test_last_transaction':
                transaction_query = json.loads(str(data))[search]
            elif name == 'test_last_logs':
                logs_query = json.loads(str(data))[search]
            elif name == 'test_last_feed':
                feed_query = json.loads(str(data))[search]
            elif name == 'test_last_wallet_request':
                wallet_request_query = json.loads(str(data))[search]
            elif name == 'test_last_entries':
                entries_query = json.loads(str(data))[search]
            elif name == "test_last_payment":
                last_payment_query = json.loads(str(data))[search]
        return card_query, transaction_query, logs_query, feed_query, \
               wallet_request_query, entries_query, last_payment_query

    def query(self, base, card_query, transaction_query, logs_query, feed_query,
              wallet_request_query, entries_query, last_payment_query):
        query_id = json.loads(str(json.dumps(ast.literal_eval(str(card_query)))))['id']
        test_last_card = (base.post('/card/' + str(query_id) + '/query/json'))[1]
        query_id = json.loads(str(json.dumps(ast.literal_eval(str(transaction_query)))))['id']
        test_last_transaction = (base.post('/card/' + str(query_id) + '/query/json'))[1]
        query_id = json.loads(str(json.dumps(ast.literal_eval(str(logs_query)))))['id']
        test_last_logs = (base.post('/card/' + str(query_id) + '/query/json'))[1]
        query_id = json.loads(str(json.dumps(ast.literal_eval(str(feed_query)))))['id']
        test_last_feed = (base.post('/card/' + str(query_id) + '/query/json'))[1]
        query_id = json.loads(str(json.dumps(ast.literal_eval(str(wallet_request_query)))))['id']
        test_last_wallet_request = (base.post('/card/' + str(query_id) + '/query/json'))[1]
        query_id = json.loads(str(json.dumps(ast.literal_eval(str(entries_query)))))['id']
        test_last_entries = (base.post('/card/' + str(query_id) + '/query/json'))[1]
        query_id = json.loads(str(json.dumps(ast.literal_eval(str(last_payment_query)))))['id']
        test_last_payment = (base.post('/card/' + str(query_id) + '/query/json'))[1]
        return test_last_card, test_last_transaction, test_last_logs, test_last_feed,\
               test_last_wallet_request, test_last_entries, test_last_payment

