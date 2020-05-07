from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException, WebDriverException, NoSuchElementException


class CheckPage:

    def __init__(self, driver):
        self.driver = driver

    def open(self, env, response_url):
        try:
            self.driver.get(response_url)
        except WebDriverException:
            self.driver.get(self.driver.current_url.replace("http://localhost:4000/", env['BUSINESS_URL']))

    def at_checkout_page(self):
        return "Vortex Checkout" in self.driver.title

    def payment_checkout(self):
        try:
            WebDriverWait(self.driver, 20).until(EC.presence_of_element_located((By.CLASS_NAME, "checkout-header")))
            payment_status = self.driver.find_element(By.CLASS_NAME, 'checkout-header').text
            return payment_status
        except TimeoutException:
            return False

    def check_status(self):
        try:
            WebDriverWait(self.driver, 10).until(EC.presence_of_element_located((By.XPATH, "/html/body/pre")))
            status = self.driver.find_element(By.XPATH, '/html/body/pre').text
            return True if 'Success' in status else False
        except TimeoutException:
            WebDriverWait(self.driver, 10).until(EC.url_contains("success"))
            return True if 'success' in self.driver.current_url else False

    def check_epayments_status(self):
        WebDriverWait(self.driver, 20).until(EC.presence_of_element_located((By.XPATH, "/html/body/pre")))
        try:
            status = self.driver.find_element(By.CLASS_NAME, 'checkout-header').text
        except NoSuchElementException:
            raise TimeoutException
        return 'Success' in status

    def check_h2h_status(self):
        WebDriverWait(self.driver, 10).until(EC.url_contains('success'))
        status = self.driver.current_url
        return True if 'success' in status else False

