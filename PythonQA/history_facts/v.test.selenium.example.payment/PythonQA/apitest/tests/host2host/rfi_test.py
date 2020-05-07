import pytest
from uitest.pages.demo.pay_page import PayPage
from uitest.pages.demo.check_page import CheckPage
from uitest.pages.demo.secure_page import SecurePage
from apitest.tests.host2host.common import CommonHost2Host
from apitest.objects.payments.check_object import CheckUrlObject
from selenium.common.exceptions import NoSuchElementException


@pytest.mark.usefixtures('env')
class TestRfiHost2host:

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

    def test_h2h_init(self, direction, env):
        self.common = CommonHost2Host()
        global processingUrl, status
        processingUrl, status = self.common.h2h_init(env, 'RUB', direction='production')

    @pytest.mark.skip('banned from rfi/rfi-partner')
    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_h2h_order(self, direction, env):
        self.check_object = CheckUrlObject(self)
        self.pay_page = PayPage(self.driver)
        self.check_page = CheckPage(self.driver)
        self.secure_page = SecurePage(self.driver)
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
    @pytest.mark.usefixtures('metabase', 'old_settings')
    def test_metabase(self, env):
        self.common = CommonHost2Host()
        self.common.metabase(self.base, 'RUB', 'rfi')

