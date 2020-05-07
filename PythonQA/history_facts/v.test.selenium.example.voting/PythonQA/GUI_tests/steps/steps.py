from datetime import date, timedelta, datetime
from string import capwords

from behave import *
from selenium.webdriver.common.keys import Keys
from shared.api_actions import *
from shared.api_objects import *

from roles.user import ElementAction
from gui_actions import *


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
	else:
		context.user = User()
		context.user.register(context)


@given('I am vortex.com employee')
def step_impl(context):
	u = User()
	u.email = u.email[:u.email.find('@')] + '@vortex.com'
	u.register(context)
	context.API.verify_email_with_ticket(u.session, u.email)
	context.user = u
	if 'nonbrowser' not in context.tags:
		context.user.authorize_web(context)

	j = {'isContentManager': True, 'id': context.user.id}
	r = ApiRequest(context.superuser.session, 'post', context.apiUrls.private_users(context.user.id), payload=j)
	r.perform()


@given('I am content manager')
def step_impl(context):
	context.execute_steps(u'''
	Given I am super user''')
	context.user.authorize_web(context)


@given('I am authorized on vortex.com')
def step_impl(context):
	context.user.authorize_web(context)


@when('I login with valid credentials')
def step_impl(context):
	login_as(context, context.user.email)


@then('I am taken to the user default authenticated page')
def step_impl(context):
	myassert(context, context.webUrls.home_page, context.browser.current_url,
			 msg="Expected to be on {} page, on {} instead")


@when('I create a channel with {} required fields provided')
def step_impl(context, fields):
	if fields == 'all':
		create_channel(context, publish=True, add_description=True)
	# expecting minimum fields here
	else:
		create_channel(context, publish=True)


@when('I search for something')
def step_impl(context):
	Actor(context).click(SEARCH_BUTTON). \
		into(SEARCH).type('yolo')


@when('I add a comment to it')
def step_impl(context):
	Actor(context).see(ADD_COMMENT). \
		write_to_context('comment_count', get_count(context, COMMENT_COUNT)). \
		write_to_context('comment', generate_random_name(16)). \
		into(COMMENT_INPUT_FIELD).type(context.comment). \
		click(ADD_COMMENT)


@then('my comment is added to the page')
def step_impl(context):
	Actor(context).see(BALLOT_COMMENT)


@when('I navigate to the {:w} page')
def step_impl(context, page):
	if page == 'explore':
		navigate_to_url(context, context.webUrls.explore_page)
	elif page == 'home':
		navigate_to_url(context, context.webUrls.home_page)
	elif page == 'default_authenticated_page':
		navigate_to_url(context, context.webUrls.default_authenticated_page)
	elif page == 'my_private_initiatives':
		sleep(5)
		navigate_to_url(context, context.webUrls.profile_private_initiatives_page)
	elif page == 'notifications':
		navigate_to_url(context, context.webUrls.notifications)
	else:
		navigate_to_url(context, context.webUrls.profile_page)


@then('I am navigated to a valid explore page')
def step_impl(context):
	Actor(context).see(INITIATIVE). \
		see(TAG_LARGESCREEN if context.browser.get_window_size()['width'] > 1200 else TAG_SMALLSCREEN). \
		see(CHANNEL)


@given('I am on the explore page')
def step_impl(context):
	context.execute_steps(u'''
	when I navigate to the explore page
	then I am navigated to a valid explore page
	''')


@given('I am on the home page')
def step_impl(context):
	# if not on home page currently, navigate to home page
	if context.browser.current_url != context.webUrls.home_page:
		Actor(context).go_to(context.webUrls.home_page)


@given('I am on the profile page')
def step_impl(context):
	Actor(context).go_to(context.webUrls.profile_page)


@when('I access the backend api page')
def step_impl(context):
	Actor(context).go_to(context.webUrls.api)


@then('I receive data from backend')
def step_impl(context):
	myassertin(context, AUTH_STATUS_ANON, context.browser.page_source, msg="Not receiving status data from backend")


@then('I am successfully authenticated')
def step_impl(context):
	Actor(context).switch_to_window_handle(0). \
		see(PROFILE_AVATAR_DROPDOWN). \
		unsee(LOG_IN)


@when('I sign up with valid credentials')
def step_impl(context):
	Actor(context).go_to(context.webUrls.landing_page). \
		click(SIGN_UP)
	if hasattr(context, 'existing_user'):
		Actor(context).into(EMAIL_INPUT_FIELD).type(context.user.email). \
			into(USER_NAME_INPUT_FIELD).type(context.user.name). \
			into(PASSWORD_INPUT_FIELD).type(context.user.password)
	else:
		Actor(context).into(EMAIL_INPUT_FIELD).type(NEW_USR_EMAIL). \
			into(USER_NAME_INPUT_FIELD).type(NEW_USR_LOGIN). \
			into(PASSWORD_INPUT_FIELD).type(NEW_USR_LOGIN)
	Actor(context).click(SUBMIT)


@given('there is {:w} {:w} with {}')
def step_impl(context, ends_status, vortex.com_type, vortex.com_options):
	# generic vortex.com = poll
	if vortex.com_type == 'vote' or vortex.com_type == 'vortex.com':
		vortex.com_type = 'poll'
	if 'results visibility' in vortex.com_options:
		rv = vortex.com_options.split('to ')[1]
		custom_date = None
		if 'starts' in rv:
			rv = 'Started'
		elif 'casts' in rv:
			rv = 'Voted'
		elif 'finishes' in rv:
			rv = 'Finished'
		elif 'after current date' in rv:
			rv = 'Custom'
			custom_date = datetime.utcnow() + timedelta(1)
		elif 'before current date' in rv:
			rv = 'Custom'
			custom_date = datetime.utcnow() + timedelta(-1)
		else:
			rv = 'Never'

		vortex.com = vortex.com(vortex.com_type=vortex.com_type)
		vortex.com.set_rvisibility(rv, custom_date)
		vortex.com.publish(context, context.user2.session)
		context.vortex.com = vortex.com

	else:
		context.vortex.com = vortex.com(vortex.com_type=vortex.com_type.capitalize())
		context.vortex.com.publish(context, context.user2.session)


@given('there is a {} vortex.com with {:d} answers')
def step_impl(context, options, total_answers):
	if 'choice' in options:
		q = Question()
		max_votes = 1 if options == 'single choice' else total_answers
	elif 'up to' in options:
		max_votes = int(options.split(' ')[2])
		q = Question(multipleanswers=True)
	else:
		raise Exception("Option not matched, check feature file.")

	q.add_answers(total_answers - 1)
	q.maxVotes = max_votes
	e = vortex.com(vortex.com_type='Poll')
	e.set_question(q)
	context.vortex.com = e
	context.vortex.com.publish(context, context.user.session)

	Actor(context).go_to(context.webUrls.vortex.com_page(context.vortex.com.id))


@when('I create a vote with all required fields provided')
def step_impl(context):
	if hasattr(context, 'channel'):
		create_vortex.com(context, publish=True, channel_id=context.channel.id)
	else:
		create_vortex.com(context, publish=True)


@then('I get navigated to a valid {} page')
def step_impl(context, page_type):
	if page_type == 'channel edit':
		Actor(context). \
			see(CHANNEL_PHOTO_WRAPPER). \
			see(CHANNEL_COVER_WRAPPER). \
			see(CHANNEL_DESCRIPTION_INPUT_FIELD). \
			see(CHANNEL_NAME_INPUT_FIELD). \
			see(CHANNEL_SAVE)
		find_element(context, CHANNEL_LOGO_INPUT)
	elif page_type.endswith('channel'):
		Actor(context). \
			see(BALLOT_CREATE_NEW). \
			see(PROFILE_EDIT)
		if hasattr(context, 'channel.has_logo'):
			Actor(context).see(CHANNEL_LOGO)
		myassertin(context, '/channel/', context.browser.current_url)
		myassert(context, context.channel.name, wait_visible(context, (By.CSS_SELECTOR, ".name")).text)
	# vortex.com
	else:
		vortex.com_id_selector = '.qa-ballot-id-' + str(context.vortex.com.id)
		Actor(context).unsee(PUBLISH_BALLOT). \
			click((By.CSS_SELECTOR, vortex.com_id_selector)). \
			see((By.CSS_SELECTOR, ".ballot-item-question"))
		myassertin(context, 'modal=vortex.com&id', context.browser.current_url, 'Failed to arrive at vortex.com page')


@when('I select {} answers')
def step_impl(context, multi_answer):
	wait_visible(context, BALLOT_ANSWER_SELECTOR)
	wait_visible(context, SINGLE_ANSWER_QUESTION)
	questions = find_elements(context, SINGLE_ANSWER_QUESTION)
	questions.extend(find_elements(context, MULTIPLE_ANSWER_QUESTION))
	for question in questions:
		answers = question.find_elements(*BALLOT_ANSWER_SELECTOR)
		if multi_answer == 'valid':
			answers[0].click()
		else:
			for i in range(int(multi_answer)):
				answers[i].click()


@when('I select a valid answer')
def step_impl(context):
	sleep(MODAL_ANIMATION)
	wait_clickable(context, SINGLE_ANSWER_QUESTION)
	wait_clickable(context, BALLOT_ANSWER_SELECTOR)
	questions = find_elements(context, SINGLE_ANSWER_QUESTION)
	questions[0].find_elements(*BALLOT_ANSWER_SELECTOR)[0].click()


@when('I cast my vote')
def step_impl(context):
	Actor(context).write_to_context('vote_count', get_count(context, VOTE_COUNT)). \
		click(VOTE_CAST)


@then('I get a valid thank you for voting view')
def step_impl(context):
	Actor(context).see(BALLOT_VOTED)
	myassert(context, context.API.check_voted_status(context.user.session, context.vortex.com.id),
			 msg='Voted status returned False')


@when('I open the {} form')
def step_impl(context, form):
	Actor(context).go_to(context.webUrls.landing_page). \
		click(SIGN_UP if form == 'Sign Up' else LOG_IN)


@when('I click the {:w} link')
def step_impl(context, social_network):
	Actor(context).click(GOOGLE if social_network == 'Google' else FACEBOOK)
	sleep(0.5)
	context.browser.switch_to.window(context.browser.window_handles[1])


@then('I get the Google login page')
def step_impl(context):
	myassertin(context, 'Google', context.browser.title, msg="Title was {1}")
	myassertin(context, 'accounts.google.com', context.browser.current_url, msg='Url was {1}')


@then('I get the Facebook login page')
def step_impl(context):
	if 'Facebook' not in context.browser.title:
		raise AssertionError("Title was {}".format(context.browser.title))
	myassertin(context, 'facebook.com', context.browser.current_url, msg='Url was {1}')


@when('I click the Sign In link')
def step_impl(context):
	sleep(0.2)
	Actor(context). \
		click(FORM_SWITCH_SIGN_IN)


@then('I get a valid Sign In form')
def step_impl(context):
	Actor(context).see(FACEBOOK). \
		see(GOOGLE). \
		see(EMAIL_INPUT_FIELD). \
		see(PASSWORD_INPUT_FIELD)


@when('I login with empty credentials')
def step_impl(context):
	find_element(context, SUBMIT).click()


@then('I get a warning saying Field required')
def step_impl(context):
	Actor(context).within(EMAIL_INPUT_FIELD_HEADER).text_is('Required'). \
		within(PASSWORD_INPUT_FIELD_HEADER).text_is('Required')


@then('I get a warning saying Invalid email')
def step_impl(context):
	wait_text(context, EMAIL_INPUT_FIELD_HEADER, 'Invalid email')


@when('I {} with special symbols in credentials')
def step_impl(context, action):
	Actor(context).into(EMAIL_INPUT_FIELD).type('$#$%^#^*$$^&%&*)(_&_)&+)^*(^&*%#'). \
		click(SUBMIT)


@when('I sign up with empty credentials')
def step_impl(context):
	Actor(context).click(SUBMIT)


@when('I {} with credentials that are too long')
def step_impl(context, action):
	Actor(context).into(EMAIL_INPUT_FIELD).type(INVALID_STRING_TOO_LONG). \
		click(SUBMIT)


@when('I save the vortex.com as a draft')
def step_impl(context):
	Actor(context). \
		see((By.CSS_SELECTOR, ".entity-preview-info")). \
		click((By.CSS_SELECTOR, "button.previous")). \
		see((By.CSS_SELECTOR, ".ballot-options")). \
		click_and_unsee(SAVE_BALLOT_AS_DRAFT). \
		unsee(BALLOT_NEXT)


@then('the vortex.com appears in drafts')
def step_impl(context):
	Actor(context). \
		see((By.CSS_SELECTOR, ".qa-ballot-id-" + str(context.vortex.com.id))). \
		verify_text_in_element((By.CSS_SELECTOR, ".nav-text.active .tab-additional"), "1")


@given('I create a {} with all required fields provided')
def step_impl(context, vortex.com_privacy_type):
	if len(vortex.com_privacy_type.split()) == 2:
		vortex.com_privacy = vortex.com_privacy_type.split()[0]
		vortex.com_type = vortex.com_privacy_type.split()[1]
	else:
		vortex.com_privacy = 'public'
		vortex.com_type = vortex.com_privacy_type
	if vortex.com_type == 'vote' or vortex.com_type == 'vortex.com':
		vortex.com_type = 'poll'
	if hasattr(context, 'channel'):
		create_vortex.com(
			context, ballot_privacy=vortex.com_privacy, ballot_type=vortex.com_type.capitalize(), channel_id=context.channel.id)
	else:
		create_vortex.com(context, ballot_privacy=vortex.com_privacy, ballot_type=vortex.com_type.capitalize())


@then('my channel {}')
def step_impl(context, status):
	if status == 'appears':
		myassert(context, wait_text(context, SEARCH_RESULT_CHANNEL, context.channel_name),
				 msg='Channel name did not appear in results')
	else:
		wait_visible(context, (By.CSS_SELECTOR, ".search-type-selector"))
		sleep(1)
		wait_invisible(context, SEARCH_RESULT_CHANNEL)


@when('I publish the {}')
def step_impl(context, vortex.com_type):
	if hasattr(context, 'channel') and context.channel.isPrivate:
		Actor(context). \
			see((By.CSS_SELECTOR, ".all-members-disclaimer")). \
			click(PUBLISH_BALLOT)
	else:
		Actor(context). \
			see((By.CSS_SELECTOR, ".member-title")). \
			click(PUBLISH_BALLOT)


@given('I have published the draft')
def step_impl(context):
	j = {'publishedUtc': datetime.utcnow() + timedelta(seconds=1)}
	context.vortex.com.update(context, context.user.session, j)
	sleep(2)


@when('I create a private channel with all required fields provided')
def step_impl(context):
	create_channel(context, publish=True, add_description=True, private=True)


@then('the channel is {}')
def step_impl(context, channel_status):
	if channel_status == 'removed':
		assert not context.API.does_public_channel_exist(context.channel.id), "Channel %d should not exist" % (
			context.channel.id)
	elif channel_status == 'not removed':
		assert context.API.does_public_channel_exist(context.channel.id), "Channel %d should exist" % (
			context.channel.id)
	else:
		raise Exception('Not supported channel status check: %s' % (channel_status))


@when('I am on the {} page')
def step_impl(context, page_type):
	if page_type == 'channel':
		navigate_to_url(context, get_channel_url(context, context.channel.id))
		Actor(context). \
			see((By.CSS_SELECTOR, "a.nav-text[href$='/review']"))
	else:
		assert "vortex.com&id=%s" % context.vortex.com.id in context.browser.current_url, "Url was {}".format(
			context.browser.current_url)


@when('I sign the petition')
def step_impl(context):
	Actor(context).click(PETITION_SIGN)


@then('I get a valid thank you for signing the petition view')
def step_impl(context):
	# wait_text(context, VOTE_COUNT, str(context.vote_count + 1))
	Actor(context).unsee(PETITION_SIGN). \
		see(PETITION_RESULTS)


@given('{actor:w} created a {privacy:w} channel')
def step_impl(context, actor, privacy):
	if privacy == 'personal':
		context.channel = Channel()
		context.channel.id = context.user.id if actor == 'I' else context.user2.id
	else:
		context.channel = Channel(isprivate=(privacy == 'private'))
		if actor == 'I':
			context.channel.publish(context, context.user.session)
		else:
			context.channel.publish(context, context.user2.session)

	context.channels.append(context.channel)


@given('vortex.com has property isPublic set to False')
def step_impl(context):
	j = {'isPublic': False}
	context.vortex.com.update(context, context.user.session, j)


@given('I navigate to vortex.com page')
def step_impl(context):
	# if vortex.com was created through api
	navigate_to_url(context, context.webUrls.vortex.com_page(context.vortex.com.id))
	wait_visible(context, BALLOT_TITLE)


@given('I navigate to draft page')
def step_impl(context):
	Actor(context).go_to(context.webUrls.vortex.com_page(context.vortex.com.id)). \
		see(BALLOT_TITLE)


@when('I invite another user to become {}')
def step_impl(context, role):
	wait_clickable(context, CHANNEL_PARTICIPANTS).click()
	if 'owner' in role:
		find_element(context, CHANNEL_ADD_ADMINS).click()
	elif 'administrator' in role:
		find_element(context, CHANNEL_ADD_ADMINS).click()
	elif 'contributor' in role:
		find_element(context, CHANNEL_ADD_CONTRIBUTORS).click()
	else:
		find_element(context, CHANNEL_ADD_PARTICIPANTS).click()
	Actor(context).into((By.CSS_SELECTOR, ".participants-editor input[type='text']")).type(context.user2.email). \
		click_and_unsee((By.CSS_SELECTOR, ".participant-actions-container button.security-actions"))


@when('that user logs in and navigates to the channel')
def step_impl(context):
	# login as the invitee
	login_as(context, context.user2.email)
	Actor(context).see(PROFILE_AVATAR_DROPDOWN). \
		go_to(get_channel_url(context, context.channel.id))


@given('I invited {:w} user to become {:w} in my {:w}')
def step_impl(context, user_type, role, entity):
	if user_type == 'orphaned':
		context.user2 = User()
	context.role = role
	context.API.change_entity_permissions(context.user.session, entity, getattr(context, entity).id,
										  context.user2.email, role)


@when('I remove user from vortex.com')
def step_impl(context):
	context.API.change_entity_permissions(
		context.user.session, 'vortex.com', context.vortex.com.id, context.user2.email, context.role, delete=True)


@given('I have been removed from the {:w}')
def step_impl(context, entity):
	context.API.change_entity_permissions(context.user2.session, entity, getattr(context, entity).id,
										  context.user.email, context.role, delete=True)


@given('I am a test user of vortex.work on {:w}')
def step_impl(context, social_network):
	context.user = User()
	if social_network == 'facebook':
		context.user.email = FACEBOOK_USER_EMAIL
		context.user.password = FACEBOOK_USER_PASSWORD
	else:
		context.user.email = GOOGLE_USER_EMAIL
		context.user.password = GOOGLE_USER_PASSWORD


@given('I am authorised on facebook')
def step_impl(context):
	Actor(context). \
		go_to('http://facebook.com'). \
		into(FACEBOOK_EMAIL_INPUT).type(context.user.email). \
		into(FACEBOOK_PASSWORD_INPUT).type(context.user.password). \
		click(FACEBOOK_LOGIN_BUTTON)


@when('I authorise on google plus')
def step_impl(context):
	Actor(context). \
		into_invisible((By.CSS_SELECTOR, "input#Email")).type(context.user.email). \
		click((By.CSS_SELECTOR, "input#next")). \
		see((By.CSS_SELECTOR, "a#link-forgot-passwd")). \
		into_invisible((By.CSS_SELECTOR, "input#Passwd")).type(context.user.password). \
		click((By.CSS_SELECTOR, "input#signIn"))


@when('I click a tag')
def step_impl(context):
	tags_list = find_elements(
		context, TAG_LARGESCREEN if context.browser.get_window_size()['width'] > 1200 else TAG_SMALLSCREEN)
	context.tag_name = tags_list[1].text
	tags_list[1].click()


@when('I add a tag to it')
def step_impl(context):
	Actor(context).write_to_context('test_tag', generate_random_name(12)). \
		into(TAG_INPUT_FIELD).type('#' + context.test_tag)


@then('the tag is attached to the vortex.com')
def step_impl(context):
	wait_text(context, TAG_BALLOT_PAGE, context.test_tag)


@when('I follow a channel')
def step_impl(context):
	Actor(context).click(GENERIC_FOLLOW_BUTTON). \
		unsee(BUTTON_IN_PROGRESS)


@then('vortex.coms from that channel appear in my home feed')
def step_impl(context):
	# if not on home page, navigate there
	context.API.check_home_feed_emptyness(context.user.session)
	if 'home' not in context.browser.current_url:
		navigate_to_url(context, context.webUrls.home_page)
	assert wait_visible(context, INITIATIVE), "No initiatives were present on home page"


@when('I {:w} the channel')
def step_impl(context, action):
	if action == 'delete':
		wait_clickable(context, PROFILE_EDIT).click()
		wait_clickable(context, CHANNEL_DELETE).click()
		wait_clickable(context, ENTITY_CONFIRM_DELETION)
		sleep(0.5)
		find_elements(context, ENTITY_CONFIRM_DELETION)[0].click()
		sleep(3)
	# follow/unfollow actions are the same
	else:
		channel_url = get_channel_url(context, context.channel.id)
		navigate_to_url(context, channel_url)
		wait_clickable(context, CHANNEL_PROFILE)
		try:
			context.channel_follower_count = int(wait_visible(context, CHANNEL_FOLLOWER_COUNT).text)
		except ValueError:
			sleep(0.5)
			context.channel_follower_count = int(wait_visible(context, CHANNEL_FOLLOWER_COUNT).text)
		find_element(context, CHANNEL_PROFILE).click()
		wait_invisible(context, BUTTON_IN_PROGRESS)


@then('vortex.coms from that channel disappear from my home feed')
def step_impl(context):
	Actor(context).go_to(context.webUrls.home_page). \
		unsee(INITIATIVE)


@then('vortex.com {} count is incremented by 1')
def step_impl(context, count_of_interest):
	if count_of_interest == 'vote':
		wait_visible(context, BALLOT_VOTED)
		expected_string = str(context.vote_count + 1) + ' Vote'
		if context.vote_count != 0:
			expected_string += 's'
		assert wait_text(context, VOTE_COUNT, expected_string)
	else:
		expected_string = str(context.comment_count + 1) + ' Comments'
		assert wait_text(context, COMMENT_COUNT, expected_string)


@when('I request a hedgehog user 2147552113 directly')
def step_impl(context):
	context.r = requests.get(context.apiUrls.api_url + 'users/2147552113')


@when('I request user photo')
def step_impl(context):
	user = context.r.json()
	assert 'photoInfo' in user
	assert user['photoInfo'] is not None
	assert 'link' in user['photoInfo']
	assert user['photoInfo']['link'] is not None
	context.r = requests.get(context.cdnUrl + user['photoInfo']['link'])


@then('image response header is not set to no-cache')
def step_impl(context):
	assert 'Cache-Control' in context.r.headers
	assert context.r.headers['Cache-Control'] != 'no-cache'


@when('that user accepts the invitation')
def step_impl(context):
	Actor(context).click_and_unsee(CHANNEL_ACCEPT_INVITE)


@then('user sees channel name in dropdown menu')
def step_impl(context):
	css_selector = '.my-channel.qa-channel-id-' + str(context.channel.id)
	Actor(context).click(PROFILE_AVATAR_DROPDOWN). \
		see((By.CSS_SELECTOR, css_selector))


@then('user becomes a channel follower')
def step_impl(context):
	url = context.apiUrls.api_url + 'private/security/channel/' + str(context.channel.id)
	r = context.user2.session.get(url)
	assert len(r.json()) == 2, "Expected 2 followers, got {} instead".format(len(r.json()))


@then('a special border is applied to {:w} password field')
def step_impl(context, field):
	field_name = 'newPassword' if field == 'new' else 'password'
	wait_visible(context, (By.CSS_SELECTOR, ".has-error [name={}]".format(field_name)))


@then('my password is changed')
def step_impl(context):
	# if this is a web test, wait for form to go away
	if 'nonbrowser' not in context.tags:
		Actor(context). \
			unsee(SUBMIT)
	assert not context.API.login(context.user.email, password='123456'), "Could login with old password"


@then('an error message saying {} is shown')
def step_impl(context, text):
	assert wait_visible(context, (By.CSS_SELECTOR, ".error-message")).text == text


@when('I click the sign out button')
def step_impl(context):
	Actor(context).go_to(context.webUrls.default_authenticated_page). \
		click(PROFILE_AVATAR_DROPDOWN). \
		click_and_unsee(SIGN_OUT)


@then('I am no longer authenticated')
def step_impl(context):
	Actor(context).see(SUBMIT). \
		go_to(context.apiUrls.status)
	assert 'Authenticated' not in context.browser.page_source, 'Did not log out'


@then('privacy checkbox is {}')
def step_impl(context, checkbox_status):
	if checkbox_status == 'checked':
		assert find_element(context, CHANNEL_PRIVACY_CHECKBOX_STATUS).is_selected()
	else:
		assert not find_element(context, CHANNEL_PRIVACY_CHECKBOX_STATUS).is_selected()


@then('the vortex.com appears in {:w} vortex.coms in user profile')
def step_impl(context, page_type):
	selector = ""

	if page_type == 'private':
		context.API.check_vortex.com_in_private_index(context.user.session, context.vortex.com.name, context.vortex.com.id)
	elif page_type == 'draft':
		context.API.check_draft_in_private_index(context.user.session, context.user.id)
		selector = '/draft'

	navigate_to_url(context, context.webUrls.profile_page)
	wait_clickable(context, (By.CSS_SELECTOR, ".tab-bar .tab-link[href^='/profile{}']".format(selector))).click()
	assert wait_clickable(context, BALLOT_TITLE)


@given('I create a {} with {} not set')
def step_impl(context, vortex.com_type, field_name):
	create_vortex.com(context, vortex.com_type=vortex.com_type, no_end_date=True)


@given('I create a {} with comments disabled')
def step_impl(context, vortex.com_type):
	create_vortex.com(context, vortex.com_type=vortex.com_type.capitalize(), no_comments=True, publish=True)


@then('an alert with text {} appears')
def step_impl(context, alert_text):
	wait_visible(context, ALERT_ERROR_MESSAGE)
	assert alert_text in find_element(context, ALERT_ERROR_MESSAGE).text, "Alert text was {}".format(
		find_element(context, ALERT_ERROR_MESSAGE).text)


@then('sign in form is shown')
def step_impl(context):
	assert wait_visible(context, SUBMIT)


@then('edit security form is available')
def step_impl(context):
	Actor(context).unsee((By.CSS_SELECTOR, ".dropdown.disabled")). \
		click(BALLOT_OPTIONS_NON_MODAL). \
		click(BALLOT_EDIT_SECURITY)


@then('I am listed as vortex.com admin')
def step_impl(context):
	user_selector = participant_with_email(context.user.email)
	Actor(context).see(user_selector)


@then('vortex.com is available in {:w} tab')
def step_impl(context, tab_name):
	# default behaviour: appears in live tab
	if tab_name == 'live':
		assert "Live" in wait_visible(context, (By.CSS_SELECTOR, ".active")).text
	elif tab_name == 'review':
		Actor(context). \
			click((By.CSS_SELECTOR, "a.nav-text[href$='/review']"))


@when('I invite a user to be {:w} in my vortex.com')
def step_impl(context, role):
	Actor(context). \
		click(BALLOT_OPTIONS_MODAL). \
		click(BALLOT_EDIT_SECURITY). \
		into((By.CSS_SELECTOR, ".add-participant input")).type(context.user2.email). \
		click((By.CSS_SELECTOR, ".add-participant button"))


@then('accounts are merged')
def step_impl(context):
	r = context.user2.session.get(context.apiUrls.private_me)
	log_response(r)
	emails = []
	for login in r.json()['logins']:
		emails.append(login['email'])
	assert len(emails) == 2
	assert set(emails) == {context.user.email, context.user2.email}


@then('invited user is shown as {:w}')
def step_impl(context, role):
	user_selector = participant_with_email(context.user2.email)
	wait_visible(context, user_selector)
	users = find_elements(context, (By.CSS_SELECTOR, ".invites"))
	# the last user that was added has no title
	try:
		users[-1].find_element(*(By.CSS_SELECTOR, ".details .member-title"))
	except NoSuchElementException:
		pass


@when('I edit the {} field in my profile settings')
def step_impl(context, field):
	wait_clickable(context, PROFILE_EDIT).click()
	wait_clickable(context, SAVE_CHANGES)
	wait_visible(context, PROFILE_PAGE_TEXT_INPUT)
	if field == 'name':
		Actor(context). \
			write_to_context("name2", generate_random_name(8)). \
			into_invisible(PROFILE_NAME_INPUT). \
			type(context.name2)
	elif field == 'bio':
		Actor(context). \
			write_to_context("bio2", generate_random_name(8)). \
			into_invisible(PROFILE_BIO_INPUT). \
			type(context.bio2)
	elif field == 'date of birth':
		context.test_user_date_of_birth = (date.today() - timedelta(days=10000)).strftime("%B %d, %Y")
		Actor(context). \
			into(PROFILE_DATE_INPUT).type(context.test_user_date_of_birth)
	elif field == 'gender':
		Actor(context).click(GENDER_SELECTOR)
		selected_gender_option = wait_clickable(context, MALE_GENDER_OPTION)
		context.expected_gender = selected_gender_option.text
		selected_gender_option.click()


@when('I save changes')
def step_impl(context):
	Actor(context).click_and_unsee(SAVE_CHANGES)


@when('I go back to edit {:w} page')
def step_impl(context, entity):
	if entity == 'profile':
		Actor(context).go_to(context.webUrls.profile_page)
	Actor(context).click(PROFILE_EDIT). \
		see(SAVE_CHANGES)


@then('updated value of profile field {} is shown')
def step_impl(context, field):
	wait_visible(context, SAVE_CHANGES)
	if field == 'name':
		text = find_element(context, PROFILE_NAME_INPUT).get_attribute("value")
		assert text == context.name2, \
			'Name not updated. Got {}, expected {}'.format(text, context.name2)
	elif field == 'bio':
		text = find_element(context, PROFILE_BIO_INPUT).text
		assert text == context.bio2, \
			'Bio not updated. Got {}, expected {}'.format(text, context.bio2)
	# TODO: date of birth, investigate
	elif field == 'date of birth':
		text = wait_visible(context, PROFILE_DATE_INPUT).get_attribute("value")
		assert text == context.test_user_date_of_birth
	elif field == 'gender':
		real_text = find_element(context, GENDER_SELECTOR).text
		assert context.expected_gender == real_text, \
			"Expected {} gender, but was {}".format(context.expected_gender, real_text)
	else:
		raise Exception("Unexpected value for field given.")


@then('results are {}')
def step_impl(context, results_status):
	if results_status == 'shown':
		Actor(context).see(BALLOT_RESULTS_AVAILABLE)
	else:
		Actor(context).unsee(BALLOT_RESULTS_AVAILABLE)


@when('I share a vortex.com on facebook')
def step_impl(context):
	Actor(context).click(BALLOT_OPTIONS_NON_MODAL). \
		click(BALLOT_SHARE_FACEBOOK). \
		switch_to_window_handle(1). \
		click(SHARE_BUTTON). \
		write_to_context('vortex.com.id', int(context.browser.current_url.split('id%3D')[1][0:3]))


@then('the vortex.com is shared on my timeline')
def step_impl(context):
	# feed is not updated instantly on facebook, hence this wait
	sleep(4)
	Actor(context).switch_to_window_handle(0). \
		go_to(FACEBOOK_PROFILE_FULL_URL)
	assert wait_text(context, (By.CSS_SELECTOR, "span.timestampContent"), "Just now")


@given('I am invited to become {:w} of that vortex.com')
def step_impl(context, role):
	context.API.change_entity_permissions(context.user2.session, 'vortex.com', context.vortex.com.id, context.user.email, role)


@then('{:w} is visible in my {}')
def step_impl(context, entity, page):
	if page == 'home page':
		# only start navigation after the index has updated
		Actor(context). \
			go_to(context.webUrls.private_feed_page). \
			see(PRIVATE_FEED_BALLOT). \
			see(INITIATIVE)
	elif page == 'notifications screen':
		css_selector = ".notification-list-item-text a[href]"
		myassert(context, getattr(context, "{}".format(entity)).name,
				 wait_visible(context, (By.CSS_SELECTOR, css_selector)).text)


@then('the number of pending notifications is {:d}')
def step_impl(context, invite_count):
	wait_clickable(context, PROFILE_AVATAR_DROPDOWN).click()
	# element not visible when no notifications present
	if invite_count == 0:
		wait_text(context, (By.CSS_SELECTOR, ".qa-notifications-count"), '')
	else:
		wait_text(context, (By.CSS_SELECTOR, ".qa-notifications-count"), str(invite_count))


@then('the vortex.com is {:w}')
def step_impl(context, status):
	if status == 'deleted':
		r = ApiRequest(context.superuser.session, 'get', context.apiUrls.vortex.com_private(context.vortex.com.id))
		while r.status_code != 404:
			r.perform()
			sleep(0.2)
	else:
		css_selector = ".qa-ballot-id-" + str(context.vortex.com.id)
		wait_visible(context, BALLOT_CREATE_NEW)
		if status == 'visible':
			wait_visible(context, (By.CSS_SELECTOR, css_selector))
		else:
			wait_invisible(context, (By.CSS_SELECTOR, css_selector))


@given('I am on private {:w} page')
def step_impl(context, page):
	if page == 'channel':
		context.execute_steps(u'''
		given I created a private channel
		when I am on the channel page
		''')
	elif page == 'feed':
		navigate_to_url(context, context.webUrls.private_feed_page)


@then('I see Not authorized to view this page')
def step_impl(context):
	assert wait_visible(context, (By.CSS_SELECTOR, ".vortex.com-error-message")).text == 'Not authorized to view this page'


@when('I edit the {} field in my channel settings')
def step_impl(context, field):
	if field == 'name':
		context.channel_name = generate_random_name(8)
		wait_visible(context, CHANNEL_NAME_INPUT_FIELD)
		while find_element(context, CHANNEL_NAME_INPUT_FIELD).get_attribute('value') != '':
			find_element(context, CHANNEL_NAME_INPUT_FIELD).send_keys(Keys.BACKSPACE)
		find_element(context, CHANNEL_NAME_INPUT_FIELD).send_keys(context.channel_name)
	elif field == 'description':
		context.channel_description = generate_random_name(8)
		wait_visible(context, CHANNEL_DESCRIPTION_INPUT_FIELD).clear()
		find_element(context, CHANNEL_DESCRIPTION_INPUT_FIELD).send_keys(context.channel_description)


@then('updated value of channel field {} is shown')
def step_impl(context, field):
	if field == 'name':
		got = find_element(context, CHANNEL_NAME_INPUT_FIELD).get_attribute('value')
		myassert(context, context.channel_name, got)
	elif field == 'description':
		got = find_element(context, CHANNEL_DESCRIPTION_INPUT_FIELD).get_attribute('value')
		myassert(context, context.channel_description, got)


@then('submit button is disabled')
def step_impl(context):
	myassert(context, False, find_element(context, VOTE_CAST).is_enabled(),
			 msg="Element {} should not be enabled".format(VOTE_CAST))


@then('the search field is reset')
def step_impl(context):
	wait_invisible(context, (By.CSS_SELECTOR, ".search-results"))


@when('I click on Explore button')
def step_impl(context):
	find_element(context, (By.CSS_SELECTOR, "a.nav-link-explore")).click()
	wait_visible(context, (By.CSS_SELECTOR, ".primary-sidebar"))


def context_contains_private_channel(context, isPrivate):
	return hasattr(context, 'channel') and (context.channel.isPrivate == isPrivate)


@given('vortex.com has {} votes')
def step_impl(context, vote_count):
	if 'threshhold' in vote_count:
		if '+' in vote_count:
			iter_count = context.MaxVoteToDelete + 1
		elif '-' in vote_count:
			iter_count = context.MaxVoteToDelete - 1
		else:
			iter_count = context.MaxVoteToDelete
	else:
		iter_count = int(vote_count)

	for x in range(iter_count):
		user = User()
		user.register(context)
		if context_contains_private_channel(context, True):
			context.API.change_entity_permissions(context.user.session, 'channel', context.channel.id, user.email,
												  'participant')
		if context.vortex.com.isPrivate:
			context.API.change_entity_permissions(context.user2.session, 'vortex.com', context.vortex.com.id, user.email, 'voter')
		context.API.cast_vote(user.session, context.vortex.com.id, len(context.vortex.com.questions))


@when('I edit the draft')
def step_impl(context):
	navigate_to_url(context, context.webUrls.draft_page(context.vortex.com.id, step='questions'))
	Actor(context). \
		into(QUESTION_TEXT_INPUT_FIELD).type('QE'). \
		see((By.CSS_SELECTOR, ".questions-answer"))

	answers = find_elements(context, (By.CSS_SELECTOR, "input[type=text]"))
	for a in answers:
		ElementAction(Actor(context), a).type('X%s' % answers.index(a))


@when('I save draft changes')
def step_impl(context):
	Actor(context).click_and_unsee(BALLOT_SAVE)


@when('I view the draft')
def step_impl(context):
	navigate_to_url(context, context.webUrls.draft_page(context.vortex.com.id, step='questions'))


@then('updated draft values are shown')
def step_impl(context):
	q_field_text = wait_visible(context, (By.CSS_SELECTOR, "textarea")).text
	myassert(context, 'QE', q_field_text)
	answers = find_elements(context, (By.CSS_SELECTOR, "input[type=text]"))
	for a in answers:
		assert a.get_attribute('value') == 'X%s' % answers.index(a), "Observed text: {}".format(
			a.get_attribute('value'))


@then('the delete channel button is {}')
def step_impl(context, button_status):
	wait_visible(context, CHANNEL_SAVE)
	if 'not' in button_status:
		wait_invisible(context, CHANNEL_DELETE)
	else:
		wait_visible(context, CHANNEL_DELETE)


@then('Edit Channel button is not available')
def step_impl(context):
	wait_visible(context, CHANNEL_PROFILE)
	wait_invisible(context, PROFILE_EDIT)


@step("I create a private vote without a title")
def step_impl(context):
	create_vortex.com(context, no_title=True, ballot_privacy='private')


@then("question is used as vortex.com title")
def step_impl(context):
	myassert(context, context.vortex.com_question, wait_visible(context, BALLOT_TITLE).text)


@step("I create a vote with {:d} answers")
def step_impl(context, answer_count):
	# by default, create vortex.com with give us 2 answers
	# that's the starting pointe
	context.answer_count = answer_count
	create_vortex.com(context, answers=True)
	if answer_count > 2:
		for _ in range(answer_count - 2):
			add_answer_to_vortex.com(context, 3 + _)


@when("I {:w} an answer")
def step_impl(context, action):
	if action == 'remove':
		remove_answers = find_elements(context, REMOVE_ANSWER)
		remove_answers[context.answer_count - 1].click()
		myassert(context, len(remove_answers) - 1, len(find_elements(context, REMOVE_ANSWER)),
				 msg='Answer was not removed')
	else:
		add_answer_to_vortex.com(context, context.answer_count + 1)


@then('the answer count becomes equal to {:d}')
def step_impl(context, answer_count):
	actual_count = len(find_elements(context, (By.CSS_SELECTOR, ".questions-answer")))
	myassert(context, answer_count, actual_count)


@when('I delete the {:w}')
def step_impl(context, entity_type):
	Actor(context).click(BALLOT_OPTIONS_MODAL). \
		click(BALLOT_DELETE). \
		click_index(ENTITY_CONFIRM_DELETION, 0). \
		unsee(ENTITY_CONFIRM_DELETION)


@step("I login with wrong {}")
def step_impl(context, field):
	if field == 'password':
		wait_clickable(context, EMAIL_INPUT_FIELD).send_keys(context.user.email)
	else:
		wait_clickable(context, EMAIL_INPUT_FIELD).send_keys(context.user.email[:-1])
	Actor(context). \
		into(PASSWORD_INPUT_FIELD).type("_"). \
		click(SUBMIT)


@then("I get a warning saying {}")
def step_impl(context, warning_text):
	myassert(context, warning_text, wait_visible(context, ERROR_ALERT).text)


@when("I click create channel button")
def step_impl(context):
	Actor(context).go_to(context.webUrls.default_authenticated_page). \
		click(PROFILE_AVATAR_DROPDOWN). \
		click((By.CSS_SELECTOR, ".new-channel-link"))


@then("channel is not created")
def step_impl(context):
	Actor(context). \
		see(CHANNEL_SAVE)


@when('I update channel {} through the API')
def step_impl(context, field):
	context.r = context.API.update_channel_field(context.user.session, context.channel.id, field)


@then("I receive code {:d} as response")
def step_impl(context, code):
	myassert(context, code, context.r.status_code)


@step("I upload image2 as {:w} logo")
def step_impl(context, entity):
	Actor(context). \
		see((By.CSS_SELECTOR, ".img-input.-blank")). \
		into_invisible(CHANNEL_LOGO_INPUT).attach_image(os.path.join(os.getcwd(), *PATH_TO_IMAGE_LOGO2)). \
		see((By.CSS_SELECTOR, ".img-input.-editable"))


@when('I activate {} ticket')
def step_impl(context, ticket_type):
	context.execute_steps(u'''
	when I access {} ticket
	'''.format(ticket_type))
	ticket_url = context.ticket_email_text.split("href=")[1].split(' ')[0]
	navigate_to_url(context, ticket_url.strip('"'))
	sleep(0.5)


@when('{:w} access {} ticket')
def step_impl(context, actor, ticket_type):
	sleep(2.5)

	if ticket_type == 'resultsavailable':
		ticket_type = 'votepublished'

	ticket_type = ticket_type.replace('vortex.com', 'ballot')
	# so far, ticket actions are the same for all types of tickets
	fldr = PATH_TO_EMAILS
	fldr += tuple([ticket_type])
	fldr += tuple([context.user.email if actor == 'I' else context.user2.email])
	try:
		path_to_file = os.path.join(*fldr, os.listdir(os.path.join(*fldr))[0])
		with open(path_to_file, encoding='utf-8') as f:
			context.ticket_email_text = f.read()
		if ticket_type == 'change permission':
			context.ticket_url = context.ticket_email_text.split("img src=")[1].split(' ')[0].replace('"', '')
			context.ticket_id = context.ticket_url.split('/')[-2]
		elif ticket_type != 'remove role':
			context.ticket_url = context.ticket_email_text.split("href=")[1].split(' ')[0].replace('"', '')
			context.ticket_id = context.ticket_url.split('/')[-1]
	except FileNotFoundError:
		print("Was trying to find {} ticket for user {}".format(ticket_type, context.user.email))


@then('I am authorised on vortex.com')
def step_impl(context):
	wait_visible(context, PROFILE_AVATAR_DROPDOWN)


@then('my email is verified')
def step_impl(context):
	wait_invisible(context, (By.CSS_SELECTOR, ".verify-email-banner-text"))
	navigate_to_url(context, context.apiUrls.private_me)
	# logging
	print(context.browser.page_source)
	if 'hasVerifiedEmail' not in context.browser.page_source:
		context.browser.refresh()
	myassertin(context, """"hasVerifiedEmail": true""", context.browser.page_source,
			   msg='private/me did not contain hasVerifiedEmail: true')


@when('I request password reset')
def step_impl(context):
	Actor(context).go_to(context.webUrls.base_url). \
		click(LOG_IN). \
		click((By.CSS_SELECTOR, ".qa-switch-forgot-password")). \
		into((By.CSS_SELECTOR, "input.vortex.com-input")).type(context.user.email). \
		click_and_unsee(SUBMIT)


@then('I am taken to reset password form')
def step_impl(context):
	wait_visible(context, PASSWORD_INPUT_FIELD)


@given('I am invited to become a member of a {:w} {:w}')
def step_impl(context, privacy, entity):
	if entity == 'channel':
		context.execute_steps(u'''
		Given user created a {} channel
		'''.format(privacy))
	else:
		if entity == 'vortex.com':
			context.execute_steps(u'''
			Given user created a {} started vortex.com
			'''.format(privacy))
		elif entity == 'draft':
			context.execute_steps(u'''
			Given user created a {} drafted vortex.com
			'''.format(privacy))
			entity = 'vortex.com'

	context.API.change_entity_permissions(
		context.user2.session, entity, getattr(context, entity).id, context.user.email, 'participant')
	context.role = 'participant'


@when('I fill out required fields in {} form')
def step_impl(context, form_type):
	if form_type == 'login':
		wait_visible(context, (By.CSS_SELECTOR, ".error-message"))  # appears when a ticket is attached to your scenario
	Actor(context). \
		see(AUTH_MODAL). \
		click(FORM_SWITCH_SIGN_UP). \
		into(PASSWORD_INPUT_FIELD).type('123456'). \
		into(USER_NAME_INPUT_FIELD).type(context.user.name). \
		click(SUBMIT)


@then('I am taken to the {:w}')
def step_impl(context, entity):
	if entity == 'channel':
		Actor(context).see(CHANNEL_PROFILE)
		myassertin(context, str(context.channel.id), context.browser.current_url)
	else:
		Actor(context).see(SINGLE_ANSWER_QUESTION)
		myassertin(context, str(context.vortex.com.id), context.browser.current_url)


@when('I navigate to an invalid ticket link')
def step_impl(context):
	navigate_to_url(context, context.webUrls.base_url + '/ticket/' + generate_random_name(32))


@then('you need to verify your email banner is {}')
def step_impl(context, banner_status):
	getattr(Actor(context), "see" if banner_status == 'shown' else "unsee")(
		(By.CSS_SELECTOR, '.verify-email-banner-text'))


@then('I am taken to invalid ticket view')
def step_impl(context):
	Actor(context).within((By.CSS_SELECTOR, ".message-text")).text_contains('ticket is invalid')


@when('another account is logged in')
def step_impl(context):
	login_as(context, context.user2.email)


@when('I choose {} account')
def step_impl(context, account_type):
	# "ticket" or "current"
	if account_type == 'ticket' or account_type == 'merge into current':
		Actor(context).click_and_unsee((By.CSS_SELECTOR, "button.qa-ticket-account"))
	else:
		Actor(context).click_and_unsee((By.CSS_SELECTOR, "button.btn-link-like"))


@given('I have requested password reset')
def step_impl(context):
	context.API.request_password_reset(context.user.session, context.user.email)


@when('I set new password')
def step_impl(context):
	context.user.password = '1234567'
	Actor(context).into(PASSWORD_INPUT_FIELD).type(context.user.password). \
		click_and_unsee(SUBMIT)


@then('I can login with new password')
def step_impl(context):
	login_as(context, context.user.email)


@then('I am logged in as {:w} user')
def step_impl(context, account_type):
	# go to private/me if not there already
	if context.browser.current_url != context.apiUrls.private_me:
		navigate_to_url(context, context.apiUrls.private_me)
	if account_type == 'ticket':
		assert context.user.email in context.browser.page_source
	else:
		assert context.user2.email in context.browser.page_source
	# logging just in case
	print(context.browser.page_source)


@then('edit button is {}')
def step_impl(context, edit_button_status):
	if edit_button_status == 'shown':
		Actor(context).click(BALLOT_OPTIONS_MODAL). \
			see(BALLOT_EDIT_BUTTON)
	else:
		Actor(context). \
			unsee(BALLOT_OPTIONS_MODAL)


@then('{:d} answers are selected')
def step_impl(context, answer_count):
	myassert(context, answer_count, len(find_elements(context, (By.CSS_SELECTOR, ".is-checked"))))


@then('social buttons are {}')
def step_impl(context, status):
	if status == 'shown':
		Actor(context).see(SHARE_BALLOT_LINK). \
			see(SHARE_BALLOT_FACEBOOK_MODAL). \
			see(SHARE_BALLOT_TWITTER_MODAL)
	else:
		Actor(context).unsee(SHARE_BALLOT_LINK). \
			unsee(SHARE_BALLOT_FACEBOOK_MODAL). \
			unsee(SHARE_BALLOT_TWITTER_MODAL)


@then('the vortex.com is visible in {:w} initiatives tab')
def step_impl(context, privacy):
	Actor(context).see(BALLOT_IMAGE_GALLERY)


@then('comments are disabled')
def step_impl(context):
	Actor(context).see(BALLOT_IMAGE_GALLERY). \
		unsee(COMMENT_INPUT_FIELD). \
		unsee(ADD_COMMENT)


@then('{} notification is {} to {}')
def step_impl(context, email_type, notification_status, user):
	email = context.user.email if user == 'vortex.com owner' else context.user2.email
	fldr = PATH_TO_EMAILS
	fldr += tuple([email_type])
	if notification_status == 'not sent':
		try:
			assert email not in os.listdir(os.path.join(*fldr))
		except FileNotFoundError:
			pass
	else:
		assert email in os.listdir(os.path.join(*fldr))


@when('I change user {:w} role to {:w}')
def step_impl(context, entity, new_role):
	if entity == 'dashboard':
		context.execute_steps(u'''
		when I select invited user''')
		Actor(context).click((By.CSS_SELECTOR, "button#ddexisting-list-actions")). \
			click_and_unsee((By.CSS_SELECTOR, ".qa-convert-to-{}s".format(new_role)))
	else:
		wait_clickable(context, (By.CSS_SELECTOR, "a.nav-text[href$='/security']")).click()
		wait_visible(context, (By.CSS_SELECTOR, '.invite'))
		users = find_elements(context, (By.CSS_SELECTOR, ".invite"))

		user_to_edit = None
		for u in users:
			if u.find_element(*(By.CSS_SELECTOR, ".invite .vortex.com-input-label")).text == context.user2.email:
				user_to_edit = u

		if user_to_edit is None:
			raise Exception("User was not found on security page")

		user_to_edit.find_element(*(By.CSS_SELECTOR, ".actions-menu-container button")).click()
		Actor(context). \
			click_and_unsee((By.CSS_SELECTOR, ".popover-content a"))


@then('email is {} to {}')
def step_impl(context, notification_status, user):
	context.execute_steps(u'''
	then vortex.com started notification is {} to {}
	then vortex.com published notification is {} to {}
	'''.format(notification_status, user, notification_status, user))


@when('I {:w} {:w} right {} user')
def step_impl(context, action, right, preposition):
	context.API.change_entity_permissions(
		context.user.session, 'vortex.com', context.vortex.com.id, context.user2.email, right, delete=(action == 'remove'))


@then('my comment text is valid')
def step_impl(context):
	Actor(context).within(BALLOT_ITEM_TEXT). \
		text_is(context.comment)


@then('ticket contains valid url and fields')
def step_impl(context):
	context.t = context.API.get_ticket_info(context.ticket_id)
	assert context.t['ticketState'] == 'Valid'


@then('ticket contains channel info')
def step_impl(context):
	context.t = context.API.get_ticket_info(context.ticket_id)
	assert len(context.t['channel']) != 0


# assert t['ticketMailState'] == 'NotSent', 'Got {} instead'.format(t['ticketMailState'])


@then('ticket contains link to {:w}')
def step_impl(context, entity):
	assert context.t['entityId'] == context.vortex.com.id if entity == 'vortex.com' else context.channel.id


@when('I load tracking pixel url')
def step_impl(context):
	r = requests.get(context.apiUrls.ticket_info(context.ticket_id) + '/pixel.gif')
	log_response(r)


@then('ticket {:w} value is not null')
def step_impl(context, state):
	t = context.API.get_ticket_info(context.ticket_id)
	assert t[state] is not None


@then('my personal channel has isPersonal flag set to true')
def step_impl(context):
	r = requests.get(context.apiUrls.channel_public(context.user.id) + '?select=id%2CisPersonal')
	assert r.json()['isPersonal']


@when('I navigate to my personal channel')
def step_impl(context):
	navigate_to_url(context, context.webUrls.base_url + '/channel/' + str(context.user.id))


@then('I am taken to the profile page')
def step_impl(context):
	Actor(context).see(EDIT_PROFILE_BUTTON)
	myassertin(context, context.webUrls.profile_page, context.browser.current_url)


@then('I am taken to vortex.com owner page')
def step_impl(context):
	Actor(context).see((By.CSS_SELECTOR, ".short-profile"))
	assert str(context.user2.id) in context.browser.current_url


@when('I delete my user')
def step_impl(context):
	context.user.session.delete(context.apiUrls.private_me)


@when('I delete my personal channel')
def step_impl(context):
	context.user.session.delete(context.apiUrls.channel_private(str(context.user.id)))


@then('my personal channel is {}')
def step_impl(context, channel_status):
	if channel_status == 'removed':
		sleep(4)
		assert not context.API.does_public_channel_exist(context.user.id), "Personal channel %d should not exist" % (
			context.user.id)
	elif channel_status in ('not removed', 'created'):
		assert context.API.does_public_channel_exist(context.user.id), "Personal channel %d should exist" % (
			context.user.id)
	else:
		raise Exception('Not supported channel status check: %s' % (channel_status))


@then('vote is part of my personal channel')
def step_impl(context):
	r = context.user.session.get(context.apiUrls.vortex.com_private(context.vortex.com.id))
	assert r.json()['authorId'] == r.json()['channelId']


@when('I click vortex.com owner button')
def step_impl(context):
	Actor(context).click((By.CSS_SELECTOR, ".ballot-item-owner"))


@then('who I am following has edit profile button')
def step_impl(context):
	Actor(context).within(EDIT_PROFILE_BUTTON). \
		text_is("EDIT PROFILE")


@when('I unfollow my personal channel')
def step_impl(context):
	context.user.session.delete(context.apiUrls.channel_subscriptions(context.user.id))


@then('I am following my personal channel')
def step_impl(context):
	r = context.user.session.get(context.apiUrls.channel_subscriptions(context.user.id))
	assert 'true' in r.text


@when('I navigate to my personal security page')
def step_impl(context):
	navigate_to_url(context, context.webUrls.base_url + '/channel/' + str(context.user.id) + '/security')


@when('I navigate to my user id page')
def step_impl(context):
	navigate_to_url(context, context.webUrls.base_url + '/user/' + str(context.user.id))
	Actor(context).see(EDIT_PROFILE_BUTTON)


@then('follow button is not available')
def step_impl(context):
	Actor(context).unsee(GENERIC_FOLLOW_BUTTON)


@then('participant count is shown')
def step_impl(context):
	Actor(context).see(VOTE_COUNT)


@then('participant count is equal to {:d}')
def step_impl(context, vote_count):
	expected_string = str(vote_count) + ' Vote'
	if vote_count != 1:
		expected_string += 's'
	wait_text(context, VOTE_COUNT, expected_string)


@given('{:w} have {} my vote in the {}')
def step_impl(context, actor, vote_status, options):
	s = context.user.session if actor == 'I' else context.user2.session

	if vote_status != 'cast':
		pass
	else:
		context.API.cast_vote(s, context.vortex.com.id, len(context.vortex.com.questions), 'skip' in options)


@then('votes are {}')
def step_impl(context, results_availability):
	r = context.user.session.get(context.apiUrls.votes(context.vortex.com.id))
	log_response(r)
	if results_availability == 'available':
		assert r.status_code == 200
	else:
		assert r.status_code == 403


@given('{:w} requested serverside render of a vortex.com that {}')
def step_impl(context, actor, options):
	if actor == 'superuser':
		s = context.superuser.session
	else:
		s = requests.Session()
	context.vortex.com = vortex.com()
	if options == 'does not exist':
		context.vortex.com.id = 7777
	elif options == 'is private':
		context.user = User()
		context.user.register(context)
		context.vortex.com = vortex.com(vortex.com_type='Survey', isprivate=True)
		context.vortex.com.publish(context, context.user.session)
	else:
		context.vortex.com.id = 6001
	context.r = s.get(context.webUrls.vortex.com_page(context.vortex.com.id) + '&serverside')
	log_response(context.r)


@then('meta tags and values are valid')
def step_impl(context):
	assert context.r.text.count('meta') >= 23


@then('email subject {:w} {}')
def step_impl(context, present, text):
	# split at subject string, get the needed line, purge the dot at the end
	if not hasattr(context, "ticket_email_text"):
		raise AttributeError("Ticket email not found, check logs for details")
	subject = context.ticket_email_text.split('Subject: ')[1].splitlines()[0].strip()
	if present == 'is':
		myassert(context, text, subject)
	# contains
	else:
		myassertin(context, text, subject)


@then('email contains a valid {:w} link')
def step_impl(context, link_type):
	link = context.ticket_email_text.split("href=")[1].splitlines()[0].replace('"', '')
	if link_type == 'vortex.com':
		expectation = '/ballot/' + str(context.vortex.com.id)
	else:
		expectation = '/ticket/'

	myassertin(context, expectation, link)
	delattr(context, 'ticket_email_text')


@given('I have {:w} {} notification')
def step_impl(context, action, notification_type):
	if notification_type == 'results available':
		notification_type = 'votepublished'
	else:
		notification_type = notification_type.replace(' vortex.com', 'ballot')
	r = context.user.session.get(context.apiUrls.mailing_events_all(context.vortex.com.id))
	log_response(r)
	event_id = None
	for item in r.json():
		if item['mailingEventType'].lower() == notification_type:
			event_id = item['id']
			break
	to_send = dict()
	to_send['mailingEventType'] = capwords(notification_type)
	to_send['id'] = event_id
	to_send['isEnabled'] = (action == 'enabled')
	r = context.user.session.put(context.apiUrls.vortex.com_private(context.vortex.com.id) + '/mailingEvents/' + str(event_id),
								 json=to_send)
	log_response(r)


@given('vortex.com start is delayed')
def step_impl(context):
	j = {'startsUtc': datetime.utcnow() + timedelta(seconds=60)}
	context.vortex.com.update(context, context.superuser.session, j)


@given('my role in channel has changed to {:w}')
def step_impl(context, role):
	s = context.superuser.session
	if role == 'nonmember':
		context.API.change_entity_permissions(s, 'channel', context.channel.id, context.user.email, 'owner',
											  delete=True)
	else:
		context.API.change_entity_permissions(s, 'channel', context.channel.id, context.user.email, role)


@then('response text is {}')
def step_impl(context, text):
	myassert(context, text, context.r.json()['message'])


@given('vortex.com results are about to be available')
def step_impl(context):
	j = dict()
	j['resultsVisibility'] = {"mode": 'Custom', "customDateUtc": datetime.utcnow() + timedelta(seconds=1)}
	context.vortex.com.update(context, context.superuser.session, j)
	sleep(1)


@then('{} button is {}')
def step_impl(context, button, visibility):
	if button == 'feature channel':
		btn = (By.CSS_SELECTOR, "button.feature")
	else:
		btn = getattr(ChannelSelectors(context.channel.id), button.replace(' ', '_'))

	getattr(Actor(context), 'unsee' if 'not' in visibility else 'see')(btn)


@when('I click {} button')
def step_impl(context, button):
	if button == 'select all users':
		Actor(context).see(USER_MANAGEMENT_CHECKBOX). \
			click((By.CSS_SELECTOR, ".select-all-container .qa-bool-input"))
	elif button == 'edit channel' or button == 'edit profile':
		Actor(context).click_and_unsee(PROFILE_EDIT)
	else:
		btn = getattr(ChannelSelectors(context.channel.id), button.replace(' ', '_'))
		Actor(context).click(btn)


@then('I am taken to a valid dashboard page')
def step_impl(context):
	Actor(context).see((By.CSS_SELECTOR, "button#pro-channel-selector[value='{}']".format(str(context.channel.id))))
	myassertin(context, '/{}/'.format(str(context.channel.id)), context.browser.current_url)


@given('I am on channel dashboard page')
def step_impl(context):
	Actor(context).go_to(context.webUrls.dashboard_channel(context.channel.id))


@then('channel privacy is shown as {}')
def step_impl(context, privacy):
	myassertin(context, privacy.capitalize(),
			   wait_visible(context, (By.CSS_SELECTOR, ".entity-preview-channel .entity-preview-description")).text)


@then('channel role is shown as {}')
def step_impl(context, role):
	myassertin(context, role.capitalize(),
			   wait_visible(context, (By.CSS_SELECTOR, ".entity-preview-user .entity-preview-description")).text)


@then('{:w} is visible on the dashboard page')
def step_impl(context, vortex.com_type):
	Actor(context).click((By.CSS_SELECTOR, ".initiatives a[href*='{}s']".format(vortex.com_type))). \
		see((By.CSS_SELECTOR, ".image a[href*='{}']".format(str(context.vortex.com.id))))


@when('I switch channels using dropdown menu')
def step_impl(context):
	context.channel.id2 = context.browser.current_url.split('/')[4]
	Actor(context).click((By.CSS_SELECTOR, 'button#pro-channel-selector')). \
		click_and_unsee((By.CSS_SELECTOR, ".ballot-select .dropdown-menu .entity-preview-channel"))
	sleep(0.5)


@then('dashboard channel is switched')
def step_impl(context):
	myassert(context, context.channel.id == int(context.browser.current_url.split('/')[4]), False)


@when('I add a user as {}')
def step_impl(context, role):
	Actor(context).click(USER_MANAGEMENT). \
		click(DASHBOARD_ADD_PARTICIPANTS). \
		into((By.CSS_SELECTOR, ".participants-editor input[type='text']")).type(context.user2.email)
	if role == 'participant':
		Actor(context).click_and_unsee((By.CSS_SELECTOR, ".participant-actions-container button.security-actions"))
	else:
		Actor(context).click((By.CSS_SELECTOR, ".participant-actions-container button.dropdown-toggle")). \
			click_and_unsee(DASHBOARD_ADD_OWNER if role == 'owner' else DASHBOARD_ADD_ADMINISTRATOR)


@then('I am taken to a valid add participants page')
def step_impl(context):
	Actor(context).see(DASHBOARD_ADD_PARTICIPANTS). \
		see(USER_MANAGEMENT_CHECKBOX). \
		see((By.CSS_SELECTOR, ".vortex.com-input-addons-wrapper"))


@then('user is added to the channel')
def step_impl(context):
	wait_visible(context, ALERT_ERROR_MESSAGE)
	emails_in_table = find_elements(context, (By.CSS_SELECTOR, "td.qa-email"))
	emails = [e.text for e in emails_in_table]
	myassertin(context, context.user2.email, emails)


@then('user is listed as {:w}')
def step_impl(context, role):
	roles_in_table = find_elements(context, (By.CSS_SELECTOR, ".invites td:last-child"))
	myassert(context, role.capitalize(), roles_in_table[-1].text)


@then('selected user is listed as {:w}')
def step_impl(context, role):
	wait_visible(context, (By.CSS_SELECTOR, ".alert"))
	wait_text(context, (By.CSS_SELECTOR, ".selected .is-important"), role.capitalize())


@when('I open add participants form')
def step_impl(context):
	Actor(context).click(USER_MANAGEMENT). \
		click(DASHBOARD_ADD_PARTICIPANTS)


@when('I click the email input field')
def step_impl(context):
	Actor(context).click((By.CSS_SELECTOR, ".modal-body input[type='text']"))


@then('another line as added to the form')
def step_impl(context):
	assert len(find_elements(context, TABLE_LINE)) == 2


@then('delete line button appears')
def step_impl(context):
	Actor(context).see(DELETE_LINE)


@when('I delete a line')
def step_impl(context):
	Actor(context).click_and_unsee(DELETE_LINE)


@then('a line is deleted')
def step_impl(context):
	assert len(find_elements(context, TABLE_LINE)) == 1


@given('I have opened add participants form')
def step_impl(context):
	Actor(context).go_to(context.webUrls.dashboard_channel(context.channel.id))
	context.execute_steps(u'''
	When I open add participants form
	''')


@when('I close add participants form')
def step_impl(context):
	sleep(MODAL_ANIMATION)
	Actor(context).click_and_unsee((By.CSS_SELECTOR, "button.close"))


@then('add participants form is closed')
def step_impl(context):
	Actor(context).unsee((By.CSS_SELECTOR, ".modal-body"))


@when('I navigate to invalid vortex.com page')
def step_impl(context):
	Actor(context).go_to(context.webUrls.vortex.com_page(generate_random_name(8)))


@then('page parameters are invalid page is shown')
def step_impl(context):
	myassert(context, "Sorry, given page parameters are invalid!",
			 wait_visible(context, (By.CSS_SELECTOR, ".vortex.com-error-message")).text)
	Actor(context).see((By.CSS_SELECTOR, ".vortex.com-error-link")). \
		see(ERROR_DESCRIPTION)


@given('I am on user management dashboard page')
def step_impl(context):
	Actor(context).go_to(context.webUrls.dashboard_users(context.channel.id))


@then('{:d} users are selected')
def step_impl(context, user_count):
	wait_visible(context, (By.CSS_SELECTOR, ".selected .qa-bool-input"))
	assert len(find_elements(context, (By.CSS_SELECTOR, ".selected .qa-bool-input"))) == user_count


@when('I select invited user')
def step_impl(context):
	wait_visible(context, USER_MANAGEMENT_CHECKBOX)
	checkboxes = find_elements(context, (By.CSS_SELECTOR, ".qa-bool-input"))
	checkboxes[len(checkboxes) - 1].click()


@when('delete user from channel')
def step_impl(context):
	Actor(context).click_and_unsee((By.CSS_SELECTOR, "button .delete-icon")). \
		see(ALERT_ERROR_MESSAGE)


@then('user is deleted')
def step_impl(context):
	# UI needs to update after alert is visible
	sleep(0.3)
	emails = []
	for element in find_elements(context, (By.CSS_SELECTOR, ".qa-email")):
		emails.append(element.text)
	assert context.user2.email not in emails


@then('user count is {:d}')
def step_impl(context, user_count):
	actual_count = wait_visible(context, (By.CSS_SELECTOR, ".count")).text
	assert str(user_count) in actual_count


@then('ticket is not available')
def step_impl(context):
	assert not hasattr(context, "ticket_email_text"), "Email should not have been generated/sent"


@then('total user notification count is {:d}')
def step_impl(context, count):
	sleep(2)
	r = ApiRequest(context.user.session, 'get', context.apiUrls.notifications)
	r.perform()
	observed = len(list(filter(lambda x: x['notificationType'] in ['ChangePermissions', 'RemoveRole'], r.response)))
	myassert(context, count, observed)


@given('{:w} has been deleted')
def step_impl(context, entity):
	entity_id = str(getattr(context, entity).id)
	r = context.superuser.session.delete(getattr(context.apiUrls, '%s_private' % entity)(entity_id))
	log_response(r)


@then('you need to verify your email to see notifications page is shown')
def step_impl(context):
	Actor(context).see((By.CSS_SELECTOR, ".notifications-verify-email")). \
		see(ERROR_DESCRIPTION)


@when('I click {} notification link')
def step_impl(context, entity):
	Actor(context).click((By.CSS_SELECTOR, ".notification-list-item-image-link[href]"))


@then('no entity links are visible on my notifications page')
def step_impl(context):
	Actor(context). \
		unsee((By.CSS_SELECTOR, ".notification-list-item-image-link[href]"))


@when('I click the {:w}')
def step_impl(context, vortex.com_type):
	vortex.com_selector = "a[href$='%s']" % context.vortex.com.id
	Actor(context).click((By.CSS_SELECTOR, vortex.com_selector))


@then('I am taken to a valid vortex.com edit page')
def step_impl(context):
	Actor(context).see(IMAGE_IS_BLANK). \
		see((By.CSS_SELECTOR, "button.save")). \
		see((By.CSS_SELECTOR, "button.preview"))


@when('I post {payload} to {endpoint:w} endpoint')
def step_impl(context, payload, endpoint):
	if endpoint == 'votes':
		url = context.apiUrls.votes(context.vortex.com.id)
	elif endpoint == 'voices':
		url = context.apiUrls.voices(context.vortex.com.id)

	r = ApiRequest(context.user.session, 'post', url, json=payload)
	r.perform()
	context.r = r


@when('I request vortex.com {:w} expecting {:w}')
def step_impl(context, endpoint, expectation):
	r = ApiRequest(context.user.session, 'get', (getattr(context.apiUrls, "api_%s" % endpoint)))
	expecting_client_error = (expectation == 'failure')
	r.perform_with_checks(throw_on_success=not expecting_client_error, throw_on_client_error=expecting_client_error)
	setattr(context, endpoint, r.response)


@then('vortex.com voices and votes are equal')
def step_impl(context):
	assert context.voices == context.votes


@when('I request vortex.comproperties')
def step_impl(context):
	r = ApiRequest(context.user.session, 'get', context.apiUrls.vortex.com_properties + str(context.vortex.com.id))
	r.perform()
	context.vortex.com_properties = r.response


@when('I do private search by author')
def step_impl(context):
	r = ApiRequest(context.user.session, 'get', context.apiUrls.private_author_search(context.user.id))
	r.perform()
	context.r = r.response


@then('vortex.com properties {:w} is {}')
def step_impl(context, key, value):
	assert context.vortex.com_properties[0]['key'] == value


@when('I select vortex.com id that does not exist')
def step_impl(context):
	context.vortex.com.id = 111111


@given('I have uploaded channel logo')
def step_impl(context):
	url = context.apiUrls.channel_private(str(context.channel.id)) + '/logo'
	context.API.upload_image_to_url(context.user.session, url, os.path.join(*PATH_TO_IMAGE_LOGO))


@then('channel logo is seen')
def step_impl(context):
	Actor(context).see(CHANNEL_LOGO)


@given('{:w} created a {:w} {:w} vortex.com')
def step_impl(context, actor, privacy, state):
	vortex.com = vortex.com(isprivate=(privacy == 'private'))

	if hasattr(context, 'q'):
		vortex.com.questions = context.q

	if actor == 'I':
		s = context.user.session
		vortex.com.set_channel_id(context.user.id)
	else:
		s = context.user2.session
		vortex.com.set_channel_id(context.user2.id)

	if hasattr(context, 'channel'):
		vortex.com.set_channel_id(context.channel.id)

	if state == "published":
		vortex.com.publishedUtc = (datetime.utcnow() - timedelta(hours=3))
		vortex.com.startsUtc = (datetime.utcnow() + timedelta(hours=1))
		vortex.com.endsUtc = (datetime.utcnow() + timedelta(hours=2))
	elif state == "published_in_future":
		vortex.com.publishedUtc = (datetime.utcnow() + timedelta(hours=1))
		vortex.com.startsUtc = (datetime.utcnow() + timedelta(hours=2))
		vortex.com.endsUtc = (datetime.utcnow() + timedelta(hours=3))
	elif state == "started":
		vortex.com.publishedUtc = datetime.utcnow()
		vortex.com.startsUtc = datetime.utcnow()
		vortex.com.endsUtc = (datetime.utcnow() + timedelta(hours=1))
	elif state == "ended":
		vortex.com.publishedUtc = (datetime.utcnow() - timedelta(hours=3))
		vortex.com.startsUtc = (datetime.utcnow() - timedelta(hours=2))
		vortex.com.endsUtc = (datetime.utcnow() - timedelta(hours=1))
	elif state == 'not_started':
		vortex.com.startsUtc = (datetime.utcnow() + timedelta(hours=2))
		vortex.com.endsUtc = (datetime.utcnow() + timedelta(hours=5))
		vortex.com.publishedUtc = datetime.utcnow()
	elif state == "openended":
		vortex.com.publishedUtc = (datetime.utcnow() - timedelta(hours=2))
		vortex.com.startsUtc = (datetime.utcnow() - timedelta(hours=1))
		vortex.com.endsUtc = None

	vortex.com.publish_draft(context, s)
	context.vortex.com = vortex.com

	if state in ["published", "started", "ended", "not_started"]:
		context.API.check_vortex.com_in_private_index(s, vortex.com.name, vortex.com.id)

	context.vortex.coms.append(vortex.com)


@given('{:w} changed my permissions to {} in {:w}')
def step_impl(context, actor, permissions, entity):
	if actor == 'I':
		s = context.user.session
	else:
		s = context.user2.session
	context.API.change_entity_permissions(s, entity, getattr(context, entity).id, context.user.email, permissions)


@when('I request marketing report')
def step_impl(context):
	context.r = context.user.session.get(context.apiUrls.api_url + 'private/users/analytics/csv')


@given('I set vortex.com results visibility to {:w}')
def step_impl(context, visibility_mode):
	context.vortex.com.set_rvisibility(visibility_mode)
	context.vortex.com.update(context, context.user.session)


@given('vortex.com has {status} finished')
def step_impl(context, status):
	if status == "already":
		j = {'endsUtc': datetime.utcnow() + timedelta(seconds=1)}
		context.vortex.com.update(context, context.superuser.session, j)
		sleep(1)


@when('I request channel security')
def step_impl(context):
	r = ApiRequest(context.user.session, 'get', context.apiUrls.channel_security_private(context.channel.id))
	r.perform()
	context.r = r.response


@then('I am listed as channel {:w}')
def step_impl(context, role):
	u = None
	for user in context.r:
		if user['userId'] == context.user.id:
			u = user

	if u is None:
		raise Exception("User {} has no rights in channel {}".format(context.user.id, context.channel.id))
	assert u['permissions'] == role
