import pytest
from apitest.objects.proxy.json_object import JsonCreate
from apitest.objects.proxy.h2h_object import H2hProxy
from apitest.objects.proxy.signature_object import SignatureCreation
from metabase.table_object import MetaTable
from metabase.refund.refund_object import MetaRefundTable
from uitest.pages.proxy.h2h_page import H2hSecurePage


@pytest.mark.usefixtures('env')
class TestH2hProxy:

    @pytest.mark.skip('Proxy uselessness')
    def test_proxy(self, env):
        self.json_object = JsonCreate(env)
        global amount
        json_data, amount = self.json_object.creation()
        json_h2h_data = self.json_object.creation_h2h(json_data)
        self.signature_object = SignatureCreation()
        input_h2h_string = self.signature_object.input_h2h_creation(json_h2h_data)
        signature = self.signature_object.signature_creation(env, input_h2h_string)
        global request_h2h_json
        request_h2h_json = self.json_object.append(json_h2h_data, signature)

    @pytest.mark.skip('Proxy uselessness')
    def test_h2h_proxy(self, env):
        self.h2h_object = H2hProxy()
        answer, response = self.h2h_object.h2h(env, request_h2h_json)
        global h2h_3ds_link
        h2h_3ds_link = self.h2h_object.h2h_3ds_link(response)
        assert self.h2h_object.h2h_check(answer, response)

    @pytest.mark.skip('Proxy uselessness')
    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_h2h_3ds(self, env):
        self.h2h_page = H2hSecurePage(self.driver)
        self.h2h_page.open(h2h_3ds_link)
        assert self.h2h_page.at_secure_page()
        self.h2h_page.cvv_input(env)
        self.h2h_page.secure_submit()

    @pytest.mark.skip('Proxy uselessness')
    @pytest.mark.usefixtures('metabase')
    def test_proxy_h2h_metacheck(self, env):
        self.table_object = MetaTable(self.base)
        card_list = self.table_object.question_list()
        self.refund_object = MetaRefundTable()
        transaction_query, logs_query = self.refund_object.list_division(card_list)
        last_transaction, last_logs = self.refund_object.query(self.base, transaction_query, logs_query)
        self.h2h_object = H2hProxy()
        assert self.h2h_object.h2h_transaction_check(last_transaction, amount)
        assert self.h2h_object.h2h_logs_check(last_logs)

