from behave import *

from gui_actions import *
from shared.api_objects import *


@given('I am {} user')
def step_impl(context, user_type):
	if user_type == 'verified':
		context.user = User()
		context.user.register(context)
		if 'nonbrowser' not in context.tags:
			context.user.authorize_web(context)
	elif user_type == 'non-verified':
		context.user = User(isverified=False)
		context.user.register(context)
	elif user_type == 'non-registered':
		context.user = User(isverified=False)
	elif user_type == 'super':
		context.user = User()
		context.user.email = context.content_manager_email
		context.user.password = context.content_manager_password
		context.user.register(context)
		if 'nonbrowser' not in context.tags:
			context.user.authorize_web(context)
	elif user_type == 'anonymous':
		context.user = User()
		context.user.session = requests.Session()
	elif user_type == 'existing':
		context.user = context.user2
		context.existing_user = True
	else:
		context.user = User()
		context.user.register(context)


@given('{} logged in')
def step_impl(context, actor):
	if 'I' in actor:
		u = context.user
	else:
		u = context.user2
	u.authorize_web(context)


@when('I login with valid credentials')
def step_impl(context):
	login_as(context, context.user.email)


@then('I am successfully authenticated')
def step_impl(context):
	Actor(context). \
		switch_to_window_handle(0).\
		unsee(LOG_IN).\
		see((By.CSS_SELECTOR, ".ballot-answer__text"))


@then('I am taken to the user default authenticated page')
def step_impl(context):
	myassert(context, context.webUrls.home_page, context.browser.current_url,
			 msg="Expected to be on {} page, on {} instead")


@when('I sign up with valid credentials')
def step_impl(context):
	Actor(context).go_to(context.webUrls.landing_page).\
		click(SIGN_UP)
	if hasattr(context, 'existing_user'):
		Actor(context).\
			into(USER_NAME_INPUT_FIELD).type(context.user.name).\
			into(EMAIL_INPUT_FIELD).type(context.user.email).\
			into(PASSWORD_INPUT_FIELD).type(context.user.password)
	else:
		Actor(context).\
			into(USER_NAME_INPUT_FIELD).type("420"). \
			into(EMAIL_INPUT_FIELD).type("bl@ze.it"). \
			into(PASSWORD_INPUT_FIELD).type(NEW_USR_PASSWORD)
	Actor(context).click(SUBMIT)


@when('I open the {} form')
def step_impl(context, form):
	Actor(context).go_to(context.webUrls.landing_page)
	if form == 'Sign up':
		Actor(context).click((By.CSS_SELECTOR, ".qa-switch-to-signup"))


@when('I click the sign in link')
def step_impl(context):
	sleep(0.2)
	Actor(context).\
		click(FORM_SWITCH_SIGN_IN)


@then('I get a valid Sign In form')
def step_impl(context):
	Actor(context).see(FACEBOOK). \
		see(GOOGLE). \
		see(EMAIL_INPUT_FIELD). \
		see(PASSWORD_INPUT_FIELD)


@step("I login with wrong {}")
def step_impl(context, field):
	if field == 'password':
		wait_clickable(context, EMAIL_INPUT_FIELD).send_keys(context.user.email)
	else:
		wait_clickable(context, EMAIL_INPUT_FIELD).send_keys(context.user.email[:-1])
	Actor(context).\
		into(PASSWORD_INPUT_FIELD).type("_").\
		click(SUBMIT)


@step("I login with empty {:w}")
def step_impl(context, field):
	email, password = '', ''

	if field == 'password':
		email = context.user.email
	else:
		password = context.user.password

	Actor(context).\
		into(EMAIL_INPUT_FIELD).type(email).\
		into(PASSWORD_INPUT_FIELD).type(password).\
		click(SUBMIT)


@then("I get a warning saying {}")
def step_impl(context, msg):
	if msg.endswith('try again.'):
		# error message received from server
		selector = '.main__error'
	else:
		# ui validation
		selector = '.vortex.com-input-error'
	Actor(context). \
		verify_text_in_element((By.CSS_SELECTOR, selector), msg)


@given('I am a test user of vortex.work on {:w}')
def step_impl(context, social_network):
	context.user = User()
	context.user.email, context.user.password = SocialNetworkCredentials[social_network]


@when('I click the {:w} link')
def step_impl(context, social_network):
	Actor(context).\
		click((By.CSS_SELECTOR, SocialNetworkSelectors[social_network]))
	sleep(0.5)
	context.browser.switch_to.window(context.browser.window_handles[1])


@then('I get the Facebook login page')
def step_impl(context):
	if 'Facebook' not in context.browser.title:
		raise AssertionError("Title was {}".format(context.browser.title))
	myassertin(context, 'facebook.com', context.browser.current_url, msg='Url was {1}')


@given('I am authorised on facebook')
def step_impl(context):
	Actor(context). \
		go_to('http://facebook.com'). \
		into(FACEBOOK_EMAIL_INPUT).type(context.user.email). \
		into(FACEBOOK_PASSWORD_INPUT).type(context.user.password). \
		click(FACEBOOK_LOGIN_BUTTON)


@then('I get the Google login page')
def step_impl(context):
	myassertin(context, 'Google', context.browser.title, msg="Title was {1}")
	myassertin(context, 'accounts.google.com', context.browser.current_url, msg='Url was {1}')


@when('I authorise on {:w}')
def step_impl(context, social_network):
	if social_network == 'googleplus':
		Actor(context). \
			into((By.CSS_SELECTOR, "input[type=email]")).type(context.user.email). \
			click((By.CSS_SELECTOR, "#identifierNext")). \
			into((By.CSS_SELECTOR, "input[type=password]")).type(context.user.password). \
			click((By.CSS_SELECTOR, "#passwordNext"))
	elif social_network == 'linkedin':
		Actor(context).\
			into((By.NAME, "session_key")).type(context.user.email).\
			into((By.NAME, "session_password")).type(context.user.password).\
			click((By.NAME, "signin"))
	elif social_network == 'facebook':
		Actor(context).\
			see((By.CSS_SELECTOR, ".form_row")).\
			into_invisible((By.CSS_SELECTOR, "#email")).type(context.user.email).\
			into_invisible((By.CSS_SELECTOR, "#pass")).type(context.user.password).\
			click_and_unsee((By.NAME, "login"))
	else:
		raise Exception("Unexpected argument, checkout your feature file.")


@given('signup form is open')
def step_impl(context):
	Actor(context).\
		go_to(context.webUrls.landing_page).\
		click(SIGN_UP)


@given('I am on the landing page')
def step_impl(context):
	Actor(context).\
		go_to(context.webUrls.landing_page)


@when('I fill in {:w} email and password')
def step_impl(context, actor):
	user = getattr(context, 'user' if actor == 'my' else 'user2')
	Actor(context). \
		into(EMAIL_INPUT_FIELD).type(user.email).\
		into(PASSWORD_INPUT_FIELD).type(user.password)


@when('I fill in my password')
def step_impl(context):
	Actor(context).\
		into(PASSWORD_INPUT_FIELD).type(context.user.password)


@when('I click the signup button')
def step_impl(context):
	Actor(context).\
		click(SUBMIT)


@then('I get the LinkedIn login page')
def step_impl(context):
	Actor(context).\
		see((By.NAME, 'signin'))
	assert 'linkedin.com' in context.browser.current_url


@when('I click the sign out button')
def step_impl(context):
		Actor(context).\
			click((By.CSS_SELECTOR, "._profile")).\
			click((By.CSS_SELECTOR, ".dropdown-button__toggle")).\
			click_and_unsee((By.CSS_SELECTOR, ".qa-log-out"))


@then('I am no longer authenticated')
def step_impl(context):
	Actor(context).see((By.CSS_SELECTOR, ".view-login__form.view-auth__form"))
