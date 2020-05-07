import pytest
from apitest.objects.payments.create_object import PostCreate
from apitest.objects.payments.check_object import CheckUrlObject
from apitest.objects.partial_refund.partial_object import PartialObject
from apitest.objects.common import CommonData
from uitest.pages.demo.pay_page import PayPage
from uitest.pages.demo.demo_page import DemoPage
from uitest.pages.demo.secure_page import SecurePage
from metabase.table_object import MetaTable
from metabase.refund.refund_object import MetaRefundTable


@pytest.mark.usefixtures('env')
class TestPartialRefund:

    def test_create(self, env):
        self.create_object = PostCreate()
        global currency, amount, processingUrl, token
        data, url, headers, currency = self.create_object.data(env, currency='RUB')
        self.common = CommonData()
        answer, response = self.common.post(data, url, headers)
        assert self.create_object.status_code(answer)
        self.check_object = CheckUrlObject(self)
        currency, amount, processingUrl, token, status = self.check_object.data_return(response)

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_buy(self, direction, env):
        self.demo_page = DemoPage(self.driver)
        self.pay_page = PayPage(self.driver)
        self.pay_page.open(processingUrl)
        assert self.pay_page.at_main_page()
        self.pay_page.email_input(env)
        self.secure_page = SecurePage(self.driver)
        self.pay_page.data_input_qiwi(env, direction)
        self.pay_page.data_submit(env)
        self.secure_page.sms_mf_input(env)
        global response_url
        response_url = self.pay_page.response()

    def test_partial_refund(self, env):
        self.partial_object = PartialObject()
        url, headers, data = self.partial_object.data(env, token)
        data['amount'] = round(int(amount)/2)
        self.common = CommonData()
        global answer, response
        answer, response = self.common.post(data, url, headers)

    def test_check(self):
        self.partial_object = PartialObject()
        assert self.partial_object.status_code(answer)

    @pytest.mark.usefixtures('metabase')
    def test_metacheck(self, env):
        self.table_object = MetaTable(self.base)
        card_list = self.table_object.question_list()
        self.refund_object = MetaRefundTable()
        transaction_query, logs_query = self.refund_object.list_division(card_list)
        test_last_transaction, test_last_logs = self.refund_object.query(self.base, transaction_query, logs_query)
        assert self.refund_object.logs_partial_refund_check(test_last_logs, amount)
        assert self.refund_object.transaction_partial_refund_check(test_last_transaction, amount)

