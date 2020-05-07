import yaml
import sys
import pytest
import warnings
import selenium.webdriver.chrome.options as Chrome
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.android.webdriver import WebDriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities


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
    yield
    driver.quit()


@pytest.fixture(scope='module')
def telegram_env():
    warnings.filterwarnings("ignore", category=DeprecationWarning)
    config = yaml.safe_load(open(sys.path[0] + '/telegram/telegram_env.yml'))
    env = config['environment']
    return env
    #return os.environ


"""def pytest_addoption(parser):
    parser.addoption("--direction", action="store", default="default direction")


@pytest.fixture
def direction(request):
    return request.config.getoption("--direction")"""

