import pytest
import datetime
from uitest.pages.demo.pay_page import PayPage
from uitest.pages.demo.secure_page import SecurePage
from uitest.pages.demo.demo_other import DemoOther
from uitest.pages.demo.check_page import CheckPage
from uitest.pages.office.login_page import LoginPage
from uitest.pages.office.payments_page import PaymentsPage
from metabase.table_object import MetaTable
from metabase.business_object import ComparisonObject
from metabase.payments.payments_object import PaymentsObject


@pytest.mark.usefixtures('env')
class TestAbbPayment:

    @pytest.mark.usefixtures('settings_open')
    def test_settings_edit(self, direction, env):
        settings = self.default_edit.settings()
        h2h_settings = self.default_edit.host2host(settings)
        abb_settings = self.default_edit.abb_check(env, h2h_settings)
        self.default_edit.settings_input(settings_to=abb_settings)
        self.default_edit.settings_save()
        assert self.default_edit.save_check()

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_buy(self, env):
        self.demo_other = DemoOther(self.driver)
        self.pay_page = PayPage(self.driver)
        self.secure_page = SecurePage(self.driver)
        self.check_page = CheckPage(self.driver)
        self.demo_other.open(env)
        assert self.demo_other.at_main_page()
        self.demo_other.data_input('USD', env)
        self.demo_other.data_currency_input('10')
        self.demo_other.click_buy_button()
        pay_url = self.demo_other.at_page2(env)
        self.pay_page.open(pay_url)
        assert self.pay_page.at_main_page()
        self.pay_page.email_input(env)
        self.pay_page.data_input(env, 'production')
        self.pay_page.data_submit(env)
        assert self.secure_page.at_epayments_secure_page()
        self.secure_page.sms_epayments_input(env)
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
        assert self.business_object.card_epayments_check(env)
        assert self.business_object.transaction_abb_check()
        assert self.business_object.logs_check()
        assert self.business_object.logs_abb_check()
        assert self.business_object.wallet_request_check()
        assert self.business_object.entries_check()
        assert self.payments_object.logs_private_check(env, self.base, card_list)

    @pytest.mark.skip('Abb refund blocked')
    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_refund(self, env):
        self.login_page = LoginPage(self.driver)
        self.payments_page = PaymentsPage(self.driver)
        self.login_page.login(env)
        assert self.login_page.at_login_page()
        self.login_page.data_input(env)
        self.login_page.data_submit()
        self.payments_page.open(env)
        assert self.payments_page.on_page()
        status = self.payments_page.last_status()
        date = self.payments_page.payment_date()
        if 'accepted' in status and datetime.datetime.now().strftime('%d.%m.%Y') in date:
            self.payments_page.refund_submit()
            self.payments_page.refund_full_amount()
            assert self.payments_page.alert_check()
        else:
            print('Failed payment. Test will stop')
            self.driver.close()

