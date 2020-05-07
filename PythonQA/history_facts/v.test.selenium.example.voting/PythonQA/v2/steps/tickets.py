import os

from behave import *
from roles.user import Actor
from selenium.webdriver.common.by import By
from shared.constants import PATH_TO_EMAILS
from shared.api_objects import ApiRequest
from time import sleep
from requests import Session
from shared.elements import USER_NAME_INPUT_FIELD, PASSWORD_INPUT_FIELD
from steps.gui_actions import login_as


@when('I request password reset')
def step_impl(context):
	Actor(context).\
		go_to(context.webUrls.landing_page).\
		click((By.CSS_SELECTOR, ".login-password-label__forgot")).\
		into((By.CSS_SELECTOR, ".qa-input-email")).type(context.user.email).\
		click((By.CSS_SELECTOR, "button.qa-btn-submit")).\
		see((By.CSS_SELECTOR, ".main__success-message"))


@then('{} ticket is generated')
def step_impl(context, ticket_type):
	fldr = PATH_TO_EMAILS
	fldr += tuple([ticket_type, context.user.email])
	path_to_file = os.path.join(*fldr, os.listdir(os.path.join(*fldr))[0])
	open(path_to_file, encoding='utf-8')


@given('I requested password reset')
def step_impl(context):
	url = context.apiUrls.reset_password
	r = ApiRequest(context.user.session, 'post', url, payload={'email': context.user.email})
	r.perform()


@when('I activate {} ticket')
def step_impl(context, ticket_type):
	sleep(1)

	fldr = PATH_TO_EMAILS
	fldr += tuple([ticket_type, context.user.email])
	try:
		path_to_file = os.path.join(*fldr, os.listdir(os.path.join(*fldr))[0])
		with open(path_to_file, encoding='utf-8')as f:
			context.ticket_email_text = f.read()
			context.ticket_url = context.ticket_email_text.split("href=")[1].split(' ')[0].replace('"', '')
			context.ticket_id = context.ticket_url.split('/')[-1]
	except FileNotFoundError:
		print("Was trying to find {} ticket for user {}".format(ticket_type, context.user.email))

	Actor(context).go_to(context.ticket_url)


@when('I navigate to invalid ticket page')
def step_impl(context):
	Actor(context).go_to(context.webUrls.base_url + '/ticket/yolo')


@then('an invalid ticket page is shown')
def step_impl(context):
	Actor(context).\
		verify_text_in_element((By.CSS_SELECTOR, ".main__error"), "the ticket is invalid for some reason").\
		see((By.CSS_SELECTOR, ".qa-switch-to-signup"))


@when('I input a new password')
def step_impl(context):
	Actor(context).\
		into((By.CSS_SELECTOR, "#auth-form-password")).type("1234567").\
		click((By.CSS_SELECTOR, "button.qa-btn-submit")).\
		see((By.CSS_SELECTOR, ".main__success-message"))
	context.user.password = '1234567'


@then('my password is changed')
def step_impl(context):
	credentials = {'email': context.user.email, 'password': context.user.password}
	r = ApiRequest(Session(), 'post', context.apiUrls.login, payload=credentials)
	r.perform()
	assert r.status_code == 200


@when('I choose to create a new account')
def step_impl(context):
	Actor(context).click_and_unsee((By.CSS_SELECTOR, "button.qa-switch-to-new-signup"))


@when('I choose to get started')
def step_impl(context):
	Actor(context).click_and_unsee((By.CSS_SELECTOR, "button.qa-switch-to-signup"))


@when('I choose to merge into an existing account')
def step_impl(context):
	Actor(context).click_and_unsee((By.CSS_SELECTOR, "button.qa-switch-to-login"))


@when('I choose to merge into a different account')
def step_impl(context):
	Actor(context).click_and_unsee((By.CSS_SELECTOR, ".qa-switch-to-new-login"))


@when('I fill in my name and password')
def step_impl(context):
	Actor(context). \
		into(USER_NAME_INPUT_FIELD).type(context.user.name).\
		into(PASSWORD_INPUT_FIELD).type(context.user.password)


@then('login form with {:w} email prefilled is shown')
def step_impl(context, user):
	u_email = context.user2.email if user == 'user' else context.user.email
	Actor(context).\
		verify_value_in_element((By.CSS_SELECTOR, "#auth-form-email"), u_email)


@when('I choose add to current account')
def step_impl(context):
	Actor(context).click_and_unsee((By.CSS_SELECTOR, ".qa-merge"))


@then('my email is verified')
def step_impl(context):
	r = ApiRequest(context.user.session, 'get', context.apiUrls.private_me)
	r.perform()
	assert r.response['hasVerifiedEmail'] is True


@given('user is logged in though the UI')
def step_impl(context):
	login_as(context, context.user2.email)
