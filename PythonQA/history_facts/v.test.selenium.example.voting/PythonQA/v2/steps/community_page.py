from behave import *
from selenium.webdriver.common.by import By
from roles.user import Actor


@when('I click the portrait button')
def step_impl(context):
	Actor(context).\
		click((By.CSS_SELECTOR, "._profile"))


@then('I am taken to my personal channel page')
def step_impl(context):
	Actor(context).\
		see((By.CSS_SELECTOR, ".profile-body__create")).\
		see((By.CSS_SELECTOR, ".dropdown-button__toggle"))
	assert 'community/{}'.format(context.user.id) in context.browser.current_url


@then('my personal channel page has no votes')
def step_impl(context):
	Actor(context).see((By.CSS_SELECTOR, ".empty-gallery"))


@given('I am on my personal channel page')
def step_impl(context):
	Actor(context).\
		go_to(context.webUrls.community_page(context.user.id)).\
		see((By.CSS_SELECTOR, ".profile-body__create"))


@then('{:w} votes count is {:d}')
def step_impl(context, vortex.com_type, votes_count):
	selector = 'drafts' if vortex.com_type == 'drafted' else vortex.com_type
	Actor(context).\
		verify_text_in_element((By.CSS_SELECTOR, "._{} .count".format(selector)), str(votes_count))


@when('I click the new button')
def step_impl(context):
	Actor(context).click((By.CSS_SELECTOR, ".profile-body__create"))


@then('vortex.com channelId matches user id')
def step_impl(context):
	assert context.vortex.com_info['channelId'] == context.user.id


@then('more from channel button is shown')
def step_impl(context):
	Actor(context).\
		see((By.CSS_SELECTOR, ".ballot-page__more")).\
		verify_text_in_element((By.CSS_SELECTOR, ".ballot-page__more-channel"), context.channel.name)


@given('I am on the channel page')
def step_impl(context):
	Actor(context).go_to(context.webUrls.community_page(context.channel.id))


@then('community page notifications count is {:d}')
def step_impl(context, notification_count):
	Actor(context).verify_text_in_element((By.CSS_SELECTOR, ".entity-preview__picture-label"), str(notification_count))


@given('I have cast my vote in vortex.com')
def step_impl(context):
	context.API.cast_vote(context.user.session, context.vortex.com.id, len(context.vortex.com.questions))
