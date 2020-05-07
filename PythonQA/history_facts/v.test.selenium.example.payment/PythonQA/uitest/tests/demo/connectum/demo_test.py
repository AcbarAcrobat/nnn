import pytest
import datetime
from uitest.pages.demo.pay_page import PayPage
from uitest.pages.demo.check_page import CheckPage
from uitest.pages.demo.demo_other import DemoOther
from uitest.pages.demo.secure_page import SecurePage
from uitest.pages.office.login_page import LoginPage
from uitest.pages.office.payments_page import PaymentsPage
from apitest.objects.payments.check_object import CheckUrlObject
from metabase.table_object import MetaTable
from metabase.payments.payments_object import PaymentsObject


@pytest.mark.usefixtures('env')
class TestConnectumBuy:

    @pytest.mark.usefixtures('settings_open')
    def test_settings_edit(self, direction, env):
        settings = self.default_edit.settings()
        connectum_settings = self.default_edit.connectum_check(env, settings)
        if not connectum_settings:
            connectum_settings = settings
        new_connectum_settings = self.default_edit.connectum_change(connectum_settings)
        self.default_edit.settings_input(settings_to=new_connectum_settings)
        print(str(new_connectum_settings))
        self.default_edit.settings_save()
        assert self.default_edit.save_check()

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_buy(self, direction, env):
        self.demo_other = DemoOther(self.driver)
        self.pay_page = PayPage(self.driver)
        self.secure_page = SecurePage(self.driver)
        self.check_page = CheckPage(self.driver)
        self.demo_other.open(env)
        assert self.demo_other.at_main_page()
        self.demo_other.data_input('USD', env)
        self.demo_other.click_buy_button()
        pay_url = self.demo_other.at_page2(env)
        self.pay_page.open(pay_url)
        assert self.pay_page.at_main_page()
        self.pay_page.data_input(env, direction)
        self.pay_page.email_input(env)
        self.pay_page.data_submit(env)
        assert self.pay_page.connectum_status()
        global response_url
        response_url = self.pay_page.response()

    @pytest.mark.usefixtures('metabase')
    def test_payment_check(self, env):
        self.check_object = CheckUrlObject(response_url)
        print('\n response_url: ' + str(response_url))
        assert self.check_object.check_url()
        self.table_object = MetaTable(self.base)
        card_list = self.table_object.question_list()
        self.payments_object = PaymentsObject()
        test_last_transaction_query, logs_query = self.payments_object.list_division(card_list)
        test_last_logs, test_last_transactions = self.payments_object.query(self.base,
                                                                            test_last_transaction_query, logs_query)
        assert self.payments_object.payment_check(test_last_transactions)
        assert self.payments_object.callback_check(test_last_logs)

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
    def test_refund_check(self, env):
        self.table_object = MetaTable(self.base)
        self.payments_object = PaymentsObject()
        card_list = self.table_object.question_list()
        self.payments_object = PaymentsObject()
        test_last_transaction_query, logs_query = self.payments_object.list_division(card_list)
        test_last_logs, test_last_transactions = self.payments_object.query(self.base, test_last_transaction_query, logs_query)
        assert self.payments_object.refund_transaction_check(test_last_transactions)
        assert self.payments_object.refund_logs_check(test_last_logs)
        assert self.payments_object.logs_private_check(env, self.base, card_list)

