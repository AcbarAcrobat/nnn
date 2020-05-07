from shared.general_helpers import generate_random_name
from shared.api_objects import Channel, vortex.com

from roles.user import Actor
from gui_helpers import *


def create_vortex.com(
		context, ballot_type='Poll', channel_id=None, **kwargs):
	if channel_id:
		navigate_to_url(context, context.webUrls.base_url + '/channel/' + str(channel_id))
		wait_visible(context, PROFILE_EDIT)
	else:
		navigate_to_url(context, context.webUrls.profile_page)
	# based on ballot type, input questions and answers/petition text
	# generate title
	Actor(context).\
		click(BALLOT_CREATE_NEW).\
		click(BALLOT_NEXT).\
		write_to_context('vortex.com_name', generate_random_name(12)).\
		write_to_context('vortex.com_question', 'QQ')
	context.vortex.com = vortex.com()
	wait_visible(context, BALLOT_IMAGE_PICKER)
	context.vortex.com.id = int(context.browser.current_url.split('/')[-2])
	find_element(context, BALLOT_UPLOAD_BACKGROUND_IMAGE).send_keys(os.path.join(os.getcwd(), *PATH_TO_IMAGE_BACKGROUND))
	wait_invisible(context, IMAGE_IS_BLANK)
	Actor(context).see((By.CSS_SELECTOR, ".vortex.com-input-addons-wrapper")).\
		into(BALLOT_TITLE_INPUT_FIELD).type(context.vortex.com_question).\
		click(BALLOT_NEXT).\
		see((By.CSS_SELECTOR, ".step ~ .is-active"))
	if 'no_title' not in kwargs.keys():
		wait_clickable(context, USE_TITLE_AS_Q).click()
		find_element(context, QUESTION_TEXT_INPUT_FIELD).send_keys('Q')
	wait_visible(context, (By.CSS_SELECTOR, ".questions-answer"))
	answers = find_elements(context, (By.CSS_SELECTOR, "input[type=text]"))
	for a in answers:
		a.send_keys('A')
	wait_invisible(context, (By.CSS_SELECTOR, ".vortex.com-md-editor .focused"))
	if 'answers' in kwargs.keys():
		return
	if ballot_type == 'Survey':
		sleep(BALLOT_ANIMATION)
		Actor(context).click(BALLOT_EDITOR_TITLE).\
			click(BALLOT_ADD_QUESTION).\
			unsee(USE_TITLE_AS_Q).\
			into(QUESTION_TEXT_INPUT_FIELD).type(context.vortex.com_question)
		fill_fields_with_text(context, ANSWER_TEXT_INPUT_FIELD, 'B')
		find_element(context, BALLOT_EDITOR_TITLE).click()
	Actor(context).\
		click(BALLOT_NEXT).\
		see((By.CSS_SELECTOR, ".step ~ " * 2 + ".is-active")).\
		click(BALLOT_NEXT).\
		see((By.CSS_SELECTOR, ".step ~ " * 3 + ".is-active"))
	if 'publish' in kwargs.keys():
		Actor(context).\
			see((By.CSS_SELECTOR, ".ballot-publish-info")).\
			click_and_unsee(PUBLISH_BALLOT)


def create_channel(
		context, channel_about=CHANNEL_ABOUT, **kwargs):
	navigate_to_url(context, context.webUrls.create_channel_page)
	context.channel = Channel()
	context.channel.name = generate_random_name(12)
	wait_clickable(context, CHANNEL_NAME_INPUT_FIELD).send_keys(context.channel.name)

	# upload logo
	find_element(context, CHANNEL_LOGO_INPUT).send_keys(os.path.join(os.getcwd(), *PATH_TO_IMAGE_LOGO))
	# make sure that image is no longer being processed
	wait_invisible(context, IMAGE_IS_BLANK)
	context.channel.has_logo = True

	# bio is optional
	if 'add_description' in kwargs.keys():
		find_element(context, CHANNEL_DESCRIPTION_INPUT_FIELD).send_keys(channel_about)
	# publishing is optional
	if 'publish' in kwargs.keys():
		wait_clickable(context, CHANNEL_SAVE).click()


def login_as(context, user_email):
	context.browser.get(context.webUrls.landing_page)
	wait_clickable(context, LOG_IN).click()
	while wait_visible(context, EMAIL_INPUT_FIELD).get_attribute('value') != user_email:
		wait_visible(context, EMAIL_INPUT_FIELD).clear()
		wait_visible(context, EMAIL_INPUT_FIELD).send_keys(user_email)
	Actor(context).into(PASSWORD_INPUT_FIELD).type(context.content_manager_password if user_email == context.content_manager_email else context.user.password).\
		click_and_unsee(SUBMIT).\
		see(PROFILE_AVATAR_DROPDOWN)
