import pytest
import datetime
from metabase.table_object import MetaTable
from uitest.pages.demo.pay_page import PayPage
from uitest.pages.demo.secure_page import SecurePage
from uitest.pages.demo.demo_other import DemoOther
from uitest.pages.demo.check_page import CheckPage
from uitest.pages.office.login_page import LoginPage
from uitest.pages.office.payments_page import PaymentsPage
from selenium.common.exceptions import NoSuchElementException
from metabase.refund.refund_object import MetaRefundTable


@pytest.mark.usefixtures('env')
class TestRfiBuy:

    @pytest.mark.skip('banned from rfi/rfi-partner')
    @pytest.mark.usefixtures('settings_open')
    def test_settings_edit(self, direction, env):
        settings = self.default_edit.settings()
        rfi_settings = self.default_edit.rfi_check(env, settings, 'rfi')
        if not rfi_settings:
            rfi_settings = settings
        new_rfi_settings = self.default_edit.rfi_change(rfi_settings, 'rfi')
        self.default_edit.settings_input(settings_to=new_rfi_settings)
        self.default_edit.settings_save()
        assert self.default_edit.save_check()

    @pytest.mark.skip('banned from rfi/rfi-partner')
    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_buy(self, env):
        self.demo_other = DemoOther(self.driver)
        self.secure_page = SecurePage(self.driver)
        self.pay_page = PayPage(self.driver)
        self.check_page = CheckPage(self.driver)
        self.demo_other.open(env)
        assert self.demo_other.at_main_page()
        self.demo_other.data_cheap_input('RUB')
        self.demo_other.click_buy_button()
        pay_url = self.demo_other.at_page2(env)
        self.pay_page.open(pay_url)
        assert self.pay_page.at_main_page()
        self.pay_page.email_input(env)
        self.pay_page.data_input_rfi(env)
        self.pay_page.data_submit(env)
        try:
            self.check_page.check_status()
        except NoSuchElementException:
            assert self.secure_page.at_mf_secure_page()
            sms = self.pay_page.sms_input(env)
            self.secure_page.cvv_mf_input(sms)
            self.secure_page.secure_mf_submit()
            try:
                self.check_page.check_status()
            except NoSuchElementException:
                sms = self.pay_page.sms_input(env)
                self.secure_page.cvv_mf_input(sms)
                self.secure_page.secure_mf_submit()
        assert self.check_page.check_status()

    @pytest.mark.skip('banned from rfi/rfi-partner')
    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_refund(self, env, driver_chrome_headless):
        self.login_page = LoginPage(driver_chrome_headless)
        self.payments_page = PaymentsPage(driver_chrome_headless)
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

    @pytest.mark.skip('banned from rfi/rfi-partner')
    @pytest.mark.usefixtures('metabase', 'old_settings')
    def test_check(self, env):
        self.table_object = MetaTable(self.base)
        card_list = self.table_object.question_list()
        self.refund_object = MetaRefundTable()
        transaction_query, logs_query = self.refund_object.list_division(card_list)
        test_last_transaction, test_last_logs = self.refund_object.query(self.base, transaction_query, logs_query)
        assert self.refund_object.transaction_check(test_last_transaction)
        assert self.refund_object.logs_check(test_last_logs)

