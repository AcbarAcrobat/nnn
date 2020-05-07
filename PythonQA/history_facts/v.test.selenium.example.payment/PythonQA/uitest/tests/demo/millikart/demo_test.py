import pytest
from uitest.pages.demo.pay_page import PayPage
from uitest.pages.demo.demo_page import DemoPage
from uitest.pages.demo.demo_other import DemoOther
from uitest.pages.demo.check_page import CheckPage
from uitest.pages.demo.secure_page import SecurePage
from metabase.table_object import MetaTable
from metabase.business_object import ComparisonObject
from metabase.payments.payments_object import PaymentsObject


@pytest.mark.usefixtures('env')
class TestBuy:

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_buy(self, direction, env):
        print(direction)
        if direction == 'production':
            self.demo_other = DemoOther(self.driver)
            self.demo_other.open(env)
            assert self.demo_other.at_main_page()
            self.demo_other.data_input('USD', env)
            self.demo_other.click_buy_button()
            pay_url = self.demo_other.at_page2(env)
        else:
            self.demo_page = DemoPage(self.driver)
            self.demo_page.open(env)
            assert self.demo_page.at_main_page()
            self.demo_page.click_buy_button()
            assert self.demo_page.at_page(env)
            pay_url = self.demo_page.at_page(env)
        self.pay_page = PayPage(self.driver)
        self.pay_page.open(pay_url)
        assert self.pay_page.at_main_page()
        self.pay_page.email_input(env)
        self.pay_page.data_input(env, direction)
        self.pay_page.data_submit(env)
        self.secure_page = SecurePage(self.driver)
        try:
            assert self.secure_page.at_secure_page()
            self.secure_page.cvv_input(env)
            self.secure_page.secure_submit()
        except AssertionError:
            assert self.secure_page.at_epayments_secure_page()
            self.secure_page.sms_epayments_input(env)
        global response_url
        response_url = self.pay_page.response()

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_check(self, env):
        self.check_page = CheckPage(self.driver)
        print(response_url)
        self.check_page.open(env, response_url)
        assert self.check_page.check_status()

    @pytest.mark.usefixtures('metabase', 'old_settings')
    def test_metabase(self, env):
        self.table_object = MetaTable(self.base)
        self.payments_object = PaymentsObject()
        card_list = self.table_object.question_list()
        card_query, transaction_query, logs_query, feed_query, wallet_request_query,\
        entries_query, last_payment_query = self.table_object.list_division(card_list)
        test_last_card, test_last_transaction, test_last_logs, test_last_feed, test_last_wallet_request,\
        test_last_entries, test_last_payment = self.table_object.query(self.base, card_query, transaction_query,
                                                                       logs_query, feed_query, wallet_request_query,
                                                                       entries_query, last_payment_query)
        self.business_object = ComparisonObject(test_last_card, test_last_transaction, test_last_logs, test_last_feed,
                                                test_last_wallet_request, test_last_entries, test_last_payment)
        assert self.business_object.card_check(env)
        payment_amount, payment_token = self.business_object.transaction_check(env)
        assert payment_amount, payment_token
        assert self.business_object.logs_check()
        assert self.business_object.feed_check(env, payment_token, payment_amount)
        assert self.business_object.wallet_request_check()
        assert self.business_object.entries_check()
        assert self.payments_object.logs_private_check(env, self.base, card_list)


