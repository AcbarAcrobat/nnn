import pytest
from apitest.objects.payments.check_object import CheckUrlObject
from apitest.objects.payments.create_object import PostCreate
from apitest.objects.common import CommonData
from uitest.pages.demo.pay_page import PayPage
from uitest.pages.demo.secure_page import SecurePage
from metabase.table_object import MetaTable
from metabase.callback.callback_object import MetaCallbackTable
from metabase.payments.payments_object import PaymentsObject


@pytest.mark.usefixtures('env')
class TestCreate:

    def test_create(self, env):
        self.create_object = PostCreate()
        data, url, headers, curreny = self.create_object.data(env, currency='RUB')
        self.common = CommonData()
        answer, response = self.common.post(data, url, headers)
        assert self.create_object.status_code(answer)
        global currency, amount, processingUrl
        self.check_object = CheckUrlObject(self)
        currency, amount, processingUrl, token, status = self.check_object.data_return(response)

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_buy(self, direction, env):
        self.pay_page = PayPage(self.driver)
        self.secure_page = SecurePage(self.driver)
        self.pay_page.open(processingUrl)
        assert self.pay_page.at_main_page()
        self.pay_page.email_input(env)
        self.pay_page.data_input_qiwi(env, direction)
        self.pay_page.data_submit(env)
        self.secure_page.sms_mf_input(env)
        global response_url
        response_url = self.pay_page.response()
        self.pay_page.open(response_url)

    def test_check(self):
        self.check_object = CheckUrlObject(response_url)
        data = self.check_object.url_parse()
        assert self.check_object.check_url()
        assert self.check_object.check_amount(amount, data)
        assert self.check_object.check_currency(currency, data)

    @pytest.mark.usefixtures('metabase')
    def test_metacheck(self, env):
        self.payments_object = PaymentsObject()
        self.table_object = MetaTable(self.base)
        card_list = self.table_object.question_list()
        self.callback_object = MetaCallbackTable()
        logs_query = self.callback_object.list_division(card_list)
        test_last_logs = self.callback_object.query(self.base, logs_query)
        assert self.callback_object.callback_check(test_last_logs)
        assert self.payments_object.logs_private_check(env, self.base, card_list)

