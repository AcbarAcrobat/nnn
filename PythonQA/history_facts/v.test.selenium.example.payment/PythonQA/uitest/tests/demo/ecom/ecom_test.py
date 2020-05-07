import pytest
import datetime
from uitest.pages.demo.pay_page import PayPage
from uitest.pages.demo.secure_page import SecurePage
from uitest.pages.demo.demo_other import DemoOther
from uitest.pages.demo.demo_page import DemoPage
from uitest.pages.demo.check_page import CheckPage
from uitest.pages.office.login_page import LoginPage
from uitest.pages.office.payments_page import PaymentsPage
from metabase.table_object import MetaTable
from metabase.business_object import ComparisonObject
from metabase.payments.payments_object import PaymentsObject


@pytest.mark.usefixtures('env')
class TestEcom:

    @pytest.mark.usefixtures('settings_open')
    def test_settings_edit(self, direction, env):
        settings = self.default_edit.settings()
        ecom_settings = self.default_edit.ecom(settings)
        self.default_edit.settings_input(settings_to=ecom_settings)
        self.default_edit.settings_save()
        assert self.default_edit.save_check()

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_buy(self, direction, env):
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
        self.pay_page.data_ecom_input(env, direction)
        self.pay_page.data_submit(env)
        self.secure_page = SecurePage(self.driver)
        try:
            assert self.secure_page.at_ecom_secure_page()
            self.secure_page.cvv_ecom_input()
            self.secure_page.secure_ecom_submit()
        except AssertionError:
            assert self.secure_page.at_epayments_secure_page()
            self.secure_page.sms_epayments_input(env)
        global response_url
        response_url = self.pay_page.response()

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_check(self, env):
        self.check_page = CheckPage(self.driver)
        self.check_page.open(env, response_url)
        assert self.check_page.check_status()

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_refund(self, env):
        self.login_page = LoginPage(self.driver)
        self.login_page.login(env)
        assert self.login_page.at_login_page()
        self.login_page.data_input(env)
        self.login_page.data_submit()
        self.payments_page = PaymentsPage(self.driver)
        self.payments_page.open(env)
        assert self.payments_page.on_page()
        status = self.payments_page.last_status()
        date = self.payments_page.payment_date()
        if 'accepted' in status and datetime.datetime.now().strftime('%d.%m.%Y') in date:
            self.payments_page.refund_submit()
            amount = self.payments_page.refund_amount()
            self.payments_page.refund_partial_amount(amount)
            try:
                assert self.payments_page.alert_check()
                print('Ecom partial ERROR!')
                self.driver.close()
            except AssertionError:
                self.payments_page.refund(amount)
                assert self.payments_page.alert_check()
        else:
            print('Failed payment. Test will stop')
            self.driver.close()

    @pytest.mark.usefixtures('metabase', 'old_settings')
    def test_metabase(self, env):
        self.table_object = MetaTable(self.base)
        self.payments_object = PaymentsObject()
        card_list = self.table_object.question_list()
        card_query, transaction_query, logs_query, \
        feed_query, wallet_request_query, entries_query, last_payment_query = self.table_object.list_division(card_list)
        test_last_card, test_last_transaction, test_last_logs, test_last_feed, test_last_wallet_request,\
        test_last_entries, test_last_payment = self.table_object.query(self.base, card_query, transaction_query,
                                                                       logs_query, feed_query, wallet_request_query,
                                                                       entries_query, last_payment_query)
        self.business_object = ComparisonObject(test_last_card, test_last_transaction, test_last_logs, test_last_feed,
                                                test_last_wallet_request, test_last_entries, test_last_payment)
        assert self.business_object.card_ecom_check(env)
        assert self.business_object.transaction_ecom_check()
        assert self.business_object.logs_ecom_check()
        assert self.payments_object.logs_private_check(env, self.base, card_list)



