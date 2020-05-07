import pytest
from uitest.pages.demo.pay_page import PayPage
from uitest.pages.demo.check_page import CheckPage
from uitest.pages.demo.demo_other import DemoOther
from uitest.pages.demo.secure_page import SecurePage
from uitest.pages.office.login_page import LoginPage
from uitest.pages.office.payments_page import PaymentsPage
from metabase.conversion.conversion_object import MetaConversionObject
from metabase.table_object import MetaTable


@pytest.mark.usefixtures('env')
class TestConversion:

    @pytest.mark.usefixtures('settings_open')
    def test_settings_edit(self, direction, env):
        settings = self.default_edit.settings()
        settings_rub = self.default_edit.convert_change(settings)
        self.default_edit.settings_input(settings_to=settings_rub)
        self.default_edit.settings_save()
        assert self.default_edit.save_check()

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_convert_buy(self, direction, env):
        self.secure_page = SecurePage(self.driver)
        self.demo_other = DemoOther(self.driver)
        self.check_page = CheckPage(self.driver)
        self.pay_page = PayPage(self.driver)
        currency_list = ('GBP', 'CAD')
        for currency in currency_list:
            self.demo_other.new_tab()
            self.demo_other.open(env)
            assert self.demo_other.at_main_page()
            self.demo_other.data_input(currency, env)
            self.demo_other.click_buy_button()
            pay_url = self.demo_other.at_page(env)
            self.pay_page.open(pay_url)
            assert self.pay_page.at_main_page()
            self.pay_page.email_input(env)
            self.pay_page.data_input_qiwi(env, direction)
            self.pay_page.data_submit(env)
            if direction == 'production':
                assert self.secure_page.at_mf_secure_page()
                self.secure_page.sms_mf_input(env)
            assert self.check_page.check_status()
            self.driver.close()
            self.driver.switch_to.window(self.driver.window_handles[0])

    @pytest.mark.usefixtures('metabase')
    def test_conversion_check(self, env):
        self.table_object = MetaTable(self.base)
        card_list = self.table_object.question_list()
        self.conversion_object = MetaConversionObject()
        transactions_query, feeds_query, entries_query = self.conversion_object.list_division(card_list)
        test_last_three_transactions, test_last_three_feeds, test_last_three_entries = self.conversion_object.\
            query(self.base, transactions_query, feeds_query, entries_query)
        amount_gbp, amount_cad = self.conversion_object.transactions_check(test_last_three_transactions)
        assert amount_gbp and amount_cad
        assert self.conversion_object.conversation_check(env, amount_gbp, amount_cad)
        assert self.conversion_object.feed_check(test_last_three_feeds, amount_gbp, amount_cad)

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_conversion_refund(self, env):
        self.payments_page = PaymentsPage(self.driver)
        self.login_page = LoginPage(self.driver)
        self.login_page.login(env)
        self.login_page.data_input(env)
        self.login_page.data_submit()
        self.payments_page.open(env)
        assert self.payments_page.on_page()
        self.payments_page.refund_submit()
        amount = self.payments_page.refund_amount()
        self.payments_page.refund_partial_amount(amount)
        assert self.payments_page.alert_check()
        assert self.payments_page.refund_amount_check(amount)
        assert self.payments_page.office_refund_check()
