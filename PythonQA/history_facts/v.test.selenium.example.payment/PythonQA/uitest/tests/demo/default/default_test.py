import pytest
from uitest.pages.demo.pay_page import PayPage
from uitest.pages.demo.secure_page import SecurePage
from uitest.pages.demo.demo_other import DemoOther
from uitest.pages.demo.check_page import CheckPage
from metabase.business_object import ComparisonObject
from metabase.table_object import MetaTable


@pytest.mark.usefixtures('env')
class TestDefault:

    @pytest.mark.usefixtures('settings_open')
    def test_settings_edit(self, direction, env):
        settings = self.default_edit.settings()
        default_settings = self.default_edit.default(settings)
        self.default_edit.settings_input(settings_to=default_settings)
        self.default_edit.settings_save()
        assert self.default_edit.save_check()

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_3ds_buy(self, env):
        TestDefault.buy(self, env, env['CARD_DEFAULT_3DS_NUMBER'], env['CARD_EXPRIRES'])
        self.driver.switch_to.window(self.driver.window_handles[1])
        self.pay_page.default_status('approve')
        self.check_page = CheckPage(self.driver)
        self.driver.switch_to.window(self.driver.window_handles[2])
        assert self.check_page.check_status()

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_3ds_decline_buy(self, env):
        TestDefault.buy(self, env, env['CARD_DEFAULT_3DSD_NUMBER'], env['CARD_EXPRIRES'])
        self.check_page = CheckPage(self.driver)
        assert not self.check_page.check_status()

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_confirmed_buy(self, env):
        TestDefault.buy(self, env, env['CARD_DEFAULT_CONFIRMED_NUMBER'], env['CARD_EXPRIRES'])
        self.check_page = CheckPage(self.driver)
        assert self.check_page.check_status()

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_decline_buy(self, env):
        TestDefault.buy(self, env, env['CARD_DEFAULT_DECLINED_NUMBER'], env['CARD_EXPRIRES'])
        self.check_page = CheckPage(self.driver)
        assert not self.check_page.check_status()

    @pytest.mark.usefixtures('metabase', 'old_settings')
    def test_check(self, env):
        self.table_object = MetaTable(self.base)
        card_list = self.table_object.question_list()
        card_query, transaction_query, logs_query, feed_query, wallet_request_query,\
        entries_query, last_payment_query = self.table_object.list_division(card_list)
        test_last_card, test_last_transaction, test_last_logs, test_last_feed, test_last_wallet_request,\
        test_last_entries, test_last_payment = self.table_object.query(self.base, card_query, transaction_query, logs_query,
                                                    feed_query, wallet_request_query, entries_query, last_payment_query)
        self.business_object = ComparisonObject(test_last_card, test_last_transaction, test_last_logs, test_last_feed,
                                                test_last_wallet_request, test_last_entries, test_last_payment)
        assert self.business_object.logs_h2h_check('default')

    def buy(self, env, card, expires):
        self.demo_other = DemoOther(self.driver)
        self.demo_other.new_tab()
        self.demo_other.open(env)
        assert self.demo_other.at_main_page()
        self.demo_other.data_input('RUB', env)
        self.demo_other.click_buy_button()
        pay_url = self.demo_other.at_page(env)
        self.pay_page = PayPage(self.driver)
        self.pay_page.open(pay_url)
        assert self.pay_page.at_main_page()
        self.pay_page.email_input(env)
        self.pay_page.data_default_input(env, card, expires)
        self.pay_page.data_default_submit()
        self.secure_page = SecurePage(self.driver)
        self.pay_page.response()

