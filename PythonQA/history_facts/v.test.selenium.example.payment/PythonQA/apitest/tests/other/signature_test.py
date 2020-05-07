import pytest
from apitest.objects.payments.check_object import CheckUrlObject
from apitest.objects.payments.create_object import PostCreate
from apitest.objects.common import CommonData
from apitest.objects.other.signature_object import SignatureObject
from uitest.pages.demo.pay_page import PayPage
from uitest.pages.demo.secure_page import SecurePage


@pytest.mark.usefixtures('env')
class TestCreateSignature:

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_create(self, direction, env):
        self.create_object = PostCreate()
        data, url, headers, currency = self.create_object.data(env, currency='RUB')
        self.common = CommonData()
        answer, response = self.common.post(data, url, headers)
        assert self.create_object.status_code(answer)
        self.check_object = CheckUrlObject(self)
        global token
        currency, amount, processingUrl, token, status = self.check_object.data_return(response)
        self.pay_page = PayPage(self.driver)
        self.pay_page.open(processingUrl)
        assert self.pay_page.at_main_page()
        self.pay_page.email_input(env)
        self.secure_page = SecurePage(self.driver)
        self.pay_page.data_input_qiwi(env, direction)
        self.pay_page.data_submit(env)
        self.secure_page.sms_mf_input(env)
        response_url = self.pay_page.response()
        self.check_object = CheckUrlObject(response_url)
        assert self.check_object.check_url()

    def test_signature(self, env):
        self.signature_object = SignatureObject()
        answer, response = self.signature_object.get_payment_info(env, token)
        value_list, signature_check = self.signature_object.get_values(response)
        signature_string = self.signature_object.string_calculate(value_list)
        signature = self.signature_object.signature_calculate(env, signature_string)
        assert self.signature_object.signature_check(signature_check, signature)

