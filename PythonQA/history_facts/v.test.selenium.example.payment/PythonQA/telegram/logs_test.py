import pytest
from telegram.objects.weblist_page import WeblistPage
from telegram.telegram_send import Bot


@pytest.mark.usefixtures('telegram_env')
class TestWebLog:

    '''@pytest.mark.skip('Telegram bot')
    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_error(self, direction, telegram_env):
        if 'develop' == direction:
            env = telegram_env['develop']
        elif 'sandbox' == direction:
            env = telegram_env['sandbox']
        else:
            env = telegram_env['production']
        self.weblist_page = WeblistPage(self.driver)
        weblist = self.weblist_page.list(env)
        error_list = self.weblist_page.weblog(weblist)
        self.telegram_send = Bot(telegram_env)
        if str(error_list) == '[]':
            self.telegram_send.send_message(telegram_env, 'No ' + direction + ' console errors!')
        else:
            for error in error_list:
                self.telegram_send.send_message(telegram_env, error)'''

