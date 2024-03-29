from selenium.webdriver.common.by import By

##### INSTALL DEFAULTS

INSTALL_NEXT_BUTTON = (By.CLASS_NAME, "instal-btn-wrap")
WIZARD_NEXT_BUTTON = (By.CLASS_NAME, "wizard-next-button")
CLOSE_BUTTON_BY_ID = (By.ID, "close")

AGREE_LICENSE_NAME = (By.NAME, "__wiz_agree_license")
AGREE_LICENSE_ID = (By.ID, "agree_license_id")

INSTALL_PROGRESSBAR_OBJECT = (By.CLASS_NAME, "instal-progress-bar-alignment")

#####

NEXT = (By.NAME, 'StepNext')
ACCEPT_LICENSE_AGREEMENT = (By.CSS_SELECTOR, "label[for='agree_license_id']")
USER_NAME = (By.CSS_SELECTOR, "#user_name")
USER_SURNAME = (By.CSS_SELECTOR, "#user_surname")
USER_EMAIL = (By.CSS_SELECTOR, "#email")
SET_UTF8 = (By.CSS_SELECTOR, "label[for='utf8_inst']")
FREETYPE_VERIFICATION = (By.CSS_SELECTOR, "a[href='http://www.freetype.org']")
BD_SERVER = (By.NAME, "__wiz_host")
BD_USER = (By.NAME, "__wiz_user")
BD_PASSWORD = (By.NAME, "__wiz_password")
BD_NAME = (By.NAME, "__wiz_database")
BD_TYPE_SELECTION = (By.CSS_SELECTOR, "select")
INNODB_CHOICE = (By.CSS_SELECTOR, "[value='innodb']")
BD_ADMIN_PASSWORD = (By.NAME, "__wiz_admin_password")
BD_ADMIN_PASSWORD_CONFIRMATION = (By.NAME, "__wiz_admin_password_confirm")
BITRIX = (By.CSS_SELECTOR, '#id_radio_bitrix.sitecommunity:bitrix:demo_community')
USER_LOGIN = (By.NAME, "USER_LOGIN")
USER_PASSWORD = (By.NAME, "USER_PASSWORD")
LOGIN = (By.NAME, "Login")
ADMIN_HEADER_BUTTON = (By.CSS_SELECTOR, "adm-header-setting-btn")
CLOSE_BUTTON = (By.NAME, "close")
KEEP_AUTH_TO_ADMIN = (By.CLASS_NAME, "adm-designed-checkbox-label")
ADMIN_DETAIL_TOOLBAR_BUTTON_BLUE = (By.CLASS_NAME, "adm-detail-toolbar-btn-text")
MAIN_SITE_NAME = (By.NAME, "NAME")
SITE_NAME = (By.NAME, "SITE_NAME")
SERVER_NAME = (By.NAME, "SERVER_NAME")
MAIN_SITE_DOMAIN_NAMES = (By.NAME, "DOMAINS")
MAIN_SITE_EMAIL = (By.NAME, "EMAIL")
SITE_TEMPLATE_1 = (By.ID, "SITE_TEMPLATE[1][TEMPLATE]")
SITE_TEMPLATE_MAIN = (By.ID, "SITE_TEMPLATE[1][SORT]")
SITE_TEMPLATE_MOBILE_APP = (By.NAME, "SITE_TEMPLATE[2][SORT]")
SAVE_CURRENT_MENU_SETTINGS = (By.NAME, "save")
SITE_TEMPLATE_CONDITION = (By.NAME, "SITE_TEMPLATE[3][CONDITION_folder]")
SITE_NEW_NULL_TEMPLATE = (By.ID, "SITE_TEMPLATE[4][TEMPLATE]")
ADMIN_LIST_TABLE = (By.CLASS_NAME, "adm-list-table")
INDIVID_INSTALL_OBJECT = (By.CLASS_NAME, "bx-core-popup-menu-item")
SINGLE_LOGON_CLOSE_HELPER = (By.CLASS_NAME, "bx-core-adm-dialog-head-inner")
SINGLE_LOGON_CLOSE_HELPER_TEST_CASE = (By.CLASS_NAME, "error-bx-core-adm-dialog-head-inner")
DONTSHOW_CHECKBOX = (By.CLASS_NAME, "ss-network-dontshow-checkbox")
