import pytest
from uitest.pages.demo.pay_page import PayPage
from uitest.pages.demo.check_page import CheckPage
from uitest.pages.demo.demo_other import DemoOther
from uitest.pages.commission.login_page import LoginPage
from uitest.pages.demo.secure_page import SecurePage
from uitest.pages.commission.commissions_page import CommissionsPage
from metabase.table_object import MetaTable
from metabase.commission.commission_object import CommissionObject


@pytest.mark.usefixtures('env')
class TestCommission:

    @pytest.mark.usefixtures('metabase')
    def test_wallets(self, env):
        self.table_object = MetaTable(self.base)
        card_list = self.table_object.question_list()
        self.commission_object = CommissionObject()
        test_rub_wallet_query = self.commission_object.list_division(card_list)
        test_rub_wallet = self.commission_object.query(self.base, test_rub_wallet_query)
        global sys_wallet
        sys_wallet = self.commission_object.wallet_amount(test_rub_wallet)

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_commission_create(self, env):
        self.login_page = LoginPage(self.driver)
        self.login_page.login(env)
        assert self.login_page.at_login_page()
        self.login_page.data_login_input(env)
        self.login_page.data_submit()
        self.commissions_page = CommissionsPage(self.driver)
        self.commissions_page.create(env)
        assert self.commissions_page.at_add_page()
        self.commissions_page.select_user()
        self.commissions_page.select_currency()
        self.commissions_page.rate_field()
        self.commissions_page.select_operation_type()
        self.commissions_page.select_commission_type()
        self.commissions_page.select_account_type()
        self.commissions_page.submit()
        assert self.commissions_page.check_alert()

    @pytest.mark.usefixtures('driver_chrome_headless', 'commission_clear')
    def test_buy(self, direction, env):
        self.demo_other = DemoOther(self.driver)
        self.demo_other.open(env)
        assert self.demo_other.at_main_page()
        self.demo_other.data_cheap_input('RUB')
        self.demo_other.data_currency_input(1000)
        self.demo_other.click_buy_button()
        pay_url = self.demo_other.at_page2(env)
        self.pay_page = PayPage(self.driver)
        self.pay_page.open(pay_url)
        assert self.pay_page.at_main_page()
        self.pay_page.email_input(env)
        self.pay_page.data_input_qiwi(env, direction)
        self.pay_page.data_submit(env)
        self.secure_page = SecurePage(self.driver)
        self.secure_page.sms_mf_input(env)
        self.check_page = CheckPage(self.driver)
        assert self.check_page.check_status()

    @pytest.mark.usefixtures('metabase')
    def test_metacheck(self):
        self.table_object = MetaTable(self.base)
        card_list = self.table_object.question_list()
        self.commission_object = CommissionObject()
        test_rub_wallet_query = self.commission_object.list_division(card_list)
        test_rub_wallet = self.commission_object.query(self.base, test_rub_wallet_query)
        sys_wallet_new = self.commission_object.wallet_amount(test_rub_wallet)
        assert self.commission_object.wallet_check(sys_wallet, sys_wallet_new)

