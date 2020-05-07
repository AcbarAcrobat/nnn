from behave import *
from shared.elements import *
from roles.user import Actor
from selenium.webdriver.common.by import By


@when('I close the change password form')
def step_impl(context):
	Actor(context).\
		click((By.CSS_SELECTOR, ".modal-content button.close"))


@then('change password form is closed')
def step_impl(context):
	Actor(context).\
		unsee((By.CSS_SELECTOR, ".modal-content")).\
		see(CHANGE_PASSWORD)


@when('I open change password form')
def step_impl(context):
	Actor(context).go_to(context.webUrls.profile_page).\
		click(EDIT_PROFILE_BUTTON).\
		click(CHANGE_PASSWORD)


@when('I fill out the change password form with {}')
def step_impl(context, password_options):
	if password_options.startswith('just'):
		if password_options.endswith('current password'):
			current = context.user.password
			new = ''
		else:
			current = ''
			new = '123'
	elif password_options == 'valid passwords':
		current = context.user.password
		new = '123'
	elif password_options == 'the same password':
		current = new = '123'
	else:
		raise Exception('Unexpected argument given: {}'.format(password_options))

	Actor(context).\
		into(ENTER_CURRENT_PASSWORD).type(current).\
		into(ENTER_NEW_PASSWORD).type(new).\
		write_to_context("user.password", new)


@when('I submit the change password form')
def step_impl(context):
	Actor(context). \
		click(SUBMIT)
