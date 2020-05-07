import json
import os
import sys
import xml.etree.ElementTree as ElementTree

import selenium.webdriver
from selenium.webdriver.support.wait import WebDriverWait
from shared.api_objects import User, Channel
from shared.constants import PATH_TO_API_CONFIG, PATH_TO_PUBLISH, PATH_TO_IMAGE_LOGO
from shared.weburls import WebUrls
from shared.parsers import *

from shared.apiurls import ApiUrls
from shared.api import API

REGULAR_TIMEOUT = 20
CONFIG_FILE = 'config.json'
content_manager_user_object = None


def before_all(context):
	os.makedirs(os.path.join(*PATH_TO_PUBLISH), exist_ok=True)
	sys.stdout = open(os.path.join(*PATH_TO_PUBLISH, 'before_all.log'), 'w', encoding='utf-8')
	global content_manager_user_object
	# getting from Web.config the amount of votes required
	# to prevent the ballot owning entity from being deleted
	tree = ElementTree.parse(os.path.join(*PATH_TO_API_CONFIG))
	root = tree.getroot()
	context.MaxVoteToDelete = int(root.findall(".//*[@name='MaxVoteToDelete']/value")[0].text)
	# setup proxy for http response logging
	# will only run if special key is passed to behave, off by default

	if 'proxy' in context.config.userdata.keys():
		from browsermobproxy import Server

		context.proxy = True
		context.server = Server('C:\\browsermob-proxy\\browsermob-proxy-2.1.2\\bin\\browsermob-proxy', {"port": 9098})
		context.server.start()
		context.proxy = context.server.create_proxy()
	else:
		context.proxy = False

	# userdata
	userdata = context.config.userdata
	if os.path.exists(CONFIG_FILE):
		more_userdata = json.load(open(CONFIG_FILE))
		context.config.update_userdata(more_userdata)

	context.webUrls = WebUrls(userdata.get('base_url'))

	context.apiUrls = ApiUrls(userdata.get('api_url'))
	context.API = API(context.apiUrls)
	context.cdnUrl = userdata.get('cdn_url')
	context.content_manager_email = userdata.get('content_manager_email')
	context.content_manager_password = userdata.get('content_manager_password')
	context.third_party_url = userdata.get('third_party_url')

	context.superuser = User()
	context.superuser.email = context.content_manager_email
	context.superuser.password = context.content_manager_password
	context.superuser.register(context)

	content_manager_user_object = context.superuser


def before_feature(context, feature):
	# make sure Publish folder exists
	sys.stdout = open(os.path.join(*PATH_TO_PUBLISH, context.feature.name + '.log'), 'w', encoding='utf-8')


def before_scenario(context, scenario):
	if 'skip' in scenario.effective_tags:
		scenario.skip("Skipped")
		return

	print(context.scenario.name.upper())

	u = User(isverified=True)
	u.register(context)
	context.user2 = u

	context.superuser = content_manager_user_object

	# upload profile photo in needed
	if 'profilephoto' in context.tags:
		context.API.upload_image_to_url(context.user.session, context.API_URL + "private/photo", os.path.join(*PATH_TO_IMAGE_LOGO))

	if 'nonbrowser' not in context.tags:
		# browser setup
		chrome_options = selenium.webdriver.ChromeOptions()
		prefs = {"profile.default_content_setting_values.notifications": 2}
		chrome_options.add_experimental_option("prefs", prefs)
		chrome_options.add_argument('--start-maximized')
		chrome_options.add_argument('--dns-prefect-disable')
		if context.proxy:
			chrome_options.add_argument("--proxy-server={0}".format(context.proxy.proxy))
		desired_capabilities = chrome_options.to_capabilities()
		desired_capabilities['loggingPrefs'] = {'browser': 'ALL'}
		# by default, will use local chromedriver

		if 'agent' in context.config.userdata.keys():
			context.browser = selenium.webdriver.Chrome(
				executable_path=os.getcwd() + '\\driver\\chromedriver.exe', desired_capabilities=desired_capabilities)
		else:
			context.browser = selenium.webdriver.Chrome(desired_capabilities=desired_capabilities)

		context.browser.set_page_load_timeout(30)

		if 'resolution' in context.config.userdata.keys():
			_ = context.config.userdata['resolution']
			context.browser.set_window_size(*_.split(':'))

		context.wait = WebDriverWait(context.browser, REGULAR_TIMEOUT)

		if context.proxy and "https" not in context.tags:
			context.proxy.new_har('selenium-webdriver')

	for name in ['channels', 'vortex.coms']:
		setattr(context, name, [])


def after_scenario(context, scenario):
	print(scenario.status)

	if context.proxy and scenario.status == 'failed':
		print(context.proxy.har)

	if hasattr(context, 'browser'):
		context.browser.quit()

	if 'cleanup_featured_channels' in context.tags:
		cleanup_featured_channels(context)


def before_step(context, step):
	context.current_step = step.name
	print('\n' + step.name + '\n')


def after_step(context, step):
	if 'nonbrowser' not in context.tags:
		for entry in context.browser.get_log('browser'):
			print(entry)


def after_all(context):
	if context.proxy:
		context.server.stop()


def cleanup_featured_channels(context):
	feed = context.API.get_channel_featured_feed(context.superuser.session)
	for c in feed:
		channel = Channel(id=c['id'])
		channel.feature(context, context.superuser.session, None)
