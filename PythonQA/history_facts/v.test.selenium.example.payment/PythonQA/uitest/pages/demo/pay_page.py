import re
import ast
import json
import requests
from time import sleep
from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import NoSuchElementException


class PayPage:

    def __init__(self, driver):
        self.driver = driver

    def open(self, pay_url):
        self.driver.get(pay_url)
        return self

    def at_main_page(self):
        return "Vortex Checkout" in self.driver.title

    def email_input(self, env):
        try:
            self.driver.find_element(By.ID, 'input-email').send_keys(env['CARD_EMAIL'])
            email_check = True
        except NoSuchElementException:
            email_check = False
            pass
        return email_check

    def data_input(self, env, direction):
        if direction == 'production':
            self.driver.find_element(By.ID, 'form_bank_pan').send_keys(env['CARD_EPAYMANTS_NUMBER'])
            self.driver.find_element(By.ID, 'form_bank_holder').send_keys(env['CARD_HOLDER'])
            self.driver.find_element(By.ID, 'form_bank_expires').send_keys(env['CARD_EPAYMANTS_EXPRIRES'])
            self.driver.find_element(By.ID, 'form_bank_cvv').send_keys(env['CARD_EPAYMANTS_CVV'])
            try:
                self.driver.find_element(By.NAME, 'form_bank[address]').send_keys(env['CARD_ADDRESS'])
            except NoSuchElementException:
                pass
        else:
            self.driver.find_element(By.ID, 'form_bank_pan').send_keys(env['CARD_NUMBER'])
            self.driver.find_element(By.ID, 'form_bank_holder').send_keys(env['CARD_HOLDER'])
            self.driver.find_element(By.ID, 'form_bank_expires').send_keys(env['CARD_EXPRIRES'])
            self.driver.find_element(By.ID, 'form_bank_cvv').send_keys(env['CARD_CVV'])
            try:
                self.driver.find_element(By.NAME, 'form_bank[address]').send_keys(env['CARD_ADDRESS'])
            except NoSuchElementException:
                pass

    def data_input_pasta(self, env, direction):
        if direction == 'production':
            self.driver.find_element(By.ID, 'form_bank_pan').send_keys(env['CARD_EPAYMANTS_NUMBER'])
            self.driver.find_element(By.ID, 'form_bank_holder').send_keys(env['CARD_HOLDER'])
            self.driver.find_element(By.ID, 'form_bank_expires').send_keys(env['CARD_EPAYMANTS_EXPRIRES'])
            self.driver.find_element(By.ID, 'form_bank_cvv').send_keys(env['CARD_EPAYMANTS_CVV'])
            try:
                self.driver.find_element(By.NAME, 'form_bank[address]').send_keys(env['CARD_ADDRESS'])
            except NoSuchElementException:
                pass
        else:
            self.driver.find_element(By.ID, 'form_bank_pan').send_keys(env['CARD_PASTA_NUMBER'])
            self.driver.find_element(By.ID, 'form_bank_holder').send_keys(env['CARD_HOLDER'])
            self.driver.find_element(By.ID, 'form_bank_expires').send_keys(env['CARD_EXPRIRES'])
            self.driver.find_element(By.ID, 'form_bank_cvv').send_keys(env['CARD_CVV'])
            try:
                self.driver.find_element(By.NAME, 'form_bank[address]').send_keys(env['CARD_ADDRESS'])
            except NoSuchElementException:
                pass

    def data_input_wirecard(self, env, direction):
        if direction == 'production':
            self.driver.find_element(By.ID, 'form_bank_pan').send_keys(env['CARD_EPAYMANTS_NUMBER'])
            self.driver.find_element(By.ID, 'form_bank_holder').send_keys(env['CARD_HOLDER'])
            self.driver.find_element(By.ID, 'form_bank_expires').send_keys(env['CARD_EPAYMANTS_EXPRIRES'])
            self.driver.find_element(By.ID, 'form_bank_cvv').send_keys(env['CARD_EPAYMANTS_CVV'])
            try:
                self.driver.find_element(By.NAME, 'form_bank[address]').send_keys(env['CARD_ADDRESS'])
            except NoSuchElementException:
                pass
        else:
            self.driver.find_element(By.ID, 'form_bank_pan').send_keys(env['CARD_WIRECARD_NUMBER'])
            self.driver.find_element(By.ID, 'form_bank_holder').send_keys(env['CARD_HOLDER'])
            self.driver.find_element(By.ID, 'form_bank_expires').send_keys(env['CARD_WIRECARD_EXPRIRES'])
            self.driver.find_element(By.ID, 'form_bank_cvv').send_keys(env['CARD_WIRECARD_CVV'])
            try:
                self.driver.find_element(By.NAME, 'form_bank[address]').send_keys(env['CARD_ADDRESS'])
            except NoSuchElementException:
                pass

    def data_ecom_input(self, env, direction):
        if direction == 'production':
            self.driver.find_element(By.ID, 'form_bank_pan').send_keys(env['CARD_EPAYMANTS_NUMBER'])
            self.driver.find_element(By.ID, 'form_bank_holder').send_keys(env['CARD_HOLDER'])
            self.driver.find_element(By.ID, 'form_bank_expires').send_keys(env['CARD_EPAYMANTS_EXPRIRES'])
            self.driver.find_element(By.ID, 'form_bank_cvv').send_keys(env['CARD_EPAYMANTS_CVV'])
            try:
                self.driver.find_element(By.NAME, 'form_bank[address]').send_keys(env['CARD_ADDRESS'])
            except NoSuchElementException:
                pass
        else:
            self.driver.find_element(By.ID, 'form_bank_pan').send_keys(env['CARD_ECOM_NUMBER'])
            self.driver.find_element(By.ID, 'form_bank_holder').send_keys(env['CARD_HOLDER'])
            self.driver.find_element(By.ID, 'form_bank_expires').send_keys('042020')
            self.driver.find_element(By.ID, 'form_bank_cvv').send_keys(env['CARD_CVV'])
            try:
                self.driver.find_element(By.NAME, 'form_bank[address]').send_keys(env['CARD_ADDRESS'])
            except NoSuchElementException:
                pass

    def data_default_input(self, env, card, expires):
        self.driver.find_element(By.ID, 'form_bank_pan').send_keys(card)
        self.driver.find_element(By.ID, 'form_bank_holder').send_keys(env['CARD_HOLDER'])
        self.driver.find_element(By.ID, 'form_bank_expires').send_keys(env['CARD_EXPRIRES'])
        self.driver.find_element(By.ID, 'form_bank_cvv').send_keys(env['CARD_CVV'])
        try:
            self.driver.find_element(By.NAME, 'form_bank[address]').send_keys(env['CARD_ADDRESS'])
        except NoSuchElementException:
            pass

    def data_input_qiwi(self, env, direction):
        if direction == 'production':
            self.driver.find_element(By.ID, 'form_bank_pan').send_keys(env['CARD_MEGAFON_NUMBER'])
            self.driver.find_element(By.ID, 'form_bank_holder').send_keys(env['CARD_HOLDER'])
            self.driver.find_element(By.ID, 'form_bank_expires').send_keys(env['CARD_MEGAFON_EXPRIRES'])
            self.driver.find_element(By.ID, 'form_bank_cvv').send_keys(env['CARD_MEGAFON_CVV'])
            try:
                self.driver.find_element(By.NAME, 'form_bank[address]').send_keys(env['CARD_ADDRESS'])
            except NoSuchElementException:
                pass
        else:
            self.driver.find_element(By.ID, 'form_bank_pan').send_keys(env['CARD_NUMBER'])
            self.driver.find_element(By.ID, 'form_bank_holder').send_keys(env['CARD_HOLDER'])
            self.driver.find_element(By.ID, 'form_bank_expires').send_keys('032020')
            self.driver.find_element(By.ID, 'form_bank_cvv').send_keys(env['CARD_CVV'])
            try:
                self.driver.find_element(By.NAME, 'form_bank[address]').send_keys(env['CARD_ADDRESS'])
            except NoSuchElementException:
                pass

    def data_input_qiwi_demo(self, env, direction):
        if direction == 'production':
            self.driver.find_element(By.ID, 'form_bank_holder').send_keys(env['CARD_HOLDER'])
        else:
            self.driver.find_element(By.ID, 'form_bank_holder').send_keys('unknown user')
        self.driver.find_element(By.ID, 'form_bank_pan').send_keys(env['CARD_MEGAFON_NUMBER'])
        self.driver.find_element(By.ID, 'form_bank_expires').send_keys(env['CARD_MEGAFON_EXPRIRES'])
        self.driver.find_element(By.ID, 'form_bank_cvv').send_keys(env['CARD_MEGAFON_CVV'])
        try:
            self.driver.find_element(By.NAME, 'form_bank[address]').send_keys(env['CARD_ADDRESS'])
        except NoSuchElementException:
            pass

    def data_input_rfi(self, env):
        self.driver.find_element(By.ID, 'form_bank_pan').send_keys(env['CARD_MEGAFON_NUMBER'])
        self.driver.find_element(By.ID, 'form_bank_holder').send_keys(env['CARD_HOLDER'])
        self.driver.find_element(By.ID, 'form_bank_expires').send_keys(env['CARD_MEGAFON_EXPRIRES'])
        self.driver.find_element(By.ID, 'form_bank_cvv').send_keys(env['CARD_MEGAFON_CVV'])
        try:
            self.driver.find_element(By.NAME, 'form_bank[address]').send_keys(env['CARD_ADDRESS'])
        except NoSuchElementException:
            pass

    def data_input_payler(self, env, direction):
        if direction == 'production':
            self.driver.find_element(By.ID, 'form_bank_pan').send_keys(env['CARD_MEGAFON_NUMBER'])
            self.driver.find_element(By.ID, 'form_bank_holder').send_keys(env['CARD_HOLDER'])
            self.driver.find_element(By.ID, 'form_bank_expires').send_keys(env['CARD_MEGAFON_EXPRIRES'])
            self.driver.find_element(By.ID, 'form_bank_cvv').send_keys(env['CARD_MEGAFON_CVV'])
            try:
                self.driver.find_element(By.NAME, 'form_bank[address]').send_keys(env['CARD_ADDRESS'])
            except NoSuchElementException:
                pass
        else:
            self.driver.find_element(By.ID, 'form_bank_pan').send_keys(env['CARD_PAYLER_NUMBER'])
            self.driver.find_element(By.ID, 'form_bank_holder').send_keys(env['CARD_HOLDER'])
            self.driver.find_element(By.ID, 'form_bank_expires').send_keys(env['CARD_PAYLER_EXPRIRES'])
            self.driver.find_element(By.ID, 'form_bank_cvv').send_keys(env['CARD_PAYLER_CVV'])
            try:
                self.driver.find_element(By.NAME, 'form_bank[address]').send_keys(env['CARD_ADDRESS'])
            except NoSuchElementException:
                pass

    def data_default_submit(self):
        self.driver.find_element(By.ID, 'pay_btn').submit()

    def default_status(self, status):
        if 'approve' == status:
            self.driver.find_element(By.XPATH, '/html/body/div[1]/form/button').click()
        else:
            self.driver.find_element(By.XPATH, '/html/body/div[2]/form/button').click()

    def data_submit(self, env):
        self.driver.find_element(By.ID, 'pay_btn').submit()

    def sms_input(self, env, card='default'):
        sms = None
        for time in range(1, 10):
            sleep(20)
            answer = requests.get(env['INBOX_SMS_URL'])
            sms_json = json.dumps(ast.literal_eval(str(answer.text)))
            sms_text = json.loads(sms_json)
            if card == 'epayments':
                result = re.search(r"\s*(\d+)", str(sms_text))
            else:
                result = re.search(r":\s*(\d+)", str(sms_text))
            try:
                sms = result.group(1)
                break
            except AttributeError:
                continue
        return sms

    def response(self):
        response_url = self.driver.current_url
        return response_url

    def proxy_data(self):
        return_url = self.driver.current_url
        return return_url

    def connectum_status(self):
        connectum_url = self.driver.current_url
        WebDriverWait(self.driver, 10).until\
            (EC.presence_of_element_located((By.XPATH, '//*[@id="bank_success"]/input[3]'))).click()
        return 'connectum' in connectum_url
