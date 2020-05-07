import os
from datetime import datetime
from time import sleep
from urllib.parse import urlparse

from selenium.common.exceptions import TimeoutException, NoSuchElementException
from selenium.webdriver import ActionChains
from selenium.webdriver.support import expected_conditions as ec
from shared.constants import *
from shared.elements import *

from shared.general_helpers import format_filename


class GuiAction:
	def __init__(self, browser, locator, method):
		self.browser = browser
		self.locator = locator
		self.method = method

	def perform(self):
		try:
			return getattr(self.browser, self.method)(self.locator)
		except NoSuchElementException(
				msg="Element {} was not found".format(self.locator),
				screen=save_screenshot(self.browser)):
			raise


def find_element(context, locator):
	try:
		return context.browser.find_element(*locator)
	except NoSuchElementException as e:
		e.msg = """Element {} wasn't found on the page, see screenshot for more detail""".format(locator)
		e.screen = save_screenshot(context)


def find_elements(context, locator):
	try:
		return context.browser.find_elements(*locator)
	except NoSuchElementException as e:
		e.msg = """Elements {} weren't found on the page, see screenshot for more details""".format(locator)
		e.screen = save_screenshot(context)


def wait_clickable(context, locator):
	try:
		return context.wait.until(ec.element_to_be_clickable(locator))
	except TimeoutException as e:
		e.msg = 'A timeout occured while waiting for element {} to be clickable'.format(locator)
		e.screen = save_screenshot(context)
		raise


def wait_text(context, locator, text):
	try:
		return context.wait.until(ec.text_to_be_present_in_element(locator, text))
	except TimeoutException as e:
		e.msg = 'A timeout occured while waiting for {} to appear in element {}'.format(text, locator)
		e.screen = save_screenshot(context)
		raise


def wait_visible(context, locator):
	try:
		return context.wait.until(ec.visibility_of_element_located(locator))
	except TimeoutException as e:
		e.msg = 'A timeout occured while waiting for element {} to appear'.format(locator)
		e.screen = save_screenshot(context)
		raise


def wait_invisible(context, locator):
	try:
		return context.wait.until(ec.invisibility_of_element_located(locator))
	except TimeoutException as e:
		e.msg = 'A timeout occured while waiting for element {} to disappear'.format(locator)
		e.screen = save_screenshot(context)
		raise


def switch_to_frame(context, frame):
	try:
		return context.wait.until(ec.frame_to_be_available_and_switch_to_it(frame))
	except TimeoutException as e:
		e.msg = 'Frame {} did not appear in time (index 0 is the first frame)'.format(frame)
		e.screen = save_screenshot(context)
		raise


def get_count(context, locator):
	try:
		return int(find_element(context, locator).text.split()[0])
	except ValueError:
		sleep(0.2)
		return get_count(context, locator)


def switch_to_window_index(context, index):
	try:
		return context.browser.switch_to.window(context.browser.window_handles[index])
	except IndexError:
		sleep(0.2)
		return switch_to_window_index(context, index)


def navigate_to_url(context, url):
	print(url)
	try:
		return context.browser.get(url)
	except TimeoutException:
		save_screenshot(context)
		# revert when python image service change is merged
		pass


def login_with_cookies(context, user=None):
	if user:
		api_login(context, user)
	try:
		context.browser.get(context.apiUrls.private_me)
	except TimeoutException:
		pass
	context.browser.add_cookie({'name': '.cc', 'value': context.cookie.split('=')[1]})
	try:
		context.browser.get(context.apiUrls.private_me_other_host)
	except TimeoutException:
		pass
	context.browser.add_cookie({'name': '.cc', 'value': context.cookie.split('=')[1]})


def get_element_count(context, locator):
	try:
		return len(find_elements(context, locator))
	except NoSuchElementException:
		return 0


def wait_element_by_index(context, locator, index):
	try:
		return find_elements(context, locator)[index]
	except IndexError:
		sleep(0.2)
		return wait_element_by_index(context, locator, index)


def get_channel_url(context, channel_id):
	return context.webUrls.base_url + '/channel/' + str(channel_id)


def save_screenshot(context):
	parsed_url = urlparse(context.browser.current_url)

	wh = context.browser.window_handles
	if len(wh) > 1:
		context.browser.switch_to.window(wh[-1])

	return context.browser.get_screenshot_as_file(
		os.path.join(*PATH_TO_PUBLISH, format_filename(
			datetime.now().strftime("%H-%M-%S_") + context.current_step.replace(' ', '_') +
			'_url' + parsed_url.path + '_' + parsed_url.query) + '.png'))


def send_keys_to_unfocusable_element(context, element, text):
	# needed to send text to elements that Google Chrome cannot focus
	actions = ActionChains(context.browser)
	actions.move_to_element(element)
	actions.click()
	actions.send_keys(text)
	return actions.perform()


def fill_fields_with_text(context, element, text):
	answer_list = find_elements(context, element)
	i = 0
	for a in answer_list:
		i += 1
		send_keys_to_unfocusable_element(context, a, text + str(i))


def add_answer_to_vortex.com(context, number):
	sleep(BALLOT_ANIMATION)
	wait_clickable(context, ADD_ANSWER).click()
	wait_visible(context, (By.CSS_SELECTOR, '.vortex.com-cross'))
	answers = find_elements(context, (By.CSS_SELECTOR, "input[type=text]"))
	answers[-1].send_keys('B')
	return


def myassert(context, expected, got=True, msg='Expected {}, got {}') -> bool:
	try:
		assert expected == got
	except AssertionError:
		if hasattr(context, "browser"):
			save_screenshot(context)
		raise AssertionError(msg.format(expected, got))


def myassertin(context, expected, got=True, msg='Expected {}, got {}') -> bool:
	try:
		assert expected in got
	except AssertionError:
		if hasattr(context, "browser"):
			save_screenshot(context)
		raise AssertionError(msg.format(expected, got))
