from behave import *
from shared.elements import *
from roles.user import Actor


@step('{:w} is visible in my home page')
def step_impl(context, entity):
	# only start navigation after the index has updated
	Actor(context). \
		go_to(context.webUrls.private_feed_page). \
		see((By.CSS_SELECTOR, ".entity-preview")).\
		see((By.CSS_SELECTOR, ".ballot")).\
		see((By.CSS_SELECTOR, ".qa-vote-{}".format(str(context.vortex.com.id))))


@then('channel active vortex.com counter is {count:d}')
def step_impl(context, count):
	Actor(context).\
		verify_text_in_element((By.CSS_SELECTOR, ".-selected .entity-preview__picture-label"), str(count))


@when('I click pass button')
def step_impl(context):
	Actor(context).\
		click((By.CSS_SELECTOR, ".ballot-aside__pass"))


@then('vortex.com 1 is shown')
def step_impl(context):
	Actor(context). \
		see((By.CSS_SELECTOR, ".qa-vote-{}".format(str(context.vortex.coms[0].id))))


@given('I am on the home page')
def step_impl(context):
	Actor(context). \
		go_to(context.webUrls.private_feed_page)


@then('empty home page is shown')
def step_impl(context):
	Actor(context).\
		verify_text_in_element((By.CSS_SELECTOR, ".ballot-title__content"), 'What next?').\
		verify_text_in_element((By.CSS_SELECTOR, ".ballot-answer__text"), "Create a vote")


@then('channel owner is shown in channel navigation bar')
def step_impl(context):
	Actor(context).\
		verify_text_in_element((By.CSS_SELECTOR, ".entity-preview__name"), context.channel.name)


@then('{:d} channels are shown')
def step_impl(context, channel_count):
	Actor(context).\
		verify_element_count((By.CSS_SELECTOR, ".entity-preview"), channel_count)


@then('channels names are shown')
def step_impl(context):
	for channel in context.browser.find_elements_by_css_selector(".entity-preview__name"):
		assert channel.text in [ch.name for ch in context.channels]
