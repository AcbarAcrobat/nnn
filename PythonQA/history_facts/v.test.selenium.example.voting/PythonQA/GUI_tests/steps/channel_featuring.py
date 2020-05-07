from datetime import timedelta, datetime

from behave import *
from selenium.webdriver.common.by import By

from roles.user import Actor
from shared.api_actions import ApiRequest


@when("I try to feature channel")
def step_impl(context):
	context.r = context.channel.feature(context, context.user.session, datetime.utcnow())


@when("I try to set channels[{index:d}] featureUtc to utcnow plus {hours:d} hours")
def step_impl(context, index, hours):
	context.r = context.channels[index].feature(context, context.user.session,
												datetime.utcnow() + timedelta(hours=hours))


@when("I request featured channels feed")
def step_impl(context):
	context.channel_featured_feed = context.API.get_channel_featured_feed(context.user.session)


@when("I request featured channels feed with take={take:d}&skip={skip:d} parameters")
def step_impl(context, take, skip):
	context.channel_featured_feed = context.API.get_channel_featured_feed(context.user.session, take, skip)


@then("featured channels feed contains {count:d} channels")
def step_impl(context, count):
	assert len(context.channel_featured_feed) == count, "Featured channels feed count is %d, expected %d" % (
		len(context.channel_featured_feed), count)


@then("channels[{index:d}] is on top of featured channels feed")
def step_impl(context, index):
	expected = context.channels[index]
	actual = context.channel_featured_feed[0]
	assert expected.id == actual["id"], "Featured channels feed top one is %d, should be %d" % (
		actual["id"], expected.id)


@given("featured feed contains one channel")
def step_impl(context):
	context.execute_steps(u'''
		given I am vortex.com employee
		and I created a public channel
		when I try to feature channel
		''')


@when('I click on feature label on channel logo')
def step_impl(context):
	Actor(context).click((By.CSS_SELECTOR, "button.feature-button"))


@given('channel has been featured')
def step_impl(context):
	context.channels[-1].feature(context, context.superuser.session, datetime.utcnow())


@then('channel is featured')
def step_impl(context):
	r = ApiRequest(context.user.session, 'get', context.apiUrls.channel_private(context.channel.id))
	r.perform()
	assert r.response['featuredUtc'] is not None


@then('feature label is displayed over channel logo')
def step_impl(context):
	Actor(context).see((By.CSS_SELECTOR, "button.-featured"))
