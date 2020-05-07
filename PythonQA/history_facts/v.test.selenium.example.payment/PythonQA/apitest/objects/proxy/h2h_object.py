import json
import ast
from apitest.objects.common import CommonData


class H2hProxy:

    def h2h(self, env, request_h2h_json):
        self.common = CommonData()
        answer, response = self.common.post_loads(data=request_h2h_json,
                                                  url=env['PROXY'] + '/api/v1/h2h', headers='')
        return answer, response

    def h2h_3ds_link(self, response):
        data = json.dumps(ast.literal_eval(str(response)))
        auth_3d_url = str(json.loads(str(data))['auth3DUrl'])
        return auth_3d_url

    def h2h_check(self, answer, response):
        data = json.dumps(ast.literal_eval(str(response)))
        return True if answer.status_code == 200 \
                       and 'Redirect to issuer for 3D authentication' in \
                       str(json.loads(str(data))['result']['message']) else False

    def h2h_transaction_check(self, last_transaction, amount):
        data = json.dumps(ast.literal_eval(str(last_transaction)))
        payment_status = json.loads(str(data))[0]['status']
        payment_amount = json.loads(str(data))[0]['amount']
        return True if 'approved' in payment_status and \
                       int(amount) == int(payment_amount)/100 else False

    def h2h_logs_check(self, last_logs):
        data = json.dumps(ast.literal_eval(str(last_logs)))
        payment_id_list = []
        status_list = []
        for id in range(0, 3):
            payment_id_list.append(json.loads(str(data))[id]['payment_id'])
        for list in range(0, 3):
            status_list.append(json.loads(str(data))[list]['status'])
        return True if len(set(payment_id_list)) == 1 and '200' in status_list else False

