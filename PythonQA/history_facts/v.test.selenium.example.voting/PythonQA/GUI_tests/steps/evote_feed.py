import re
from datetime import datetime

from behave import *

from shared.api_actions import ApiRequest


@when("{:w} request vortex.com feed")
def step_impl(context, actor):
	# I = user, user = user2
	s = getattr(context.user if actor == 'I' else context.user2, 'session')
	r = ApiRequest(s, 'get', context.apiUrls.private_feed)
	r.perform()
	context.r = r.response


@then("vortex.com feed contains {:d} vortex.com")
def step_impl(context, expected_count):
	actual_count = len(context.r['ballots'])
	assert actual_count == expected_count, "Expected {} vortex.coms, got {}".format(expected_count, actual_count)


@then("author search contains {:d} vortex.com")
def step_impl(context, expected_count):
	actual_count = len(context.r['results'])
	assert actual_count == expected_count, "Expected {} vortex.coms, got {}".format(expected_count, actual_count)


@given("I have {} vote in vortex.com")
def step_impl(context, voted_status):
	if voted_status == 'cast':
		context.API.cast_vote(
			context.user.session, context.vortex.com.id, len(context.vortex.com.questions))
	else:
		pass


@then('vortex.coms are returned in the following order {}')
def step_impl(context, order):
	indices = re.findall('[0-9]', order)
	indices = [int(x) - 1 for x in indices]
	results = context.r['results']
	for x in range(len(indices)):
		assert results[x]['id'] == context.vortex.coms[indices[x]].id, \
			"Expected {}, got {}".format(context.vortex.coms[indices[x]].id, results[x]['id'])


@step("vortex.com publish date is now")
def step_impl(context):
	j = dict()
	j['startsUtc'] = j['publishedUtc'] = datetime.utcnow()
	context.vortex.com.update(context, context.superuser.session, j)
