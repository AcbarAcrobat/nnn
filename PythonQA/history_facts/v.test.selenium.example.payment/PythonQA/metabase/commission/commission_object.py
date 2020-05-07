import ast
import json


class CommissionObject:

    def list_division(self, card_list):
        data = json.dumps(ast.literal_eval(str(card_list)))
        for search in range(0, len(card_list)):
            name = json.loads(str(data))[search]['name']
            if name == 'test_rub_wallet':
                test_rub_wallet_query = json.loads(str(data))[search]
        return test_rub_wallet_query

    def query(self, base, test_rub_wallet_query):
        query_id = json.loads(str(json.dumps(ast.literal_eval(str(test_rub_wallet_query)))))['id']
        test_rub_wallet = (base.post('/card/' + str(query_id) + '/query/json'))[1]
        return test_rub_wallet

    def wallet_amount(self, test_rub_wallet):
        data = json.dumps(ast.literal_eval(str(test_rub_wallet)))
        print('Wallet Data: ' + str(data))
        for amount in range(0, len(data)):
            profile_id = json.loads(str(data))[amount]['profile_id']
            if int(profile_id) == 2:
                sys_wallet = json.loads(str(data))[amount]['available']
                break
        return sys_wallet

    def wallet_check(self, sys_wallet, sys_wallet_new):
        print(str(round(sys_wallet) + 3))
        print(str(round(sys_wallet_new)))
        return True if round(sys_wallet) + 3 == round(sys_wallet_new) else False

