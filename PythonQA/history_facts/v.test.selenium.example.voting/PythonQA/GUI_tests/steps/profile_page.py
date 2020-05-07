import os

from behave import *
from selenium.webdriver.common.by import By
from shared.elements import CHANNEL_LOGO

from roles.user import Actor
from shared.constants import PATH_TO_IMAGE_BACKGROUND


@when('I upload profile {:w} image')
def step_impl(context, img_type):
	if img_type == 'background':
		css_selector = (By.CSS_SELECTOR, ".cover input")
	elif img_type == 'logo':
		css_selector = (By.CSS_SELECTOR, ".img-input--avatar input")
	else:
		raise Exception("Unexpected argument, expected logo or background, got {}".format(img_type))

	Actor(context).\
		into_invisible(css_selector).attach_image(os.path.join(os.getcwd(), *PATH_TO_IMAGE_BACKGROUND))


@then('profile {:w} is set')
def step_impl(context, img_type):
	if img_type == 'background':
		css_selector = (By.CSS_SELECTOR, ".short-profile[style]")
	elif img_type == 'logo':
		css_selector = CHANNEL_LOGO
	else:
		raise Exception("Unexpected argument, expected logo or background, got {}".format(img_type))

	Actor(context).\
		see(css_selector)
