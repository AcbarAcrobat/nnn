import json
from selenium.common.exceptions import TimeoutException, NoSuchElementException
from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


class DefaultSetting:

    def __init__(self, driver):
        self.driver = driver

    def login_open(self, env, protocol, direction):
        if 'production' in direction:
            self.driver.get(protocol + '://' + env['SETTINGS_LOGIN_PROD'] + ':' +
                            env['SETTINGS_PASS_PROD'] + '@' + env['SETTINGS_URL2'])
        else:
            self.driver.get(protocol + '://' + env['SETTINGS_LOGIN'] + ':' +
                            env['SETTINGS_LOGIN'] + '@' + env['SETTINGS_URL2'])

    def settings_open(self, env):
        self.driver.get(env['SETTINGS_URL'] + 'admin/default_user/1/edit')
        try:
            self.driver.find_element(By.CLASS_NAME, 'alert')
            self.driver.get(env['SETTINGS_URL'] + 'admin/user/31/edit')
        except NoSuchElementException:
            pass
        return self

    def at_settings_page(self):
        return "Settings Admin" in self.driver.title

    def settings(self):
        try:
            settings = self.driver.find_element(By.NAME, 'default_user[settings]').text
        except NoSuchElementException:
            settings = self.driver.find_element(By.NAME, 'user[settings]').text
        return settings

    def rub_delete(self, settings):
        old_settings = json.loads(settings)
        del old_settings['RUB']
        settings_without_rub = json.dumps(old_settings)
        return settings_without_rub, old_settings

    def rub_default(self, settings):
        data = json.loads(str(settings))
        data['RUB']['gateways']['pay']['default'] = 'qiwi'
        qiwi_settings = json.dumps(data)
        return qiwi_settings

    def default(self, settings):
        data = json.loads(str(settings))
        data['RUB']['gateways']['pay']['default'] = 'default'
        default_settings = json.dumps(data)
        return default_settings

    def ecom(self, settings):
        data = json.loads(str(settings))
        data['USD']['gateways']['pay']['default'] = 'ecomm'
        default_settings = json.dumps(data)
        return default_settings

    def usd_default(self, settings):
        data = json.loads(str(settings))
        data['USD']['gateways']['pay']['default'] = 'millikart'
        millikart_settings = json.dumps(data)
        return millikart_settings

    def qiwi_check(self, env, settings):
        data = json.loads(str(settings))
        gateways_list = []
        for gate in data['gateways']:
            gateways_list.append(gate)
        if 'qiwi' in gateways_list:
            try:
                test = data['gateways']['qiwi']['visa']['asset_path']
                if 'test' in test:
                    qiwi_key = False
                else:
                    qiwi_key = True
            except KeyError:
                data['gateways']['qiwi']['mir']['asset_path'] = 'test'
                data['gateways']['qiwi']['mir']['asset_secret'] = env['QIWI_SECRET']
                data['gateways']['qiwi']['visa']['asset_path'] = 'test'
                data['gateways']['qiwi']['visa']['asset_secret'] = env['QIWI_SECRET']
                data['gateways']['qiwi']['mastercard']['asset_path'] = 'test'
                data['gateways']['qiwi']['mastercard']['asset_secret'] = env['QIWI_SECRET']
                data['gateways']['qiwi']['maestro']['asset_path'] = 'test'
                data['gateways']['qiwi']['maestro']['asset_secret'] = env['QIWI_SECRET']
                qiwi_key = False
            qiwi_settings = json.dumps(data)
        return qiwi_settings, qiwi_key

    def abb_check(self, env, settings):
        data = json.loads(str(settings))
        gateways_list = []
        for gate in data['gateways']:
            gateways_list.append(gate)
        if 'abb' not in gateways_list:
            data['gateways']['abb'] = {"password": env['SETTINGS']['ABB']['ABB_PASSWORD'],
                                       "username": env['SETTINGS']['ABB']['ABB_USERNAME']}
        data['USD']['gateways']['pay']['default'] = 'abb'
        abb_settings = json.dumps(data)
        return abb_settings

    def wirecard_check(self, env, direction, settings):
        data = json.loads(str(settings))
        gateways_list = []
        for gate in data['gateways']:
            gateways_list.append(gate)
        if 'wirecard' not in gateways_list:
            if direction == 'production':
                pass  # settings for production
            else:
                data['gateways']['wirecard'] = \
                    {"visa":
                        {"password": env['SETTINGS']['WIRECARD']['WIRECARD_PASSWORD'],
                         "username": env['SETTINGS']['WIRECARD']['WIRECARD_USERNAME'],
                         "country_code": "RU",
                         "allow_non_3ds": True,
                         "business_case_signature": env['SETTINGS']['WIRECARD']['WIRECARD_SIGNATURE']},
                     "mastercard":
                        {"password": env['SETTINGS']['WIRECARD']['WIRECARD_PASSWORD'],
                         "username": env['SETTINGS']['WIRECARD']['WIRECARD_USERNAME'],
                         "country_code": "RU",
                         "allow_non_3ds": True,
                         "business_case_signature": env['SETTINGS']['WIRECARD']['WIRECARD_SIGNATURE']},
                     "maestro":
                         {"password": env['SETTINGS']['WIRECARD']['WIRECARD_PASSWORD'],
                          "username": env['SETTINGS']['WIRECARD']['WIRECARD_USERNAME'],
                          "country_code": "RU",
                          "allow_non_3ds": True,
                          "business_case_signature": env['SETTINGS']['WIRECARD']['WIRECARD_SIGNATURE']}}
        data['EUR']['gateways']['pay']['default'] = 'wirecard'
        wirecard_settings = json.dumps(data)
        return wirecard_settings

    def pasta_check(self, settings):
        data = json.loads(str(settings))
        try:
            data['EUR']['gateways']['pay']['default'] = 'pasta'
            data['EUR']['gateways']['payout']['default'] = 'none'
        except KeyError:
            euro_pay = {"gateways": {"pay": {"default": "pasta"}, "payout": {"default": "none"}}}
            data['EUR'] = euro_pay
        gateways_list = []
        for gate in data['gateways']:
            gateways_list.append(gate)
        if 'pasta' in gateways_list:
            test = data['gateways']['pasta']['gateway_key']
            if 'test' in test:
                pasta_key = False
            else:
                pasta_key = True
            pasta_settings = json.dumps(data)
        else:
            data['gateways']['pasta'] = {"gateway_key": "test", "merchant_key": "test"}
            pasta_settings = json.dumps(data)
        return pasta_settings, pasta_key

    def rfi_check(self, env, settings, rfi):
        data = json.loads(str(settings))
        gateways_list = []
        for gate in data['gateways']:
            gateways_list.append(gate)
        if rfi in gateways_list:
            rfi_settings = False
        else:
            if rfi == 'rfi_partner':
                data['gateways'][rfi] = {"visa": {"key": env['SETTINGS']['RFI']['RFI_PARTNER_KEY'],
                                                  "mid": env['SETTINGS']['RFI']['RFI_PARTNER_MID']},
                                         "mastercard": {"key": env['SETTINGS']['RFI']['RFI_PARTNER_KEY'],
                                                        "mid": env['SETTINGS']['RFI']['RFI_PARTNER_MID']},
                                         "maestro": {"key": env['SETTINGS']['RFI']['RFI_PARTNER_KEY'],
                                                     "mid": env['SETTINGS']['RFI']['RFI_PARTNER_MID']}}
            else:
                data['gateways'][rfi] = {"visa": {"key": env['SETTINGS']['RFI']['RFI_KEY'],
                                                  "mid": env['SETTINGS']['RFI']['RFI_MID']},
                                         "mastercard": {"key": env['SETTINGS']['RFI']['RFI_KEY'],
                                                        "mid": env['SETTINGS']['RFI']['RFI_MID']},
                                         "maestro": {"key": env['SETTINGS']['RFI']['RFI_PARTNER_KEY'],
                                                     "mid": env['SETTINGS']['RFI']['RFI_PARTNER_MID']}}
            rfi_settings = json.dumps(data)
        return rfi_settings

    def rfi_change(self, rfi_settings, rfi):
        data = json.loads(str(rfi_settings))
        if rfi == 'rfi_partner':
            data['RUB']['gateways']['pay']['default'] = 'rfi_partner'
        else:
            data['RUB']['gateways']['pay']['default'] = 'rfi'
        new_rfi_settings = json.dumps(data)
        return new_rfi_settings

    def payler_check(self, env, settings):
        data = json.loads(str(settings))
        gateways_list = []
        for gate in data['gateways']:
            gateways_list.append(gate)
        if 'payler' in gateways_list:
            payler_settings = False
        else:
            data['gateways']['payler'] = {"visa": {"key": env['SETTINGS']['PAYLER']['PAYLER_KEY'],
                                                   "password": env['SETTINGS']['PAYLER']['PAYLER_PASSWORD']},
                                          "mastercard": {"key": env['SETTINGS']['PAYLER']['PAYLER_KEY'],
                                                         "password": env['SETTINGS']['PAYLER']['PAYLER_PASSWORD']},
                                          "maestro": {"key": env['SETTINGS']['PAYLER']['PAYLER_KEY'],
                                                      "password": env['SETTINGS']['PAYLER']['PAYLER_PASSWORD']}}
            payler_settings = json.dumps(data)
        return payler_settings

    def payler_change(self, payler_settings):
        data = json.loads(str(payler_settings))
        data['RUB']['gateways']['pay']['default'] = 'payler'
        new_payler_settings = json.dumps(data)
        return new_payler_settings

    def connectum_check(self, env, settings):
        data = json.loads(str(settings))
        gateways_list = []
        for gate in data['gateways']:
            gateways_list.append(gate)
        if 'connectum' in gateways_list:
            connectum_settings = False
        else:
            data['gateways']['connectum'] = {"visa": {"pwd": env['SETTINGS']['CONNECTUM']['CONNECTUM_PWD'],
                                                      "uname": env['SETTINGS']['CONNECTUM']['CONNECTUM_UNAME'],
                                                      "secret": env['SETTINGS']['CONNECTUM']['CONNECTUM_SECRET']},
                                             "mastercard": {"pwd": env['SETTINGS']['CONNECTUM']['CONNECTUM_PWD'],
                                                            "uname": env['SETTINGS']['CONNECTUM']['CONNECTUM_UNAME'],
                                                            "secret": env['SETTINGS']['CONNECTUM']['CONNECTUM_SECRET']},
                                             "maestro": {"pwd": env['SETTINGS']['CONNECTUM']['CONNECTUM_PWD'],
                                                         "uname": env['SETTINGS']['CONNECTUM']['CONNECTUM_UNAME'],
                                                         "secret": env['SETTINGS']['CONNECTUM']['CONNECTUM_SECRET']}}
            connectum_settings = json.dumps(data)
        return connectum_settings

    def connectum_change(self, connectum_settings):
        data = json.loads(str(connectum_settings))
        data['USD']['gateways']['pay']['default'] = 'connectum'
        new_connectum_settings = json.dumps(data)
        return new_connectum_settings

    def convert_change(self, settings):
        dict = json.loads(settings)
        dict['convert_to'] = 'RUB'
        settings_rub = json.dumps(dict)
        return settings_rub

    def host2host(self, settings):
        dict = json.loads(settings)
        dict['gateways'].update({'allow_host2host': True})
        h2h_settings = json.dumps(dict)
        return h2h_settings

    def settings_input(self, settings_to):
        try:
            self.driver.find_element(By.NAME, 'default_user[settings]').clear()
            self.driver.find_element(By.NAME, 'default_user[settings]').send_keys(settings_to)
        except NoSuchElementException:
            self.driver.find_element(By.NAME, 'user[settings]').clear()
            self.driver.find_element(By.NAME, 'user[settings]').send_keys(settings_to)

    def settings_save(self):
        WebDriverWait(self.driver, 10).until(EC.presence_of_element_located((By.NAME, "_save"))).click()

    def save_check(self):
        try:
            WebDriverWait(self.driver, 10). \
                until(EC.text_to_be_present_in_element((By.CLASS_NAME, 'alert-dismissible'), 'successfully updated'))
            return True
        except TimeoutException:
            return False

    def convert_delete(self, settings):
        original_settings = json.loads(settings)
        original_settings.pop('convert_to')
        return json.dumps(original_settings)
