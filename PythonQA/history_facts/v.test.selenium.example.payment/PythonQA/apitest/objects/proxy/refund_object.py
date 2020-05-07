import json
import ast
from apitest.objects.common import CommonData


class RefundProxy:

    def refund(self, env, request_refund_json):
        self.common = CommonData()
        answer, response = self.common.post_loads(data=request_refund_json,
                                                  url=env['PROXY'] + '/api/v1/refund', headers='')
        return answer, response

    def refund_check(self, answer, response):
        data = json.dumps(ast.literal_eval(str(response)))
        return True if answer.status_code == 200 \
                       and 'completed successfully' in str(json.loads(str(data))['result']['message']) else False

    def transaction_proxy_refund_check(self, last_transaction):
        data = json.dumps(ast.literal_eval(str(last_transaction)))
        print(str(data))
        for list in range(0, 2):
            operation_type = json.loads(str(data))[list]['operation_type']
            if 'refund' in operation_type:
                refund = json.loads(str(data))[list]
        print(refund['status'])
        print(str(refund['amount']))
        return True if 'approved' in refund['status'] and '1000' == str(refund['amount']) else False

    def logs_proxy_refund_check(self, last_logs):
        data = json.dumps(ast.literal_eval(str(last_logs)))
        for search in range(0, 3):
            kind = json.loads(str(data))[search]['kind']
            if kind == 'refund':
                gateway_status = json.loads(str(data))[search]['status']
                gateway_request = json.loads(str(data))[search]['request']
            else:
                notification_request = json.loads(str(data))[search]['request']
        return True if '10' in str(notification_request) and str(gateway_status) == '200' \
                       and '10' in str(gateway_request) else False

