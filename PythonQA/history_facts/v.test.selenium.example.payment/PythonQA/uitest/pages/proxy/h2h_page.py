from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


class H2hSecurePage:

    def __init__(self, driver):
        self.driver = driver

    def open(self, h2h_3ds_link):
        self.driver.get(h2h_3ds_link)

    def at_secure_page(self):
        return "Authentication" in self.driver.title

    def cvv_input(self, env):
        self.driver.find_element(By.NAME, 'password').send_keys(env['CARD_3DD'])

    def secure_submit(self):
        WebDriverWait(self.driver, 10).until\
            (EC.presence_of_element_located((By.NAME, "submit"))).click()

