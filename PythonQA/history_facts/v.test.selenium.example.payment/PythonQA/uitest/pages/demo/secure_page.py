import json
import requests
from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import NoSuchElementException, TimeoutException
from uitest.pages.demo.pay_page import PayPage
from uitest.pages.demo.check_page import CheckPage


class SecurePage:

    def __init__(self, driver):
        self.driver = driver
        self.pay_page = PayPage(self.driver)
        self.check_page = CheckPage(self.driver)

    def at_secure_page(self):
        return "Authentication" in self.driver.title

    def at_pasta_secure_page(self):
        return "Send PARes to TermUrl" in self.driver.title

    def at_mf_secure_page(self):
        return "SecureCode" in self.driver.title

    def at_wirecard_secure_page(self):
        return "Wirecard Bank" in self.driver.title

    def at_epayments_secure_page(self):
        return "cardinalcommerce" in self.driver.current_url

    def at_ecom_secure_page(self):
        print(str(self.driver.current_url))
        return "e-comprocessing" in self.driver.current_url

    def at_payler_secure_page(self):
        return "ecm.sngb" in self.driver.current_url

    def cvv_input(self, env):
        self.driver.find_element(By.NAME, 'password').send_keys(env['CARD_3DD'])

    def secure_submit(self):
        WebDriverWait(self.driver, 10).until\
            (EC.presence_of_element_located((By.NAME, "submit"))).click()

    def secure_pasta_submit(self):
        WebDriverWait(self.driver, 10).until(EC.presence_of_element_located((
            By.XPATH, "/html/body/form/table/tbody/tr/td/table/tbody/tr[4]/td/input[1]"))).click()

    def mf_resend(self):
        self.driver.find_element(By.NAME, 'resendPasswordLink').click()

    def cvv_mf_input(self, sms):
        self.driver.find_element(By.NAME, 'pwdInputVisible').send_keys(sms)

    def secure_mf_submit(self):
        WebDriverWait(self.driver, 10).until\
            (EC.presence_of_element_located((By.NAME, "submitPasswordButton"))).click()

    def cvv_alfa_input(self, sms):
        self.driver.find_element(By.NAME, 'DynamicPassword').send_keys(sms)

    def cvv_ecom_input(self):
        self.driver.find_element(By.NAME, 'password').send_keys('777')

    def cvv_wirecard_input(self, env):
        self.driver.find_element(By.NAME, 'password').send_keys(env['CARD_WIRECARD_3DS'])

    def cvv_payler_input(self, env):
        self.driver.find_element(By.NAME, 'password_str').send_keys(env['CARD_PAYLER_3DS'])

    def secure_wirecard_submit(self):
        WebDriverWait(self.driver, 10).until(EC.presence_of_element_located((By.NAME, "authenticate"))).click()

    def secure_payler_submit(self):
        WebDriverWait(self.driver, 10).until(EC.presence_of_element_located((By.NAME, "Submit"))).click()

    def secure_payler_return(self):
        WebDriverWait(self.driver, 10).until(EC.presence_of_element_located((By.NAME, "SubmitButton"))).click()

    def secure_ecom_submit(self):
        WebDriverWait(self.driver, 10).until(EC.presence_of_element_located((By.NAME, "commit"))).click()

    def secure_alfa_submit(self):
        WebDriverWait(self.driver, 10).until(EC.element_to_be_clickable((By.ID, "btnSubmit"))).click()

    def cvv_epaym_input(self, sms):
        self.driver.find_element(By.ID, 'Credential_Value').send_keys(sms)

    def secure_epaym_submit(self):
        WebDriverWait(self.driver, 10).until(EC.element_to_be_clickable((By.ID, "ValidateButton"))).click()

    def sms_mf_input(self, env):
        try:
            assert self.check_page.check_status()
        except TimeoutException:
            try:
                assert 'success' in self.driver.current_url
            except AssertionError:
                assert SecurePage.at_mf_secure_page(self)
                sms = self.pay_page.sms_input(env)
                SecurePage.cvv_mf_input(self, sms)
                SecurePage.secure_mf_submit(self)
                try:
                    self.check_page.check_status()
                except NoSuchElementException:
                    try:
                        assert 'success' in self.driver.current_url
                    except AssertionError:
                        sms = self.pay_page.sms_input(env)
                        if sms is None:
                            SecurePage.mf_resend(self)
                            sms = self.pay_page.sms_input(env)
                        SecurePage.cvv_mf_input(self, sms)
                        SecurePage.secure_mf_submit(self)
        requests.post(env['INBOX_SMS_URL'], data=json.dumps({"Test": "Test"}),
                      headers={'Content-Type': 'application/json', 'Content-Encoding': 'utf-8'})

    def sms_epayments_input(self, env):
        sms = self.pay_page.sms_input(env, card='epayments')
        SecurePage.cvv_epaym_input(self, sms)
        SecurePage.secure_epaym_submit(self)
        try:
            self.check_page.check_epayments_status()
        except TimeoutException:
            try:
                assert 'success' in self.driver.current_url
            except AssertionError:
                sms = self.pay_page.sms_input(env)
                SecurePage.cvv_epaym_input(self, sms)
                SecurePage.secure_epaym_submit(self)

