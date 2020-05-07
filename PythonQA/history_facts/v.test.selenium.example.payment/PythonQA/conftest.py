import os
import yaml
import sys
import pytest
import warnings
import selenium.webdriver.firefox.options as Firefox
import selenium.webdriver.chrome.options as Chrome
from selenium.common.exceptions import InvalidSessionIdException
from metabase import main
from random import randint
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from webdriver_manager.firefox import GeckoDriverManager
from selenium.webdriver.android.webdriver import WebDriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from uitest.pages.commission.login_page import LoginPage
from uitest.pages.commission.commissions_page import CommissionsPage
from uitest.pages.settings.default_edit import DefaultSetting


@pytest.fixture(scope='function')
def driver_chrome(request):
    options = Chrome.Options()
    options.add_argument('--disable-site-isolation-trials')
    driver: WebDriver = webdriver.Chrome(executable_path=ChromeDriverManager().install(),
                                         options=options)
    request.cls.driver = driver
    driver.set_window_position(1930, 0)
    driver.maximize_window()
    yield
    driver.quit()


@pytest.fixture(scope='function')
def get_firefox_driver(request):
    driver: WebDriver = webdriver.Firefox(executable_path=GeckoDriverManager().install(),)
                                          #service_log_path="/tmp/geckodriver.log")
    request.cls.driver = driver
    driver.maximize_window()
    yield
    driver.quit()


@pytest.fixture(scope='function')
def driver_firefox_headless(request):
    options = Firefox.Options()
    options.headless = True
    driver: WebDriver = webdriver.Firefox(options=options, executable_path=GeckoDriverManager().install(),)
                                          #service_log_path="/tmp/geckodriver.log")
    request.cls.driver = driver
    yield
    driver.close()
    driver.quit()


@pytest.fixture(scope='function')
def driver_chrome_headless(request):
    options = Chrome.Options()
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-site-isolation-trials')
    desired_capabilities = DesiredCapabilities.CHROME
    desired_capabilities['loggingPrefs'] = {
        'browser': 'ALL',
        'performance': 'ALL'
    }
    driver: WebDriver = webdriver.Chrome(desired_capabilities=desired_capabilities, options=options,
                                         executable_path=ChromeDriverManager().install())
    request.cls.driver = driver
    yield driver
    try:
        driver.close()
        driver.quit()
    except InvalidSessionIdException:
        driver.quit()


@pytest.fixture(scope='module')
def env():
    warnings.filterwarnings("ignore", category=DeprecationWarning)
    try:
        if os.environ['CORE_URL']:
            return os.environ
    except KeyError:
        try:
            config = yaml.safe_load(open(sys.path[0] + '/env.yml'))
        except FileNotFoundError:
            config = yaml.safe_load(open(sys.path[1] + '/env.yml'))
        env = config['environment']
        return env


@pytest.fixture(scope="function")
@pytest.mark.usefixtures('env', 'driver_chrome_headless')
def commission_clear(env, driver_chrome_headless):
    yield
    login_page = LoginPage(driver_chrome_headless)
    login_page.login(env)
    login_page.data_login_input(env)
    login_page.data_submit()
    commissions_page = CommissionsPage(driver_chrome_headless)
    commissions_page.list(env)
    commissions_page.destroy(env)
    commissions_page.destroy_confirm()


@pytest.fixture
@pytest.mark.usefixtures('env', 'driver_chrome_headless')
def settings_open(env, direction, request, driver_chrome_headless):
    default_edit = DefaultSetting(driver_chrome_headless)
    default_edit.login_open(env, 'http', direction)
    default_edit.settings_open(env)
    try:
        assert default_edit.at_settings_page()
    except AssertionError:
        default_edit.login_open(env, 'https', direction)
        default_edit.settings_open(env)
        assert default_edit.at_settings_page()
    request.cls.default_edit = default_edit
    return default_edit


@pytest.fixture
@pytest.mark.usefixtures('settings_open')
def old_settings(settings_open):
    yield
    settings = settings_open.settings()
    qiwi_settings = settings_open.rub_default(settings)
    millikart_settings = settings_open.usd_default(qiwi_settings)
    settings_open.settings_input(settings_to=millikart_settings)
    settings_open.settings_save()
    assert settings_open.save_check()


@pytest.fixture(scope="function")
def metabase(env, request, session):
    session_id = main.Base(env=env, session=session).session
    base = main.Base(session=session_id, env=env)
    request.cls.base = base


def random_number(n):
    start = 10**(n-1)
    end = (10**n)-1
    return randint(start, end)


@pytest.fixture(scope='module')
def telegram_env():
    warnings.filterwarnings("ignore", category=DeprecationWarning)
    config = yaml.safe_load(open(sys.path[0] + '/telegram_env.yml'))
    env = config['environment']
    return env
    #return os.environ


def pytest_addoption(parser):
    parser.addoption("--direction", action="store", default="default direction")
    parser.addoption("--session", action="store", default=None)
    parser.addoption("--runslow", action="store_true", default=False, help="run slow tests")


def pytest_configure(config):
    config.addinivalue_line("markers", "slow: mark test as slow to run")


def pytest_collection_modifyitems(config, items):
    if config.getoption("--runslow"):
        return
    skip_slow = pytest.mark.skip(reason="need --runslow option to run")
    for item in items:
        if "slow" in item.keywords:
            item.add_marker(skip_slow)


@pytest.fixture
def direction(request):
    return request.config.getoption("--direction")


@pytest.fixture
def session(request):
    return request.config.getoption("--session")

