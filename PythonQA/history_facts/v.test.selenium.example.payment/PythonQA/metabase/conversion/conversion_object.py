import ast
import math
import json
from apitest.objects import common


class MetaConversionObject:

    def list_division(self, card_list):
        data = json.dumps(ast.literal_eval(str(card_list)))
        for search in range(0, len(card_list)):
            name = json.loads(str(data))[search]['name']
            if name == 'test_last_three_transactions':
                transactions_query = json.loads(str(data))[search]
            if name == 'test_last_three_feeds':
                feeds_query = json.loads(str(data))[search]
            if name == 'test_last_three_entries':
                entries_query = json.loads(str(data))[search]
        return transactions_query, feeds_query, entries_query

    def query(self, base, transactions_query, feeds_query, entries_query):
        query_id = json.loads(str(json.dumps(ast.literal_eval(str(transactions_query)))))['id']
        last_three_transactions = (base.post('/card/' + str(query_id) + '/query/json'))[1]
        query_id = json.loads(str(json.dumps(ast.literal_eval(str(feeds_query)))))['id']
        last_three_feeds = (base.post('/card/' + str(query_id) + '/query/json'))[1]
        query_id = json.loads(str(json.dumps(ast.literal_eval(str(entries_query)))))['id']
        last_three_entries = (base.post('/card/' + str(query_id) + '/query/json'))[1]
        return last_three_transactions, last_three_feeds, last_three_entries

    def transactions_check(self, last_three_transactions):
        data = json.dumps(ast.literal_eval(str(last_three_transactions)))
        status = []
        for list in range(0, 3):
            status.append(json.loads(str(data))[list]['status'])
            currency = json.loads(str(data))[list]['currency']
            if 'GBP' == currency:
                gateway_currency_gbp = json.loads(str(data))[list]['gateway_currency']
                amount_gbp = json.loads(str(data))[list]['gateway_amount']
            elif 'CAD' in currency:
                gateway_currency_cad = json.loads(str(data))[list]['gateway_currency']
                amount_cad = json.loads(str(data))[list]['gateway_amount']
        return amount_gbp, amount_cad if len(set(status)) == 1 \
                                         and gateway_currency_cad == 'RUB' == gateway_currency_gbp else False

    def conversation_check(self, env, amount_gbp, amount_cad):
        headers = {'Content-type': 'application/json'}
        answer, response = common.CommonData.get(self, env['CONVERT_URL'], headers)
        data = json.dumps(ast.literal_eval(str(response)))
        rate_bgp = json.loads(str(data))['quotes']['RUBGBP']
        rate_cad = json.loads(str(data))['quotes']['RUBCAD']
        rate_list = []
        rate_list.append\
            (math.isclose(math.floor(round(int(env['DEMO_DATA_AMOUNT'])/round(rate_bgp, 4))), amount_gbp, rel_tol=2))
        rate_list.append\
            (math.isclose(math.floor(round(int(env['DEMO_DATA_AMOUNT'])/round(rate_cad, 4))), amount_cad, rel_tol=2))
        return True if len(set(rate_list)) == 1 else False

    def feed_check(self, last_three_feeds, amount_gbp, amount_cad):
        data = json.dumps(ast.literal_eval(str(last_three_feeds)))
        target_currency_cad = json.loads(str(data))[0]['target_currency']
        target_amount_cad = json.loads(str(data))[0]['target_amount']
        target_currency_gbp = json.loads(str(data))[1]['target_currency']
        target_amount_gbp = json.loads(str(data))[1]['target_amount']
        print(target_currency_gbp)
        print(target_currency_cad)
        print((amount_gbp/100))
        print(target_amount_gbp)
        print((amount_cad/100))
        print(target_amount_cad)

        return True if target_currency_gbp == 'RUB' == target_currency_cad \
                       and (amount_gbp/100) == target_amount_gbp \
                       and (amount_cad/100) == target_amount_cad else False

