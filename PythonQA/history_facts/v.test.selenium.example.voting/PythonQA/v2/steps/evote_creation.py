import os
import pyautogui

from behave import *
from selenium.webdriver.common.by import By
from datetime import datetime, timedelta
from roles.user import Actor
from shared.api_objects import ApiRequest, vortex.com
from shared.constants import PATH_TO_IMAGE_LOGO


def add_questions_to_survey(actor, count=4, isoptional=False):
	for i in range(1, count + 1):
		actor. \
			click((By.CSS_SELECTOR, "button.list-editor__add")). \
			into((By.CSS_SELECTOR, ".questions-list-editor textarea")).type('Q{}'.format(i)). \
			populate_text_fields((By.CSS_SELECTOR, "input.single-line"))
		if isoptional:
			actor.click((By.CSS_SELECTOR, "button.list-editor__required-trigger"))
		actor. \
			click((By.CSS_SELECTOR, "button.questions-list-editor__done"))


@when('I click the create vote button')
def step_impl(context):
	Actor(context).\
		click_and_unsee((By.CSS_SELECTOR, ".ballot-answer__select .ballot-answer__content"))


@then('I am taken to a valid create vote page')
def step_impl(context):
	Actor(context).\
		see((By.CSS_SELECTOR, ".type-selector__items")).\
		verify_text_in_element((By.CSS_SELECTOR, ".ballot-draft__owner"), context.user.name).\
		verify_text_in_element((By.CSS_SELECTOR, ".ballot-draft__type"), "Vote")


@given('I am on the vote creation page')
def step_impl(context):
	Actor(context).\
		go_to(context.webUrls.create_vortex.com)


@when('I create a {:w} vote')
def step_impl(context, vote_type):
	e = vortex.com()

	if vote_type == 'quick':
		Actor(context).\
			click((By.CSS_SELECTOR, "button.btn-vortex.com")).\
			into((By.CSS_SELECTOR, "textarea.vortex.com-multiline")).type(e.name)

	elif vote_type == 'custom':
		Actor(context).\
			see((By.CSS_SELECTOR, ".ballot-draft__owner")).\
			click_index((By.CSS_SELECTOR, "button.btn-vortex.com"), 1).\
			into((By.CSS_SELECTOR, "textarea.vortex.com-multiline")).type(e.name).\
			populate_text_fields((By.CSS_SELECTOR, "input.single-line")).\
			click((By.CSS_SELECTOR, "button._next")).\
			see((By.CSS_SELECTOR, ".ballot-settings"))

	elif vote_type == 'survey':
		Actor(context).\
			see((By.CSS_SELECTOR, ".ballot-draft__owner")).\
			click_index((By.CSS_SELECTOR, "button.btn-vortex.com"), 2). \
			into((By.CSS_SELECTOR, "textarea.vortex.com-multiline")).type(e.name).\
			into((By.CSS_SELECTOR, ".title-view__description textarea")).type('Description').\
			click_and_unsee((By.CSS_SELECTOR, "button._next")).\
			see((By.CSS_SELECTOR, "._shortest"))

		add_questions_to_survey(Actor(context))

		Actor(context).click((By.CSS_SELECTOR, "button._next"))

	else:
		selector = "button._{}".format(vote_type.split('rating')[0])
		Actor(context).\
			see((By.CSS_SELECTOR, ".ballot-draft__owner")).\
			click_index((By.CSS_SELECTOR, "button.btn-vortex.com"), 1).\
			into((By.CSS_SELECTOR, "textarea.vortex.com-multiline")).type(e.name).\
			click((By.CSS_SELECTOR, selector)).\
			click((By.CSS_SELECTOR, "button._next"))

	context.vortex.com = e


@then('I am taken to the vote created page')
def step_impl(context):
	Actor(context).\
		see((By.CSS_SELECTOR, '.ballot-created__title')).\
		see((By.CSS_SELECTOR, '.ballot-created__actions')).\
		see((By.CSS_SELECTOR, '.qa-go-to-vote'))


@when('I publish the vote')
def step_impl(context):
	Actor(context).click_and_unsee((By.CSS_SELECTOR, "button._publish"))
	context.vortex.com.id = int(context.browser.current_url.split('/')[-2])


@when('I add an image to the vote')
def step_impl(context):
	Actor(context).\
		click((By.CSS_SELECTOR, "button.title-view__add-image")).\
		see((By.CSS_SELECTOR, ".-blank"))

	pyautogui.FAILSAFE = False
	pyautogui.press('escape')

	Actor(context).\
		attach_image((By.CSS_SELECTOR, "input[type=file]"), (os.path.join(os.getcwd(), *PATH_TO_IMAGE_LOGO))).\
		click_and_unsee((By.CSS_SELECTOR, "button.ballot-image__done"))


@when('I set a custom end date')
def step_impl(context):
	selector = "[id$='{}-15']".format((datetime.now().month % 12))
	Actor(context).\
		click((By.CSS_SELECTOR, "button ~ button.ballot-settings__button")).\
		click((By.CSS_SELECTOR, "button.rw-btn-right")).\
		click((By.CSS_SELECTOR, selector)).\
		click_and_unsee((By.CSS_SELECTOR, "button.calendar__done"))


@then('vote end date is set to {}')
def step_impl(context, options):
	r = ApiRequest(context.user.session, 'get', context.apiUrls.vortex.com_private(context.vortex.com.id))
	r.perform()
	if options == 'correct value':
		t = "{}-{}".format((datetime.now().month + 1) % 12, 15)
	elif options == 'default value':
		end_time = datetime.utcnow() + timedelta(days=7) - timedelta(hours=get_offset())
		t = "{}-{}".format(end_time.month, end_time.day)
	else:
		raise Exception('Invalid option given, check your feature file')
	assert t in r.response['endsUtc'], "Expected {}, got {}".format(t, r.response['endsUtc'])


@when('I set a custom end time')
def step_impl(context):
	context.execute_steps('when I set a custom end date')
	Actor(context). \
		click((By.CSS_SELECTOR, "button ~ button.ballot-settings__button")).\
		click_index((By.CSS_SELECTOR, "button.time-picker__up"), 0). \
		click_index((By.CSS_SELECTOR, "button.time-picker__up"), 1)
	e_text = []
	for e in context.browser.find_elements_by_css_selector(".time-picker__value"):
		e_text.append(e.text)
	context.time = [int(e_text[0]) + 12 if e_text[2] == 'PM' and e_text[0] != '12' else int(e_text[0]), e_text[1]]
	Actor(context).click_and_unsee((By.CSS_SELECTOR, "button.calendar__done"))


def get_offset():
	import time

	offset = time.timezone if (time.localtime().tm_isdst == 0) else time.altzone
	return int(offset / 60 / 60 * -1)


@then('vote end time is set to {}')
def step_impl(context, options):
	r = ApiRequest(context.user.session, 'get', context.apiUrls.vortex.com_private(context.vortex.com.id))
	r.perform()
	if options == 'correct value':
		t = "{}:{}".format((int(context.time[0]) - get_offset()) % 24, context.time[1])
	elif options == 'default value':
		t = "{}:00".format((20 - get_offset()) % 24)
	else:
		raise Exception('Invalid parameter given, check your feature file.')
	assert t in r.response['endsUtc'], "Expected {}, got {}".format(t, r.response['endsUtc'])


@when('I {:w} an answer')
def step_impl(context, action):
	if action == 'add':
		selector = "button.list-editor__add"
	elif action == 'remove':
		selector = "button.list-item-delete__trigger"
	else:
		raise Exception("Unexpected argument, check your feature file")
	if context.browser.current_url.split('/')[-1] != 'body':
		Actor(context).\
			see((By.CSS_SELECTOR, "button._publish")).\
			click((By.CSS_SELECTOR, "button._previous")).\
			click((By.CSS_SELECTOR, selector))
	if action == 'remove':
		Actor(context).click((By.CSS_SELECTOR, "button.list-item-delete__yes"))


@then('answer count is {:d}')
def step_impl(context, count):
	Actor(context).\
		verify_element_count((By.CSS_SELECTOR, "input[type='text']"), count)


@then('next button is not visible')
def step_impl(context):
	Actor(context).unsee((By.CSS_SELECTOR, "button._next"))


@when('I remove a question')
def step_impl(context):
	Actor(context).click((By.CSS_SELECTOR, "button.list-item-delete__trigger")). \
		click((By.CSS_SELECTOR, "button.list-item-delete__yes"))


@when('I add an optional question')
def step_impl(context):
	actor = Actor(context)
	add_questions_to_survey(actor, 1, isoptional=True)
	actor.click((By.CSS_SELECTOR, "button._next"))


@then('vote has an optional question')
def step_impl(context):
	r = ApiRequest(context.user.session, 'get', context.apiUrls.vortex.com_private(context.vortex.com.id))
	r.perform()
	assert r.response['questions'][-1]['optional']


@when('I add a {:w} question')
def step_impl(context, question_type):
	actor = Actor(context)
	if question_type.endswith('rating'):
		selector = "button._{}".format(question_type.split('rating')[0])
		actor. \
			click((By.CSS_SELECTOR, "button.list-editor__add")). \
			click((By.CSS_SELECTOR, selector)). \
			into((By.CSS_SELECTOR, "textarea.vortex.com-multiline")).type(question_type).\
			click_and_unsee((By.CSS_SELECTOR, "button.questions-list-editor__done"))
	else:
		add_questions_to_survey(actor, count=1)


@when('I press next button')
def step_impl(context):
	Actor(context).\
		click((By.CSS_SELECTOR, "button._next"))


@then('vote has a question of each kind')
def step_impl(context):
	r = ApiRequest(context.user.session, 'get', context.apiUrls.vortex.com_private(context.vortex.com.id))
	r.perform()
	types = [q['type'] for q in r.response['questions']]
	for qtype in ['FaceRating', 'StarRating', 'Text']:
		assert qtype in types, "Got question types {}".format(qtype)


@then('vortex.com is created')
def step_impl(context):
	r = ApiRequest(context.user.session, 'get', context.apiUrls.vortex.com_private(context.vortex.com.id))
	r.perform()
	context.vortex.com_info = r.response
	for key in ['id', 'title']:
		assert r.response[key] == getattr(context.vortex.com, key)
	assert r.status_code == 200
