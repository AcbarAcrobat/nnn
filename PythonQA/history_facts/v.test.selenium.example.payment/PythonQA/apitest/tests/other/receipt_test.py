import pytest
from apitest.objects.payments.check_object import CheckUrlObject
from apitest.objects.payments.create_object import PostCreate
from apitest.objects.common import CommonData


@pytest.mark.usefixtures('env')
class TestMailReceipt:

    def test_create(self, direction, env):
        self.common = CommonData()
        self.create_object = PostCreate()
        self.check_object = CheckUrlObject(self)
        global temp_email_key, response
        temp_email, temp_email_key = self.create_object.temp_email(env)
        data, url, headers, currency = self.create_object.data(env, currency='RUB')
        card = self.create_object.card_object(env, direction, currency='RUB')
        data_customers, test_email = self.create_object.data_customers(env, data, card, email=temp_email)
        answer, response = self.common.post(data_customers, url, headers)
        assert self.create_object.status_code(answer)

    def test_check(self, env):
        self.check_object = CheckUrlObject(self)
        currency, amount, processingUrl, token, status = self.check_object.data_return(response)
        assert self.check_object.payment_status(status)
        message = self.check_object.temp_email(env, temp_email_key)
        assert self.check_object.temp_email_check(message)

