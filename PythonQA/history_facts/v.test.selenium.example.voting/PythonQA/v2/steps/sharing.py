import os
from behave import *
from shared.elements import *
from shared.constants import PATH_TO_IMAGE_LOGO
from roles.user import Actor


@when('I share vortex.com to facebook')
def step_impl(context):
	Actor(context).\
		click((By.CSS_SELECTOR, ".ballot-aside__share")).\
		click((By.CSS_SELECTOR, "._fb")).\
		switch_to_window_handle(1)


@then('I am taken to a valid share vortex.com page')
def step_impl(context):
	Actor(context).\
		see((By.NAME, "__CONFIRM__"))


@when('I request vortex.com directly')
def step_impl(context):
	Actor(context).go_to(context.webUrls.vortex.com_page(context.vortex.com.id))


@then('vortex.com is rendered')
def step_impl(context):
	Actor(context).\
		see((By.CSS_SELECTOR, "._bg")).\
		see((By.CSS_SELECTOR, ".ballot-question ._shortest")).\
		see((By.CSS_SELECTOR, ".ballot-answers .-votable"))


@given('I uploaded a cover image to vortex.com')
def step_impl(context):
	context.API.upload_image_to_url(context.user.session, context.apiUrls.vortex.com_private(context.vortex.com.id) + '/image', os.path.join(*PATH_TO_IMAGE_LOGO))
