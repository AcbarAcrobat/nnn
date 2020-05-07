from behave import *
from roles.user import Actor
from selenium.webdriver.common.by import By
from shared.api_objects import ApiRequest
from time import sleep


@given('I navigate to vortex.com page')
def step_impl(context):
	url = context.apiUrls.home_feed
	r = ApiRequest(context.user.session, 'get', url)
	r.perform()
	while not r.response:
		sleep(0.2)
		r.perform()

	Actor(context).\
		go_to(context.webUrls.home_page).\
		see((By.CSS_SELECTOR, ".ballot-body"))


@given('I navigate to draft page')
def step_impl(context):
	Actor(context).\
		go_to(context.webUrls.vortex.com_page(context.vortex.com.id) + '/body')


@when('I cast my vote')
def step_impl(context):
	Actor(context).\
		see((By.CSS_SELECTOR, ".ballot-aside__status")).\
		click((By.CSS_SELECTOR, ".-votable"))


@then('my vote is cast')
def step_impl(context):
	Actor(context).\
		see((By.CSS_SELECTOR, ".-checked"))


@then('vote results are shown')
def step_impl(context):
	if context.vortex.coms[-1].questions[0].type == 'StarRating':
		selector = 'question'
	else:
		selector = 'answer'
	Actor(context).\
		see((By.CSS_SELECTOR, ".ballot-{}__percentage".format(selector)))


@then('vote count is updated')
def step_impl(context):
	Actor(context).\
		verify_text_in_element((By.CSS_SELECTOR, ".ballot-results-visibility__info"), "1 votes in")


@when('I cast my votes in a survey')
def step_impl(context):
	Actor(context).\
		click_and_unsee((By.CSS_SELECTOR, ".ballot-voting__cover-start")).\
		click((By.CSS_SELECTOR, ".vortex.com-bool-input")).\
		click((By.CSS_SELECTOR, ".timer-button__text")).\
		click((By.CSS_SELECTOR, ".vortex.com-bool-input"))


@then('next button is shown and removed')
def step_impl(context):
	Actor(context).\
		see((By.CSS_SELECTOR, "button.timer-button")).\
		unsee((By.CSS_SELECTOR, "button.timer-button"))
