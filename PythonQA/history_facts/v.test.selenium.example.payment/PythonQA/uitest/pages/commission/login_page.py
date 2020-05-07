from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


class LoginPage:

    def __init__(self, driver):
        self.driver = driver

    def login(self, env):
        self.driver.get(env['CORE_URL'] + 'admin')

    def at_login_page(self):
        return "Please sign in" in self.driver.title

    def data_login_input(self, env):
        self.driver.find_element(By.NAME, 'admin_user[email]').send_keys(env['SETTINGS_LOGIN'])
        self.driver.find_element(By.NAME, 'admin_user[password]').send_keys(env['SETTINGS_LOGIN'])

    def data_submit(self):
        WebDriverWait(self.driver, 10).until(EC.presence_of_element_located((By.CLASS_NAME, "btn"))).click()

