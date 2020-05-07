import pytest
import datetime
from metabase.table_object import MetaTable
from metabase.payments.payments_object import PaymentsObject
from uitest.pages.demo.pay_page import PayPage
from uitest.pages.demo.secure_page import SecurePage
from uitest.pages.demo.demo_other import DemoOther
from uitest.pages.demo.check_page import CheckPage
from uitest.pages.office.login_page import LoginPage
from uitest.pages.office.payments_page import PaymentsPage


@pytest.mark.usefixtures('env')
class TestPastaBuy:

    @pytest.mark.usefixtures('settings_open')
    def test_settings_edit(self, direction, env):
        settings = self.default_edit.settings()
        pasta_settings, pasta_key = self.default_edit.pasta_check(settings)
        self.default_edit.settings_input(settings_to=pasta_settings)
        self.default_edit.settings_save()
        assert self.default_edit.save_check()
        if not pasta_key:
            raise KeyError('No key assets for pasta gateway')

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_buy(self, direction, env):
        print(direction)
        self.demo_other = DemoOther(self.driver)
        self.pay_page = PayPage(self.driver)
        self.secure_page = SecurePage(self.driver)
        self.check_page = CheckPage(self.driver)
        self.demo_other.open(env)
        assert self.demo_other.at_main_page()
        self.demo_other.data_input('EUR', env)
        self.demo_other.data_currency_input('10')
        self.demo_other.click_buy_button()
        pay_url = self.demo_other.at_page2(env)
        self.pay_page.open(pay_url)
        assert self.pay_page.at_main_page()
        self.pay_page.email_input(env)
        self.pay_page.data_input_pasta(env, direction)
        self.pay_page.data_submit(env)
        if direction == 'production':
            assert self.secure_page.at_epayments_secure_page()
            self.secure_page.sms_epayments_input(env)
        else:
            assert self.secure_page.at_pasta_secure_page()
            self.secure_page.secure_pasta_submit()
        assert self.check_page.check_status()

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
            amount = self.payments_page.refund_amount()
            self.payments_page.refund_partial_amount(amount)
            assert self.payments_page.alert_check()
            assert self.payments_page.rerefund()
        else:
            print('Failed payment. Test will stop')
            self.driver.close()

    @pytest.mark.usefixtures('metabase', 'old_settings')
    def test_metabase(self, env):
        self.table_object = MetaTable(self.base)
        self.payments_object = PaymentsObject()
        card_list = self.table_object.question_list()
        test_last_three_transactions_query, logs_query, test_refund_query = \
            self.payments_object.list_pasta_division(card_list)
        test_last_logs, test_last_three_transactions, test_refund = self.payments_object.pasta_query(
            self.base, test_last_three_transactions_query, logs_query, test_refund_query)
        assert self.payments_object.payment_euro_check(test_last_three_transactions, 'Pasta')
        assert self.payments_object.refund_euro_check(test_refund)
        assert self.payments_object.euro_logs_check(test_last_logs, 'pasta')
        assert self.payments_object.logs_private_check(env, self.base, card_list)

