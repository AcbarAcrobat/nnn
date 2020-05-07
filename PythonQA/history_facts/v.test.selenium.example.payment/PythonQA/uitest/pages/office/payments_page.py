from selenium.webdriver.common.by import By
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import NoSuchElementException
from selenium.webdriver.common.action_chains import ActionChains


class PaymentsPage:

    def __init__(self, driver):
        self.driver = driver

    def open(self, env):
        self.driver.get(env['OFFICE_URL'] + 'payin_requests')

    def on_page(self):
        return "Payments" in self.driver.title

    def last_status(self):
        status = self.driver.find_element(By.XPATH, '//*[@id="requests-body"]/tr[1]/td[7]').text
        return status

    def payment_date(self):
        date = self.driver.find_element(By.XPATH, '//*[@id="requests-body"]/tr[1]/td[2]').text
        return date

    def refund_submit(self):
        WebDriverWait(self.driver, 10).until(EC.presence_of_element_located
                                             ((By.XPATH, '//*[@id="requests-body"]/tr[1]/td[14]/button'))).click()

    def rerefund(self):
        try:
            refund = self.driver.find_element(By.XPATH, '//*[@id="requests-body"]/tr[2]/td[11]/button')
        except NoSuchElementException:
            refund = None
        return True if not refund else False

    def resend_notification(self):
        WebDriverWait(self.driver, 10).until(EC.presence_of_element_located
                                             ((By.XPATH, '//*[@id="requests-body"]/tr[2]/td[15]/form'))).click()

    def refund_conversion_submit(self):
        WebDriverWait(self.driver, 10).until(EC.presence_of_element_located
                                             ((By.XPATH, '//*[@id="requests-body"]/tr[2]/td[11]/form/input[1]'))).click()

    def refund(self, amount):
        amount_field = WebDriverWait(self.driver, 10).until(EC.element_to_be_clickable((By.NAME, "amount")))
        amount_field.clear()
        amount_field.send_keys(str(amount))
        self.driver.find_element(By.XPATH, "//*[contains(text(), 'Confirm')]").click()

    def refund_full_amount(self):
        WebDriverWait(self.driver, 10).until(EC.element_to_be_clickable
                                             ((By.XPATH, "//button[text()='Confirm']"))).click()

    def refund_amount(self):
        amount = WebDriverWait(self.driver, 10).until(EC.presence_of_element_located
                                                      ((By.XPATH, '//*[@id="requests-body"]/tr[1]/td[8]'))).text
        return amount

    def refund_partial_amount(self, amount):
        amount_field = WebDriverWait(self.driver, 10).until(EC.element_to_be_clickable((By.NAME, "amount")))
        amount_field.clear()
        amount_field.send_keys(str(float(amount)/2))
        WebDriverWait(self.driver, 10).until(EC.element_to_be_clickable
                                             ((By.XPATH, "//button[text()='Confirm']"))).click()

    def refund_amount_check(self, amount):
        refuded_amount = WebDriverWait(self.driver, 10).until(EC.presence_of_element_located
                                             ((By.XPATH, '//*[@id="requests-body"]/tr[1]/td[8]'))).text
        print(str(float(amount)/2))
        print(refuded_amount)
        return True if str(float(amount)/2) in refuded_amount else False

    def alert_check(self):
        try:
            WebDriverWait(self.driver, 10). \
                until(EC.text_to_be_present_in_element((By.CLASS_NAME, 'alert-success'), 'Refund request created'))
            return True
        except TimeoutException:
            return False

    def notification_check(self):
        try:
            WebDriverWait(self.driver, 10). \
                until(EC.text_to_be_present_in_element((By.CLASS_NAME, 'alert-success'),
                                                       'Notification resend request created'))
            return True
        except TimeoutException:
            return False

    def office_refund_check(self):
        currency = self.driver.find_element(By.XPATH, '//*[@id="requests-body"]/tr[1]/td[9]').text
        exch_currency = self.driver.find_element(By.XPATH, '//*[@id="requests-body"]/tr[1]/td[11]').text
        return True if 'CAD' in currency and 'RUB' == exch_currency else False