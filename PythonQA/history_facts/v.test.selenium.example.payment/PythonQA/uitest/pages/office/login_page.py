from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


class LoginPage:

    def __init__(self, driver):
        self.driver = driver

    def login(self, env):
        self.driver.get(env['OFFICE_URL'] + 'auth/login')

    def at_login_page(self):
        return "Vortex" in self.driver.title

    def data_input(self, env):
        self.driver.find_element(By.NAME, 'signin[email]').send_keys(env['OFFICE_LOGIN'])
        self.driver.find_element(By.NAME, 'signin[password]').send_keys(env['OFFICE_PASSWORD'])

    def data_submit(self):
        WebDriverWait(self.driver, 10).until(EC.presence_of_element_located((By.NAME, "commit"))).click()

