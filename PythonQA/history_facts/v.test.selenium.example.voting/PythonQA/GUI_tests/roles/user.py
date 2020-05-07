from selenium.common.exceptions import TimeoutException, WebDriverException

import gui_helpers


class Actor:
	def __init__(self, context):
		self.context = context
		self.browser = context.browser

	def see(self, element_locator):
		gui_helpers.wait_visible(self.context, element_locator)
		return self

	def click(self, element_locator):
		try:
			gui_helpers.wait_clickable(self.context, element_locator).click()
		except WebDriverException(screen=gui_helpers.save_screenshot(self.context)):
			raise
		return self

	def into(self, element_locator):
		element = gui_helpers.wait_visible(self.context, element_locator)
		return ElementAction(self, element)

	def into_invisible(self, element_locator):
		element = gui_helpers.find_element(self.context, element_locator)
		return ElementAction(self, element)

	def within(self, element_locator):
		return Actor.into(self, element_locator)

	def unsee(self, element_locator):
		gui_helpers.wait_invisible(self.context, element_locator)
		return self

	def click_and_unsee(self, element_locator):
		return Actor.click(self, element_locator).unsee(element_locator)

	def click_index(self, element_locator, index):
		gui_helpers.wait_visible(self.context, element_locator)
		try:
			gui_helpers.find_elements(self.context, element_locator)[index].click()
		except WebDriverException(screen=gui_helpers.save_screenshot(self.context)):
			raise
		return self

	def go_to(self, url):
		print('Navigating to {}'.format(url))  # logging
		try:
			self.browser.get(url)
		except TimeoutException:
			pass
		return self

	def write_to_context(self, attr, value):
		setattr(self.context, attr, value)
		return self

	def switch_to_window_handle(self, index):
		self.context.browser.switch_to.window(self.context.browser.window_handles[index])
		return self

	def verify_text_in_element(self, locator, text):
		gui_helpers.wait_text(self.context, locator, text)
		return self


class ElementAction:
	def __init__(self, actor, element):
		self.actor = actor
		self.element = element

	def type(self, content):
		while self.element.get_attribute('value') != content:
			self.element.clear()
			self.element.send_keys(content)
		return self.actor

	def attach_image(self, path_to_img):
		self.element.send_keys(path_to_img)
		return self.actor

	def text_is(self, text):
		assert self.element.text == text, "Expected {}, got {}".format(text, self.element.text)
		return self.actor

	def text_contains(self, text):
		assert text in self.element.text, "Expected string {} to be contained in string {}".format(text, self.element.text)
		return self.actor
