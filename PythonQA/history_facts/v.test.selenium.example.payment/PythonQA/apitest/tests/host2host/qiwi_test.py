import pytest
from uitest.pages.demo.pay_page import PayPage
from uitest.pages.demo.check_page import CheckPage
from uitest.pages.demo.secure_page import SecurePage
from apitest.tests.host2host.common import CommonHost2Host
from apitest.objects.payments.check_object import CheckUrlObject


@pytest.mark.usefixtures('env')
class TestQiwiHost2host:

    @pytest.mark.usefixtures('settings_open')
    def test_settings_edit(self, direction, env):
        settings = self.default_edit.settings()
        h2h_settings = self.default_edit.host2host(settings)
        qiwi_settings, qiwi_key = self.default_edit.qiwi_check(env, h2h_settings)
        self.default_edit.settings_input(settings_to=qiwi_settings)
        self.default_edit.settings_save()
        assert self.default_edit.save_check()
        if not qiwi_key:
            raise KeyError('No key assets for QIWI gateway')

    def test_h2h_init(self, direction, env):
        self.common = CommonHost2Host()
        global processingUrl, status
        if direction == 'production':
            processingUrl, status = self.common.h2h_init(env, 'RUB', direction)
        else:
            processingUrl, status = self.common.h2h_init(env, 'RUB', pan_card=env['CARD_NUMBER'],
                                                         expires=env['CARD_QIWI_EXPRIRES'], cvv_card=env['CARD_CVV'])

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_h2h_order(self, direction, env):
        self.check_object = CheckUrlObject(self)
        self.pay_page = PayPage(self.driver)
        self.check_page = CheckPage(self.driver)
        if direction == 'production':
            self.pay_page.open(processingUrl)
            assert self.pay_page.at_main_page()
            self.secure_page = SecurePage(self.driver)
            self.secure_page.sms_mf_input(env)
            self.check_page = CheckPage(self.driver)
            assert self.check_page.check_status()
        else:
            assert self.check_object.payment_status(status)

    @pytest.mark.usefixtures('metabase', 'old_settings')
    def test_metabase(self, env):
        self.common = CommonHost2Host()
        self.common.metabase(self.base, 'RUB', 'Qiwi')

