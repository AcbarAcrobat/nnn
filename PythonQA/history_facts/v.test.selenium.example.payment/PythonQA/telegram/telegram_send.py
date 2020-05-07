import requests


class Bot:

    def __init__(self, env):
        self.url = "https://api.telegram.org/bot" + env['BOT_TOKEN']
        self.proxies = {'https': env['SOCKS5_PROXY']}

    def send_message(self, env, text):
        params = {'chat_id': env['TELEGRAM_CHAT'], 'text': text}
        response = requests.post(self.url + '/sendMessage', data=params, proxies=self.proxies)
        return response

