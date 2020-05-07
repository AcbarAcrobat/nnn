from metabase.business_object import ComparisonObject
from apitest.objects.payments.check_object import CheckUrlObject
from apitest.objects.payments.create_object import PostCreate
from apitest.objects.common import CommonData
from metabase.table_object import MetaTable


class CommonHost2Host:

    def __init__(self):
        self.common = CommonData()
        self.create_object = PostCreate()
        self.check_object = CheckUrlObject(self)

    def h2h_init(self, env, currency, direction='default', pan_card=None, expires=None, cvv_card=None):
        data, url, headers, currency = self.create_object.data(env, currency)
        card = self.create_object.card_h2h(env, currency, direction, pan_card, expires, cvv_card)
        data_customers, test_email = self.create_object.data_customers(env, data, card)
        answer, response = self.common.post(data_customers, url, headers)
        assert self.create_object.status_code(answer)
        currency, amount, processingUrl, token, status = self.check_object.data_return(response)
        return processingUrl, status

    def metabase(self, base, currency, gateway):
        self.table_object = MetaTable(base)
        card_list = self.table_object.question_list()
        card_query, transaction_query, logs_query, feed_query, wallet_request_query,\
        entries_query, last_payment_query = self.table_object.list_division(card_list)
        test_last_card, test_last_transaction, test_last_logs, test_last_feed, test_last_wallet_request,\
        test_last_entries, test_last_payment = self.table_object.query(base, card_query, transaction_query, logs_query,
                                                    feed_query, wallet_request_query, entries_query, last_payment_query)
        self.business_object = ComparisonObject(test_last_card, test_last_transaction, test_last_logs, test_last_feed,
                                                test_last_wallet_request, test_last_entries, test_last_payment)
        assert self.business_object.transaction_h2h_check(currency, gateway)
        assert self.business_object.logs_h2h_check(gateway)

