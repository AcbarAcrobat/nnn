import ast
import json


class MetaCallbackTable:

    def list_division(self, card_list):
        data = json.dumps(ast.literal_eval(str(card_list)))
        for search in range(0, len(card_list)):
            name = json.loads(str(data))[search]['name']
            if name == 'test_last_logs':
                logs_query = json.loads(str(data))[search]
        return logs_query

    def query(self, base, logs_query):
        query_id = json.loads(str(json.dumps(ast.literal_eval(str(logs_query)))))['id']
        test_last_logs = (base.post('/card/' + str(query_id) + '/query/json'))[1]
        return test_last_logs

    def callback_check(self, test_last_logs):
        data = json.dumps(ast.literal_eval(str(test_last_logs)))
        callback = json.loads(str(data))[0]['request']
        print(str(callback))
        return True if 'callback.com' in callback else False

