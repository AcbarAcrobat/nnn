import pytest
from apitest.objects.proxy.json_object import JsonCreate
from apitest.objects.proxy.signature_object import SignatureCreation
from uitest.pages.demo.pay_page import PayPage
from uitest.pages.proxy.html_page import HtmlPage
from uitest.pages.demo.secure_page import SecurePage
from metabase.table_object import MetaTable
from metabase.proxy.proxy_object import MetaProxyTable
from apitest.objects.payments.check_object import CheckUrlObject
from apitest.objects.proxy.refund_object import RefundProxy
from metabase.refund.refund_object import MetaRefundTable


@pytest.mark.usefixtures('env')
class TestProxy:

    @pytest.mark.skip('Proxy uselessness')
    def test_proxy(self, env):
        self.json_object = JsonCreate(env)
        global amount
        json_data, amount = self.json_object.creation()
        self.signature_object = SignatureCreation()
        input_string = self.signature_object.input_creation(json_data)
        signature = self.signature_object.signature_creation(env, input_string)
        request_json = self.json_object.append(json_data, signature)
        global encoded
        encoded = self.json_object.base(request_json)

    @pytest.mark.skip('Proxy uselessness')
    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_proxy_payment(self, direction, env):
        self.pay_page = PayPage(self.driver)
        self.html_page = HtmlPage(self.driver)
        self.secure_page = SecurePage(self.driver)
        self.html_page.generate(env, encoded)
        self.html_page.open()
        self.pay_page.email_input(env)
        self.pay_page.data_input_qiwi(env, direction)
        self.pay_page.data_submit(env)
        self.secure_page = SecurePage(self.driver)
        self.secure_page.sms_mf_input(env)
        return_url = self.pay_page.proxy_data()
        print(str(return_url))
        self.check_object = CheckUrlObject(return_url)
        data = self.check_object.url_parse()
        global previous_txid
        previous_txid = data['txId']

    @pytest.mark.skip('Proxy uselessness')
    @pytest.mark.usefixtures('metabase')
    def test_proxy_check(self, env):
        self.table_object = MetaTable(self.base)
        card_list = self.table_object.question_list()
        self.proxy_object = MetaProxyTable()
        transaction_query = self.proxy_object.list_division(card_list)
        last_transaction = self.proxy_object.query(self.base, transaction_query)
        assert self.proxy_object.transaction_check(last_transaction, amount)

    @pytest.mark.skip('Proxy uselessness')
    def test_refund(self, env):
        self.json_object = JsonCreate(env)
        json_refund_data = self.json_object.creation_refund(previous_txid)
        self.signature_object = SignatureCreation()
        input_refund_string = self.signature_object.input_refund_creation(json_refund_data)
        refund_signature = self.signature_object.signature_creation(env, input_refund_string)
        global request_refund_json
        request_refund_json = self.json_object.append(json_refund_data, refund_signature)

    @pytest.mark.skip('Proxy uselessness')
    def test_proxy_refund(self, env):
        self.refund_object = RefundProxy()
        answer, response = self.refund_object.refund(env, request_refund_json)
        print(answer, response)
        assert self.refund_object.refund_check(answer, response)

    @pytest.mark.skip('Proxy uselessness')
    @pytest.mark.usefixtures('metabase')
    def test_proxy_metacheck(self):
        self.table_object = MetaTable(self.base)
        card_list = self.table_object.question_list()
        self.refund_object = MetaRefundTable()
        transaction_query, logs_query = self.refund_object.list_division(card_list)
        last_transaction, last_logs = self.refund_object.query(self.base, transaction_query, logs_query)
        self.refund_object = RefundProxy()
        assert self.refund_object.transaction_proxy_refund_check(last_transaction)
        assert self.refund_object.logs_proxy_refund_check(last_logs)

