import ast
import json


class ComparisonObject:

    def __init__(self, test_last_card, test_last_transaction, test_last_logs, test_last_feed,
                 test_last_wallet_request, test_last_entries, test_last_payment):
        self.test_last_card = test_last_card
        self.test_last_transaction = test_last_transaction
        self.test_last_logs = test_last_logs
        self.test_last_feed = test_last_feed
        self.test_last_wallet_request = test_last_wallet_request
        self.test_last_entries = test_last_entries
        self.test_last_payment = test_last_payment

    def card_check(self, env):
        data = json.dumps(ast.literal_eval(str(self.test_last_card)))
        card_mask = json.loads(str(data))[0]['mask']
        return False if (env['CARD_NUMBER'])[:6] != str(card_mask[:6]) else True

    def card_epayments_check(self, env):
        data = json.dumps(ast.literal_eval(str(self.test_last_card)))
        card_mask = json.loads(str(data))[0]['mask']
        return False if (env['CARD_EPAYMANTS_NUMBER'])[:6] != str(card_mask[:6]) else True

    def card_megafon_check(self, env):
        data = json.dumps(ast.literal_eval(str(self.test_last_card)))
        card_mask = json.loads(str(data))[0]['mask']
        return False if (env['CARD_MEGAFON_NUMBER'])[:6] != str(card_mask[:6]) else True

    def card_alfa_check(self, env):
        data = json.dumps(ast.literal_eval(str(self.test_last_card)))
        card_mask = json.loads(str(data))[0]['mask']
        return False if (env['CARD_ALFA_NUMBER'])[:6] != str(card_mask[:6]) else True

    def card_ecom_check(self, env):
        data = json.dumps(ast.literal_eval(str(self.test_last_card)))
        card_mask = json.loads(str(data))[0]['mask']
        return False if (env['CARD_ECOM_NUMBER'])[:6] != str(card_mask[:6]) else True

    def transaction_check(self, env):
        data = json.dumps(ast.literal_eval(str(self.test_last_transaction)))
        payment_status = json.loads(str(data))[0]['status']
        payment_amount = json.loads(str(data))[0]['amount']
        payment_token = json.loads(str(data))[0]['token']
        payment_gatewayable_id = json.loads(str(data))[0]['gatewayable_id']
        gateway_details = json.loads(str(data))[0]['gateway_details']
        return payment_amount, payment_token if payment_gatewayable_id and 'approval' in str(gateway_details)\
                                                and 'bank_name' in str(gateway_details)\
                                                and 'approved' in payment_status\
                                                and env['PAYMENT_AMOUNT'] == str(payment_amount) else False

    def transaction_qiwi_check(self):
        data = json.dumps(ast.literal_eval(str(self.test_last_transaction)))
        print('\n' + str(data))
        payment_status = json.loads(str(data))[0]['status']
        payment_currency = json.loads(str(data))[0]['currency']
        payment_gateway_type = json.loads(str(data))[0]['gatewayable_type']
        payment_gatewayable_id = json.loads(str(data))[0]['gatewayable_id']
        payment_gateway_details = json.loads(str(data))[0]['gateway_details']
        return True if payment_gatewayable_id and 'approval' in str(payment_gateway_details) \
                       and 'bank_name' in str(payment_gateway_details)\
                       and 'approved' in payment_status and 'RUB' in payment_currency\
                       and 'QiwiPayment' in payment_gateway_type else False

    def transaction_abb_check(self):
        data = json.dumps(ast.literal_eval(str(self.test_last_transaction)))
        print('\n' + str(data))
        payment_status = json.loads(str(data))[0]['status']
        payment_currency = json.loads(str(data))[0]['currency']
        payment_gateway_type = json.loads(str(data))[0]['gatewayable_type']
        payment_gatewayable_id = json.loads(str(data))[0]['gatewayable_id']
        payment_gateway_details = json.loads(str(data))[0]['gateway_details']
        return True if payment_gatewayable_id and 'approval' in str(payment_gateway_details) \
                       and 'bank_name' in str(payment_gateway_details)\
                       and 'approved' in payment_status and 'USD' in payment_currency\
                       and 'AbbPayment' in payment_gateway_type else False

    def transaction_h2h_check(self, currency, gateway):
        data = json.dumps(ast.literal_eval(str(self.test_last_transaction)))
        print('\n' + str(data))
        payment_status = json.loads(str(data))[0]['status']
        payment_currency = json.loads(str(data))[0]['currency']
        payment_gateway_type = json.loads(str(data))[0]['gatewayable_type']
        payment_gatewayable_id = json.loads(str(data))[0]['gatewayable_id']
        payment_gateway_details = json.loads(str(data))[0]['gateway_details']
        return True if payment_gatewayable_id and 'bank_name' in str(payment_gateway_details)\
                       and 'approved' in payment_status and currency in payment_currency\
                       and gateway in payment_gateway_type else False

    def transaction_rfi_check(self):
        data = json.dumps(ast.literal_eval(str(self.test_last_transaction)))
        print('\n' + str(data))
        payment_status = json.loads(str(data))[0]['status']
        payment_currency = json.loads(str(data))[0]['currency']
        payment_gateway_type = json.loads(str(data))[0]['gatewayable_type']
        payment_gatewayable_id = json.loads(str(data))[0]['gatewayable_id']
        return True if payment_gatewayable_id and 'approved' in payment_status\
                       and 'RUB' in payment_currency\
                       and 'RfiPartnerPayment' in payment_gateway_type else False

    def transaction_ecom_check(self):
        data = json.dumps(ast.literal_eval(str(self.test_last_transaction)))
        print('\n Payment: ' + str(data))
        payment_status = json.loads(str(data))[0]['status']
        payment_currency = json.loads(str(data))[0]['currency']
        payment_gateway_type = json.loads(str(data))[0]['gatewayable_type']
        payment_operation_type = json.loads(str(data))[0]['operation_type']
        return True if 'refund' in payment_operation_type and 'approved' in payment_status\
                       and 'USD' in payment_currency and 'EcommPayment' in payment_gateway_type else False

    def logs_check(self):
        data = json.dumps(ast.literal_eval(str(self.test_last_logs)))
        payment_id_list = []
        status_list = []
        for id in range(0, 4):
            payment_id_list.append(json.loads(str(data))[id]['payment_id'])
        for list in range(0, 4):
            status_list.append(json.loads(str(data))[list]['status'])
        return True if len(set(payment_id_list)) == 1 and '200' in status_list else False

    def logs_h2h_check(self, gate):
        data = json.dumps(ast.literal_eval(str(self.test_last_payment)))
        print('\n Logs data: ' + str(data))
        status = json.loads(str(data))[0]['status']
        gateway = json.loads(str(data))[0]['gateway']
        return True if int(status) == 200 and gate.lower() in gateway else False

    def logs_qiwi_check(self):
        data = json.dumps(ast.literal_eval(str(self.test_last_logs)))
        status_list = []
        for gate in range(0, 4):
            try:
                gateway = json.loads(str(data))[gate]['gateway']
                if 'qiwi' == gateway:
                    break
            except IndexError:
                pass
        for list in range(0, 3):
            status_list.append(json.loads(str(data))[list]['status'])
        return True if '200' in status_list and gateway == 'qiwi' else False

    def logs_abb_check(self):
        data = json.dumps(ast.literal_eval(str(self.test_last_logs)))
        status_list = []
        for gate in range(0, 4):
            try:
                gateway = json.loads(str(data))[gate]['gateway']
                if 'abb' == gateway:
                    break
            except IndexError:
                pass
        for list in range(0, 3):
            status_list.append(json.loads(str(data))[list]['status'])
        return True if '200' in status_list and gateway == 'abb' else False

    def logs_rfi_check(self):
        data = json.dumps(ast.literal_eval(str(self.test_last_logs)))
        for gate in range(0, 3):
            gateway = json.loads(str(data))[gate]['gateway']
            if 'rfi_partner' == gateway:
                break
        return True if gateway == 'rfi_partner' else False

    def logs_ecom_check(self):
        data = json.dumps(ast.literal_eval(str(self.test_last_logs)))
        print('\n Logs: ' + str(data))
        payment_id_list = []
        status_list = []
        kind_list = []
        for id in range(1, 2):
            payment_id_list.append(json.loads(str(data))[id]['payment_id'])
        for list in range(0, 3):
            status_list.append(json.loads(str(data))[list]['status'])
        for list in range(0, 3):
            kind_list.append(json.loads(str(data))[list]['kind'])
        return True if len(set(payment_id_list)) == 1 and '200' in status_list\
                       and 'refund' in kind_list else False

    def feed_check(self, env, payment_token, payment_amount):
        data = json.dumps(ast.literal_eval(str(self.test_last_feed)))
        feed_token = json.loads(str(data))[0]['api_payment_token']
        status = json.loads(str(data))[0]['status']
        order_number = json.loads(str(data))[0]['order_number']
        commission_value = json.loads(str(data))[0]['commission_value']
        feed_amount = json.loads(str(data))[0]['amount']
        return True if order_number and payment_token == feed_token\
            and status == 1 and env['PAYMENT_COMISSION'] == str(round(commission_value))\
            and feed_amount == payment_amount/100 else False

    def wallet_request_check(self):
        data = json.dumps(ast.literal_eval(str(self.test_last_wallet_request)))
        wallet_id = json.loads(str(data))[0]['id']
        wallet_feed_id = json.loads(str(data))[0]['feed_id']
        feed_id = json.loads(str(json.dumps(ast.literal_eval(str(self.test_last_feed)))))[0]['id']
        wallet_request_id = json.loads(str(json.dumps(ast.literal_eval(str(self.test_last_entries)))))[0]['wallet_request_id']
        return True if wallet_feed_id == feed_id and wallet_id == wallet_request_id else False

    def entries_check(self):
        data = json.dumps(ast.literal_eval(str(self.test_last_entries)))
        operation_code4 = json.loads(str(data))[3]['operation_code']
        operation_code3 = json.loads(str(data))[2]['operation_code']
        operation_code2 = json.loads(str(data))[1]['operation_code']
        operation_code1 = json.loads(str(data))[0]['operation_code']
        return True if 3 == operation_code4 and 2 == operation_code3 and \
                       1 == operation_code2 and 4 == operation_code1 else False

