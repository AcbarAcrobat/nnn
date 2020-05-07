import pytest
from telegram.objects.weblist_page import WeblistPage
from telegram.telegram_send import Bot


@pytest.mark.usefixtures('telegram_env')
class TestResponseStatus:

    '''@pytest.mark.skip('Telegram bot')
    @pytest.mark.usefixtures('driver_chrome_headless')
    def test_status(self, direction, telegram_env):
        # direction = 'sandbox'
        print(direction)
        if 'develop' == direction:
            env = telegram_env['develop']
        elif 'sandbox' == direction:
            env = telegram_env['sandbox']
        else:
            env = telegram_env['production']
        self.weblist_page = WeblistPage(self.driver)
        weblist = self.weblist_page.list(env)
        error_list = self.weblist_page.status(weblist)
        self.telegram_send = Bot(telegram_env)
        print('\nerror_list:' + str(error_list))
        if str(error_list) == '[]':
            self.telegram_send.send_message(telegram_env, 'All systems of ' + direction + ' is up!')
        else:
            for error in error_list:
                self.telegram_send.send_message(telegram_env, error)'''

