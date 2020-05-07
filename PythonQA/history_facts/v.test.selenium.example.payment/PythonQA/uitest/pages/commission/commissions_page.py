from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


class CommissionsPage:

    def __init__(self, driver):
        self.driver = driver

    def list(self, env):
        self.driver.get(env['CORE_URL'] + 'admin/commissions/')

    def create(self, env):
        self.driver.get(env['CORE_URL'] + 'admin/commissions/new')

    def at_add_page(self):
        return "Add Commission" in self.driver.title

    def select_user(self):
        select_element = self.driver.find_element(By.NAME, "commission[user_id]")
        select = Select(select_element)
        select.select_by_value('3')

    def select_currency(self):
        select_element = self.driver.find_element(By.NAME, "commission[currency_code]")
        select = Select(select_element)
        select.select_by_value('RUB')

    def rate_field(self):
        self.driver.find_element(By.NAME, 'commission[rate]').send_keys('30')

    def select_operation_type(self):
        select_element = self.driver.find_element(By.NAME, "commission[operation_type]")
        select = Select(select_element)
        select.select_by_value('payin')

    def select_commission_type(self):
        select_element = self.driver.find_element(By.NAME, "commission[commission_type]")
        select = Select(select_element)
        select.select_by_value('default')

    def select_account_type(self):
        select_element = self.driver.find_element(By.NAME, "commission[account_type]")
        select = Select(select_element)
        select.select_by_value('2')

    def submit(self):
        WebDriverWait(self.driver, 10).until(EC.element_to_be_clickable((By.NAME, "_save"))).click()

    def check_alert(self):
        alert = self.driver.find_element(By.ID, 'flash').text
        return True if 'Commission successfully created' in alert else False

    def destroy(self, env):
        commission = self.driver.find_element(By.XPATH, '/html/body/div/div/div[2]/table/tbody/tr/td[1]').text
        self.driver.get(env['CORE_URL'] + 'admin/commissions/destroy/' + str(commission))

    def destroy_confirm(self):
        WebDriverWait(self.driver, 10).until(EC.element_to_be_clickable((By.NAME, "commit"))).click()

