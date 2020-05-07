import pytest
from apitest.objects.payments.check_object import CheckUrlObject
from apitest.objects.payments.create_object import PostCreate
from apitest.objects.common import CommonData
from metabase.table_object import MetaTable
from metabase.other.customer_info_object import CustomerInfoTable
from uitest.pages.demo.pay_page import PayPage
from uitest.pages.demo.secure_page import SecurePage


@pytest.mark.usefixtures('env')
class TestCustomerInfo:

    def test_create(self, env):
        self.create_object = PostCreate()
        global data, url, headers, processingUrl
        data, url, headers, currency = self.create_object.data(env, currency='RUB')
        processingUrl = TestCustomerInfo.create(self, data, url, headers)

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_buy_check(self, direction, env):
        email_check, response_url = TestCustomerInfo.buy(self, direction, env, processingUrl)
        self.check_object = CheckUrlObject(response_url)
        assert self.check_object.email_presence(email_check)
        assert self.check_object.check_url()

    def test_customer_create(self, env):
        self.create_object = PostCreate()
        global processingUrl_customer, test_email
        data_customers, test_email = self.create_object.data_customers(env, data)
        processingUrl_customer = TestCustomerInfo.create(self, data_customers, url, headers)

    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_customer_buy(self, direction, env):
        email_check, response_url = TestCustomerInfo.buy(self, direction, env, processingUrl_customer)
        self.check_object = CheckUrlObject(response_url)
        assert not self.check_object.email_presence(email_check)
        assert self.check_object.check_url()

    @pytest.mark.usefixtures('metabase')
    def test_metacheck(self, env):
        self.table_object = MetaTable(self.base)
        card_list = self.table_object.question_list()
        print('\n Card ' + str(card_list))
        self.customer_info_object = CustomerInfoTable()
        test_last_two_leads_query, test_last_two_profiles_query = self.customer_info_object.leads_division(card_list)
        test_last_two_leads = self.customer_info_object.leads_query(self.base, test_last_two_leads_query)
        test_last_two_profiles = self.customer_info_object.profiles_query(self.base, test_last_two_profiles_query)
        assert self.customer_info_object.customer_lead_check(env, test_last_two_leads, test_email)
        assert self.customer_info_object.customer_profiles_check(env, test_last_two_profiles, test_email)

    def buy(self, direction, env, url):
        self.pay_page = PayPage(self.driver)
        self.secure_page = SecurePage(self.driver)
        self.pay_page.open(url)
        email_check = self.pay_page.email_input(env)
        self.pay_page.data_input_qiwi(env, direction)
        self.pay_page.data_submit(env)
        self.secure_page.sms_mf_input(env)
        response_url = self.pay_page.response()
        return email_check, response_url

    def create(self, data, url, headers):
        self.common = CommonData()
        answer, response = self.common.post(data, url, headers)
        assert self.create_object.status_code(answer)
        global currency, amount, processingUrl
        self.check_object = CheckUrlObject(self)
        currency, amount, processingUrl, token, status = self.check_object.data_return(response)
        return processingUrl

