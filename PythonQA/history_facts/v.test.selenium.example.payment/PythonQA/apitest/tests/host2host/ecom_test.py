import pytest
from uitest.pages.demo.pay_page import PayPage
from uitest.pages.demo.check_page import CheckPage
from uitest.pages.demo.secure_page import SecurePage
from apitest.tests.host2host.common import CommonHost2Host
from apitest.objects.payments.check_object import CheckUrlObject


@pytest.mark.usefixtures('env')
class TestEcomtHost2Host:

    @pytest.mark.usefixtures('settings_open')
    def test_settings_edit(self, direction, env):
        settings = self.default_edit.settings()
        ecom_settings = self.default_edit.ecom(settings)
        self.default_edit.settings_input(settings_to=ecom_settings)
        self.default_edit.settings_save()
        assert self.default_edit.save_check()

    def test_h2h_init(self, direction, env):
        self.common = CommonHost2Host()
        global processingUrl, status
        if direction == 'production':
            processingUrl, status = self.common.h2h_init(env, 'USD', direction)
        else:
            processingUrl, status = self.common.h2h_init(env, 'USD', pan_card=env['CARD_ECOM_NUMBER'],
                                                         expires=env['CARD_EXPRIRES'], cvv_card=env['CARD_CVV'])

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_h2h_order(self, direction, env):
        self.check_object = CheckUrlObject(self)
        self.pay_page = PayPage(self.driver)
        self.check_page = CheckPage(self.driver)
        self.pay_page.open(processingUrl)
        self.secure_page = SecurePage(self.driver)
        try:
            assert self.secure_page.at_ecom_secure_page()
            self.secure_page.cvv_ecom_input()
            self.secure_page.secure_ecom_submit()
        except AssertionError:
            assert self.secure_page.at_epayments_secure_page()
            self.secure_page.sms_epayments_input(env)
        assert self.check_page.check_h2h_status()

    @pytest.mark.usefixtures('metabase', 'old_settings')
    def test_metabase(self, env):
        self.common = CommonHost2Host()
        self.common.metabase(self.base, 'USD', 'Ecomm')


