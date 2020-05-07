import subprocess
import telebot
import logging
import yaml
import sys
from time import sleep
from telebot import types
from telebot import apihelper


config = yaml.safe_load(open(sys.path[0] + '/telegram_env.yml'))
bot = telebot.TeleBot(config['environment']['BOT_TOKEN'])
apihelper.proxy = {'https': config["environment"]["SOCKS5_PROXY"]}


@bot.message_handler(commands=['start'])
def start(message):
    keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
    keyboard.add(*[types.KeyboardButton(name) for name in ['Check']])
    msg = bot.send_message(message.chat.id, 'Hello!', reply_markup=keyboard)
    bot.register_next_step_handler(msg, environment)


def environment(message):
    keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
    if message.text == 'Check':
        keyboard.add(*[types.KeyboardButton(name) for name in ['Develop', 'Sandbox', 'Production']])
        msg = bot.send_message(message.chat.id, 'Choose your environment', reply_markup=keyboard)
        bot.register_next_step_handler(msg, destiny)


def destiny(message):
    keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
    if message.text == 'Develop':
        keyboard.add(*[types.KeyboardButton(name) for name in ['Status', 'Logs']])
        msg = bot.send_message(message.chat.id, 'Choose your destiny!', reply_markup=keyboard)
        bot.register_next_step_handler(msg, develop)
    if message.text == 'Sandbox':
        keyboard.add(*[types.KeyboardButton(name) for name in ['Status', 'Logs']])
        msg = bot.send_message(message.chat.id, 'Choose your destiny!', reply_markup=keyboard)
        bot.register_next_step_handler(msg, sandbox)
    if message.text == 'Production':
        keyboard.add(*[types.KeyboardButton(name) for name in ['Status', 'Logs']])
        msg = bot.send_message(message.chat.id, 'Choose your destiny!', reply_markup=keyboard)
        bot.register_next_step_handler(msg, production)


def develop(message):
    if message.text == 'Status':
        subprocess.Popen(['pytest', '-s', 'status_test.py', '--direction', 'develop'])
    if message.text == 'Logs':
        subprocess.Popen(['pytest', '-s', 'logs_test.py', '--direction', 'develop'])
    sleep(10)
    keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
    keyboard.add(*[types.KeyboardButton(name) for name in ['Check']])
    msg = bot.send_message(message.chat.id, 'done.', reply_markup=keyboard)
    bot.register_next_step_handler(msg, environment)


def sandbox(message):
    if message.text == 'Status':
        subprocess.Popen(['pytest', '-s', 'status_test.py', '--direction', 'sandbox'])
    if message.text == 'Logs':
        subprocess.Popen(['pytest', '-s', 'logs_test.py', '--direction', 'sandbox'])
    sleep(10)
    keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
    keyboard.add(*[types.KeyboardButton(name) for name in ['Check']])
    msg = bot.send_message(message.chat.id, 'done.', reply_markup=keyboard)
    bot.register_next_step_handler(msg, environment)


def production(message):
    if message.text == 'Status':
        subprocess.Popen(['pytest', '-s', 'status_test.py', '--direction', 'production'])
    if message.text == 'Logs':
        subprocess.Popen(['pytest', '-s', 'logs_test.py', '--direction', 'production'])
    sleep(10)
    keyboard = types.ReplyKeyboardMarkup(resize_keyboard=True)
    keyboard.add(*[types.KeyboardButton(name) for name in ['Check']])
    msg = bot.send_message(message.chat.id, 'done.', reply_markup=keyboard)
    bot.register_next_step_handler(msg, environment)


try:
    bot.polling(none_stop=True)
except Exception as e:
    logging.error(e)

