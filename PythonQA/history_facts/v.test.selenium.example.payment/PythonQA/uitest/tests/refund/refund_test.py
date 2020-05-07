import pytest
import datetime
from selenium.common import exceptions
from uitest.pages.demo.pay_page import PayPage
from uitest.pages.demo.demo_other import DemoOther
from uitest.pages.demo.secure_page import SecurePage
from uitest.pages.office.login_page import LoginPage
from uitest.pages.office.payments_page import PaymentsPage
from metabase.table_object import MetaTable
from metabase.refund.refund_object import MetaRefundTable


@pytest.mark.usefixtures('env')
class TestRefund:

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_refund_buy(self, direction, env):
        TestRefund.refund_buy(self, direction, env, driver=self.driver)

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_full_refund(self, env):
        status, date = TestRefund.refund(self, env, driver=self.driver)
        if 'accepted' in status and datetime.datetime.now().strftime('%d.%m.%Y') in date:
            self.payments_page.refund_submit()
            self.payments_page.refund_full_amount()
            assert self.payments_page.alert_check()
        else:
            print('Failed payment. Test will stop')
            self.driver.close()

    @pytest.mark.usefixtures('metabase')
    def test_refund_metabase_check(self):
        TestRefund.refund_check(self, self.base)

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_second_refund_buy(self, direction, env):
        TestRefund.refund_buy(self, direction, env, driver=self.driver)

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_partial_refund(self, env):
        status, date = TestRefund.refund(self, env, driver=self.driver)
        if 'accepted' in status and datetime.datetime.now().strftime('%d.%m.%Y') in date:
            self.payments_page.refund_submit()
            amount = self.payments_page.refund_amount()
            self.payments_page.refund_partial_amount(amount)
            assert self.payments_page.alert_check()
            assert self.payments_page.refund_amount_check(amount)
        else:
            print('Failed payment. Test will stop')
            self.driver.close()

    @pytest.mark.usefixtures('metabase')
    def test_partial_refund_metabase_check(self):
        TestRefund.refund_check(self, self.base)

    def refund_buy(self, direction, env, driver):
        self.demo_other = DemoOther(driver)
        self.secure_page = SecurePage(driver)
        self.pay_page = PayPage(driver)
        self.demo_other.new_tab()
        self.demo_other.open(env)
        assert self.demo_other.at_main_page()
        self.demo_other.data_input('RUB', env)
        self.demo_other.click_buy_button()
        pay_url = self.demo_other.at_page(env)
        self.pay_page.open(pay_url)
        assert self.pay_page.at_main_page()
        self.pay_page.email_input(env)
        self.pay_page.data_input_qiwi(env, direction)
        self.pay_page.data_submit(env)
        self.secure_page.sms_mf_input(env)
        try:
            self.secure_page.cvv_input(env)
            self.secure_page.secure_submit()
        except exceptions.NoSuchElementException:
            pass

    def refund(self, env, driver):
        self.login_page = LoginPage(driver)
        self.payments_page = PaymentsPage(driver)
        self.login_page.login(env)
        assert self.login_page.at_login_page()
        self.login_page.data_input(env)
        self.login_page.data_submit()
        self.payments_page.open(env)
        assert self.payments_page.on_page()
        status = self.payments_page.last_status()
        date = self.payments_page.payment_date()
        return status, date

    def refund_check(self, base):
        self.table_object = MetaTable(base)
        card_list = self.table_object.question_list()
        self.refund_object = MetaRefundTable()
        transaction_query, logs_query = self.refund_object.list_division(card_list)
        test_last_transaction, test_last_logs = self.refund_object.query(base, transaction_query, logs_query)
        assert self.refund_object.transaction_check(test_last_transaction)
        assert self.refund_object.logs_check(test_last_logs)

