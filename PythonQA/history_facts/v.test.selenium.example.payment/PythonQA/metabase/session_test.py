import pytest
import requests
from time import sleep


@pytest.mark.usefixtures('env')
class TestMetabaseSession:

    @pytest.mark.slow
    def test_metabase_session(self, env):
        payload = {'username': env['METABASE_EMAIL'],
                   'password': env['METABASE_PASSWORD']}
        for retry in range(0, 6):
            res = requests.post(env['METABASE_ENPOINT'] + '/session', json=payload)
            if res.status_code == 200:
                data = res.json()
                session_id = data['id']
                print('SessionID: ' + str(session_id))
                return session_id
            elif res.status_code == 500:
                pass
            elif res.status_code == 400:
                print('Metabase 400 ERROR. Wait 120s...')
                sleep(120)
            else:
                raise Exception(res)

