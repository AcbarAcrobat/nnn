import pytest
from apitest.objects.payments.check_object import CheckUrlObject
from apitest.objects.other.callback_object import CallbackObject
from apitest.objects.common import CommonData
from uitest.pages.office.login_page import LoginPage
from uitest.pages.demo.pay_page import PayPage
from uitest.pages.demo.secure_page import SecurePage
from uitest.pages.office.payments_page import PaymentsPage


@pytest.mark.usefixtures('env')
class TestCallback:

    def test_create(self, env):
        self.callback_object = CallbackObject()
        global headers, processingUrl, token, currency, amount, webhook_token
        webhook_token = self.callback_object.webhook(env)
        data, url, headers = self.callback_object.data(env, webhook_token)
        self.common = CommonData()
        answer, response = self.common.post(data, url, headers)
        assert self.callback_object.status_code(answer)
        self.check_object = CheckUrlObject(self)
        currency, amount, processingUrl, token, status = self.check_object.data_return(response)

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_buy(self, direction, env):
        self.pay_page = PayPage(self.driver)
        self.secure_page = SecurePage(self.driver)
        self.pay_page.open(processingUrl)
        assert self.pay_page.at_main_page()
        self.pay_page.email_input(env)
        self.pay_page.data_input_qiwi(env, direction)
        self.pay_page.data_submit(env)
        self.secure_page.sms_mf_input(env)
        global response_url
        response_url = self.pay_page.response()
        self.pay_page.open(response_url)

    def test_callback_check(self, env):
        self.check_object = CheckUrlObject(response_url)
        self.callback_object = CallbackObject()
        assert self.check_object.check_url()
        content = self.callback_object.callback_send_check(env, webhook_token, 0)
        assert self.callback_object.callback_check(content, token, currency, amount)

    def test_recallback(self, env):
        self.callback_object = CallbackObject()
        answer, response_callback = self.callback_object.callback_send(env, token)
        assert self.callback_object.status_code(answer)
        content = self.callback_object.callback_send_check(env, webhook_token, 1)
        assert self.callback_object.callback_check(content, token, currency, amount)

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_office_callback(self, env):
        self.payments_page = PaymentsPage(self.driver)
        self.login_page = LoginPage(self.driver)
        self.callback_object = CallbackObject()
        self.login_page.login(env)
        assert self.login_page.at_login_page()
        self.login_page.data_input(env)
        self.login_page.data_submit()
        self.payments_page.open(env)
        assert self.payments_page.on_page()
        status = self.payments_page.last_status()
        if 'accepted' in status:
            self.payments_page.refund_submit()
            self.payments_page.refund_full_amount()
            assert self.payments_page.alert_check()
        content = self.callback_object.callback_send_check(env, webhook_token, 2)
        assert self.callback_object.callback_refund_check(content, currency, amount)
        self.payments_page.open(env)
        self.payments_page.resend_notification()
        assert self.payments_page.notification_check()
        content = self.callback_object.callback_send_check(env, webhook_token, 3)
        assert self.callback_object.callback_refund_check(content, currency, amount)

