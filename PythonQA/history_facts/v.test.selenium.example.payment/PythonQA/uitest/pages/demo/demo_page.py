from selenium.common.exceptions import TimeoutException
from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


class DemoPage:

    def __init__(self, driver):
        self.driver = driver

    def open(self, env):
        self.driver.get(env['DEMO_URL'])
        return self

    def at_main_page(self):
        return "Vortex" in self.driver.title

    def click_buy_button(self):
        WebDriverWait(self.driver, 10).until\
            (EC.presence_of_element_located((By.CLASS_NAME, "product__btn-buy"))).click()

    def at_page(self, env):
        try:
            WebDriverWait(self.driver.switch_to.window(self.driver.window_handles[1]), 30).until(EC.new_window_is_opened)
            pay_url = self.driver.current_url.replace("http://business:4000/", env['BUSINESS_URL'])
            return pay_url
        except TimeoutException:
            return False

