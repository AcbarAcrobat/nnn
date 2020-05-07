import pytest
from uitest.pages.demo.pay_page import PayPage
from uitest.pages.demo.check_page import CheckPage
from uitest.pages.demo.secure_page import SecurePage
from apitest.tests.host2host.common import CommonHost2Host
from apitest.objects.payments.check_object import CheckUrlObject


@pytest.mark.usefixtures('env')
class TestWirecardHost2Host:

    @pytest.mark.usefixtures('settings_open')
    def test_settings_edit(self, direction, env):
        settings = self.default_edit.settings()
        wirecard_settings = self.default_edit.wirecard_check(env, direction, settings)
        self.default_edit.settings_input(settings_to=wirecard_settings)
        self.default_edit.settings_save()
        assert self.default_edit.save_check()

    def test_h2h_init(self, direction, env):
        self.common = CommonHost2Host()
        global processingUrl, status
        if direction == 'production':
            processingUrl, status = self.common.h2h_init(env, 'EUR', direction)
        else:
            processingUrl, status = self.common.h2h_init(env, 'EUR', pan_card=env['CARD_WIRECARD_NUMBER'],
                                                         expires=env['CARD_WIRECARD_EXPRIRES'],
                                                         cvv_card=env['CARD_WIRECARD_CVV'])

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_h2h_order(self, direction, env):
        self.check_object = CheckUrlObject(self)
        self.pay_page = PayPage(self.driver)
        self.check_page = CheckPage(self.driver)
        self.pay_page.open(processingUrl)
        self.secure_page = SecurePage(self.driver)
        if direction == 'production':
            assert self.secure_page.at_epayments_secure_page()
            self.secure_page.sms_epayments_input(env)
        else:
            assert self.secure_page.at_wirecard_secure_page()
            self.secure_page.cvv_wirecard_input(env)
            self.secure_page.secure_wirecard_submit()
        assert self.check_page.check_h2h_status()

    @pytest.mark.usefixtures('metabase', 'old_settings')
    def test_metabase(self, env):
        self.common = CommonHost2Host()
        self.common.metabase(self.base, 'EUR', 'Wirecard')

