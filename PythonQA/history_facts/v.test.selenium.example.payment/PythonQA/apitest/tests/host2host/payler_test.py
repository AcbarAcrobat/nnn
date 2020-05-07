import pytest
from uitest.pages.demo.pay_page import PayPage
from uitest.pages.demo.check_page import CheckPage
from uitest.pages.demo.secure_page import SecurePage
from apitest.tests.host2host.common import CommonHost2Host
from apitest.objects.payments.check_object import CheckUrlObject
from selenium.common.exceptions import NoSuchElementException


@pytest.mark.usefixtures('env')
class TestPaylerHost2host:

    @pytest.mark.usefixtures('settings_open')
    def test_settings_edit(self, direction, env):
        settings = self.default_edit.settings()
        payler_settings = self.default_edit.payler_check(env, settings)
        if not payler_settings:
            payler_settings = settings
        new_payler_settings = self.default_edit.payler_change(payler_settings)
        self.default_edit.settings_input(settings_to=new_payler_settings)
        self.default_edit.settings_save()
        assert self.default_edit.save_check()

    def test_h2h_init(self, direction, env):
        self.common = CommonHost2Host()
        global processingUrl, status
        if direction == 'production':
            processingUrl, status = self.common.h2h_init(env, 'RUB', direction)
        else:
            processingUrl, status = self.common.h2h_init(env, 'RUB', pan_card=env['CARD_PAYLER_NUMBER'],
                                                         expires=env['CARD_PAYLER_EXPRIRES'], cvv_card=env['CARD_PAYLER_CVV'])

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_h2h_order(self, direction, env):
        self.check_object = CheckUrlObject(self)
        self.pay_page = PayPage(self.driver)
        self.check_page = CheckPage(self.driver)
        self.secure_page = SecurePage(self.driver)
        self.pay_page.open(processingUrl)
        if direction == 'production':
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
        else:
            assert self.secure_page.at_payler_secure_page()
            self.secure_page.cvv_payler_input(env)
            self.secure_page.secure_payler_submit()
            self.secure_page.secure_payler_return()
        assert self.check_page.check_h2h_status()

    @pytest.mark.usefixtures('metabase', 'old_settings')
    def test_metabase(self, env):
        self.common = CommonHost2Host()
        self.common.metabase(self.base, 'RUB', 'Payler')

