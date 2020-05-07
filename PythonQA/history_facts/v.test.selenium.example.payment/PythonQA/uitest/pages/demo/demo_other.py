from selenium.common.exceptions import TimeoutException
from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


class DemoOther:

    def __init__(self, driver):
        self.driver = driver

    def new_tab(self):
        self.driver.execute_script("window.open('');")
        self.driver.switch_to.window(self.driver.window_handles[1])

    def open(self, env):
        self.driver.get(env['DEMO_URL'] + 'other')
        return self

    def at_main_page(self):
        print('\nTitle: ' + self.driver.title)
        return "Vortex" in self.driver.title

    def data_input(self, currency, env):
        self.driver.find_element(By.NAME, 'amount').clear()
        self.driver.find_element(By.NAME, 'amount').send_keys(env['DEMO_DATA_AMOUNT'])
        self.driver.find_element(By.NAME, 'currency').clear()
        self.driver.find_element(By.NAME, 'currency').send_keys(currency)
        self.driver.find_element(By.NAME, 'product').clear()
        self.driver.find_element(By.NAME, 'product').send_keys("Test product")
        self.driver.find_element(By.NAME, 'extra_return_param').clear()
        self.driver.find_element(By.NAME, 'extra_return_param').send_keys('Demo shop #2')
        self.driver.find_element(By.NAME, 'locale').clear()
        self.driver.find_element(By.NAME, 'locale').send_keys('ru')

    def data_cheap_input(self, currency):
        self.driver.find_element(By.NAME, 'amount').clear()
        self.driver.find_element(By.NAME, 'amount').send_keys('100')
        self.driver.find_element(By.NAME, 'currency').clear()
        self.driver.find_element(By.NAME, 'currency').send_keys(currency)
        self.driver.find_element(By.NAME, 'product').clear()
        self.driver.find_element(By.NAME, 'product').send_keys("AutoTest product")
        self.driver.find_element(By.NAME, 'extra_return_param').clear()
        self.driver.find_element(By.NAME, 'extra_return_param').send_keys('AutoDemo shop #2')
        self.driver.find_element(By.NAME, 'locale').clear()
        self.driver.find_element(By.NAME, 'locale').send_keys('ru')

    def data_currency_input(self, amount):
        self.driver.find_element(By.NAME, 'amount').clear()
        self.driver.find_element(By.NAME, 'amount').send_keys(amount)

    def click_buy_button(self):
        WebDriverWait(self.driver, 10).until\
            (EC.presence_of_element_located((By.CLASS_NAME, "product__btn-buy"))).click()

    def at_page(self, env):
        try:
            self.driver.close()
            WebDriverWait(self.driver.switch_to.window(self.driver.window_handles[1]), 30).until(EC.new_window_is_opened)
            pay_url = self.driver.current_url.replace("http://business:4000/", env['BUSINESS_URL'])
            return pay_url
        except TimeoutException:
            return False

    def at_page2(self, env):
        try:
            WebDriverWait(self.driver.switch_to.window(self.driver.window_handles[1]), 30).until(EC.new_window_is_opened)
            pay_url = self.driver.current_url.replace("http://business:4000/", env['BUSINESS_URL'])
            return pay_url
        except TimeoutException:
            return False
