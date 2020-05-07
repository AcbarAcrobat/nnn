import pytest
from uitest.pages.demo.pay_page import PayPage
from uitest.pages.demo.secure_page import SecurePage
from uitest.pages.demo.demo_other import DemoOther
from uitest.pages.demo.check_page import CheckPage
from metabase.table_object import MetaTable
from metabase.business_object import ComparisonObject
from selenium.common.exceptions import NoSuchElementException
from metabase.payments.payments_object import PaymentsObject


@pytest.mark.usefixtures('env')
class TestRfiPartnerBuy:

    @pytest.mark.skip('banned from rfi/rfi-partner')
    @pytest.mark.usefixtures('settings_open')
    def test_settings_edit(self, direction, env):
        settings = self.default_edit.settings()
        rfi_settings = self.default_edit.rfi_check(env, settings, 'rfi_partner')
        if not rfi_settings:
            rfi_settings = settings
        new_rfi_settings = self.default_edit.rfi_change(rfi_settings, 'rfi_partner')
        self.default_edit.settings_input(settings_to=new_rfi_settings)
        self.default_edit.settings_save()
        assert self.default_edit.save_check()

    @pytest.mark.skip('banned from rfi/rfi-partner')
    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_buy(self, env):
        self.demo_other = DemoOther(self.driver)
        self.demo_other.open(env)
        assert self.demo_other.at_main_page()
        self.demo_other.data_cheap_input('RUB')
        self.demo_other.click_buy_button()
        pay_url = self.demo_other.at_page2(env)
        self.pay_page = PayPage(self.driver)
        self.pay_page.open(pay_url)
        assert self.pay_page.at_main_page()
        self.pay_page.email_input(env)
        self.pay_page.data_input_rfi(env)
        self.pay_page.data_submit(env)
        self.check_page = CheckPage(self.driver)
        try:
            self.check_page.check_status()
        except NoSuchElementException:
            self.secure_page = SecurePage(self.driver)
            assert self.secure_page.at_mf_secure_page()
            self.check_page = CheckPage(self.driver)
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
    @pytest.mark.usefixtures('metabase', 'old_settings')
    def test_metabase(self, env):
        self.table_object = MetaTable(self.base)
        self.payments_object = PaymentsObject()
        global card_list
        card_list = self.table_object.question_list()
        card_query, transaction_query, logs_query, \
        feed_query, wallet_request_query, entries_query = self.table_object.list_division(card_list)
        global test_last_card, test_last_transaction, test_last_logs, test_last_feed, test_last_wallet_request, test_last_entries
        test_last_card, test_last_transaction, test_last_logs, test_last_feed, test_last_wallet_request, test_last_entries = self.table_object.\
            query(self.base, card_query, transaction_query, logs_query, feed_query, wallet_request_query, entries_query)

    @pytest.mark.skip('banned from rfi/rfi-partner')
    def test_metatest(self, env):
        self.business_object = ComparisonObject(test_last_card, test_last_transaction, test_last_logs,
                                                test_last_feed, test_last_wallet_request, test_last_entries)
        assert self.business_object.card_megafon_check(env)
        assert self.business_object.transaction_rfi_check()
        assert self.business_object.logs_rfi_check()
        assert self.business_object.wallet_request_check()
        assert self.business_object.entries_check()
        assert self.payments_object.logs_private_check(env, self.base, card_list)



