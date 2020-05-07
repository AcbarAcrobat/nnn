from datetime import datetime, timedelta
from time import sleep
from behave import *
from shared.api_actions import log_response, ApiRequest


@when("I request my home feed")
def step_impl(context):
	url = context.apiUrls.home_feed
	request = ApiRequest(context.user.session, 'get', url)
	request.perform()
	context.r = request.response


@then("home feed contains {}")
def step_impl(context, expected_result):
	channels = context.r

	if expected_result == 'no channels':
		assert len(channels) == 0, "Expected 0 channels, got {} instead".format(len(channels))
	elif expected_result == 'the channel':
		assert context.channel.id in [channel['id'] for channel in channels],\
			"Expected new channel with id={}, but not found".format(context.channel.id)
	else:
		assert False, "Unexpected channel {}".format(expected_result)


@step("user published vortex.coms in {publish_order:array} order")
def step_impl(context, publish_order):
	for i in range(1, len(publish_order) + 1):
		vortex.com_publish_order = publish_order.index(str(i))
		j = {'publishedUtc': datetime.utcnow() + timedelta(seconds=1)}
		if vortex.com_publish_order == len(publish_order) - 1:
			j['startsUtc'] = datetime.utcnow() + timedelta(days=10)
		context.vortex.coms[vortex.com_publish_order].update(context, context.user2.session, j)
		sleep(1)


@then("channels are listed in {result_order:array}")
def step_impl(context, result_order):
	feed_channels = context.r
	for channel_order_orig in range(0, len(result_order)):
		channel_order_result = int(result_order[channel_order_orig]) - 1
		channel_orig_id = context.channels[channel_order_result].id
		channel_result_id = feed_channels[channel_order_orig]['id']
		assert channel_orig_id == channel_result_id, "Expected channel with id={}, got {}".format(channel_orig_id,
																								  channel_result_id)


@step("channels have {count:array} vortex.coms")
def step_impl(context, count):
	feed_channels = context.r
	for channel_number in range(0, len(feed_channels)):
		channel = feed_channels[channel_number]
		actual_vortex.coms_count = channel['ballotsCount']
		expected_vortex.coms_count = int(count[channel_number])

		assert actual_vortex.coms_count == expected_vortex.coms_count, "Expected vortex.coms count is {},bug got {}".format(
			expected_vortex.coms_count,
			actual_vortex.coms_count)


@when("I request votable ballots for the channel")
def step_impl(context):
	url = context.apiUrls.votable_ballots(context.channel.id)
	request = ApiRequest(context.user.session, 'get', url)
	request.perform()
	context.r = request.response


@then("votable ballots contains {expected_result}")
def step_impl(context, expected_result):
	vortex.coms = context.r

	if expected_result == 'no vortex.coms':
		assert len(vortex.coms) == 0, "Expected 0 vortex.coms, got {} instead".format(len(vortex.coms))
	elif expected_result == 'the vortex.com':
		assert context.vortex.com.id in [vortex.com['id'] for vortex.com in vortex.coms], "Expected new vortex.com with id={}, but not found".format(context.vortex.com.id)
	elif expected_result == 'vortex.com2 then vortex.com1':
		actual_ids = [vortex.com['id'] for vortex.com in vortex.coms]
		expected_ids = [context.vortex.coms[1].id, context.vortex.coms[0].id]
		assert expected_ids == actual_ids, 'Expected ids in order {}, but got {}'.format(expected_ids, actual_ids)
	else:
		assert False, "Unexpected vortex.com {}".format(expected_result)