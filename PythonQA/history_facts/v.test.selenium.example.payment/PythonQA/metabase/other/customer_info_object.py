import ast
import json


class CustomerInfoTable:

    def leads_division(self, card_list):
        data = json.dumps(ast.literal_eval(str(card_list)))
        for search in range(0, len(card_list)):
            name = json.loads(str(data))[search]['name']
            if name == 'test_last_two_leads':
                test_last_two_leads_query = json.loads(str(data))[search]
            if name == 'test_last_two_profiles':
                test_last_two_profiles_query = json.loads(str(data))[search]
        return test_last_two_leads_query, test_last_two_profiles_query

    def leads_query(self, base, test_last_two_leads_query):
        query_id = json.loads(str(json.dumps(ast.literal_eval(str(test_last_two_leads_query)))))['id']
        test_last_two_leads = (base.post('/card/' + str(query_id) + '/query/json'))
        return test_last_two_leads

    def profiles_query(self, base, test_last_two_profiles_query):
        query_id = json.loads(str(json.dumps(ast.literal_eval(str(test_last_two_profiles_query)))))['id']
        test_last_two_profiles = (base.post('/card/' + str(query_id) + '/query/json'))
        return test_last_two_profiles

    def customer_lead_check(self, env, test_last_two_leads, test_email):
        data = json.dumps(ast.literal_eval(str(test_last_two_leads)))
        list = json.loads(str(data))[1]
        new_email = list[0]['email']
        old_email = list[1]['email']
        return True if test_email == new_email and env['CARD_EMAIL'] != old_email else False

    def customer_profiles_check(self, env, test_last_two_profiles, test_email):
        data = json.dumps(ast.literal_eval(str(test_last_two_profiles)))
        list = json.loads(str(data))[1]
        new_email = list[0]['email']
        new_address = list[0]['address']
        old_email = list[1]['email']
        return True if test_email == new_email and env['CARD_EMAIL'] != old_email\
                       and env['CARD_ADDRESS'] in new_address else False

