import requests
from behave import *

from shared.api_actions import log_response
from shared.api_objects import User


@when("I request my channel feed")
def step_impl(context):
	context.r = context.user.session.get(context.apiUrls.channel_private())
	log_response(context.r)


@then("channel feed contains {}")
def step_impl(context, expected_channel):
	channels = context.r.json()

	if expected_channel == 'only my personal channel':
		assert len(channels) == 1, "Expected 1 channel, got {} instead".format(len(channels))
		assert channels[0]["id"] == context.user.id, "Expected personal channel id={}, got {} instead".format(
			context.user.id, channels[0]["id"])
		context.expected_channel = channels[0]

	elif expected_channel == 'the channel':
		channel_found = False
		for channel in channels:
			if channel["id"] == context.channel.id:
				context.expected_channel = channel
				channel_found = True
				break
		assert channel_found, "Expected new channel with id={}, but not found".format(context.channel.id)

	elif expected_channel == "channel1 then channel2":
		channel1 = context.channels[0]
		channel2 = context.channels[1]
		channel1_index = -1
		channel2_index = -1
		for channel in channels:
			if channel["id"] == channel1.id:
				channel1_index = channels.index(channel)
			elif channel["id"] == channel2.id:
				channel2_index = channels.index(channel)
		assert channel1_index != -1, "Expected channel1 with id={}, but not found".format(channel1.id)
		assert channel2_index != -1, "Expected channel2 with id={}, but not found".format(channel2.id)
		assert channel1_index < channel2_index, "Expected channel1 with id={} before channel2 with id={}, but it is not".format(
			channel1.id, channel2.id)

	elif expected_channel == "channel2 then channel1":
		channel1 = context.channels[0]
		channel2 = context.channels[1]
		channel1_index = -1
		channel2_index = -1
		for channel in channels:
			if channel["id"] == channel1.id:
				channel1_index = channels.index(channel)
			elif channel["id"] == channel2.id:
				channel2_index = channels.index(channel)
		assert channel1_index != -1, "Expected channel1 with id={}, but not found".format(channel1.id)
		assert channel2_index != -1, "Expected channel2 with id={}, but not found".format(channel2.id)
		assert channel1_index > channel2_index, "Expected channel2 with id={} before channel1 with id={}, but it is not".format(
			channel2.id, channel1.id)
	else:
		assert False, "Unexpected channel".format(expected_channel)


@step("channel {property_name:w} property value equals {expected_property_value:w}")
def step_impl(context, property_name, expected_property_value):
	property_value = str(context.expected_channel[property_name])
	assert property_value == expected_property_value, \
		"Expected {} = {} , got {} instead".format(property_name, expected_property_value, property_value)


@when("I update channels onboarding feed with {}")
def step_impl(context, channels_order):
	if channels_order == "A1 and A2":
		channels_id = [context.channels[0].id, context.channels[1].id]
	elif channels_order == "A3 and A2":
		channels_id = [context.channels[2].id, context.channels[1].id]
	elif channels_order == "all channels":
		channels_id = [channel.id for channel in context.channels]
	elif channels_order == "no channels":
		channels_id = []
	else:
		raise "Unexpected channels order for onboarding feed"

	context.r = context.user.session.put(context.apiUrls.channels_onboarding_private,
										 json=channels_id)


@then("onboarding channels feed contains {expected}")
def step_impl(context, expected):
	if expected == "all channels":
		expected_channels_id = [channel.id for channel in context.channels]
	elif expected == "A3 and A2":
		expected_channels_id = [context.channels[2].id, context.channels[1].id]
	elif expected == "no channels":
		expected_channels_id = []
	else:
		raise "Unexpected channels order in onboarding channels feed"
	actual_channels_id = [channel['id'] for channel in context.r.json()]
	assert expected_channels_id == actual_channels_id, "Unexpected channel ids, expected {}, but got {}".format(
		expected_channels_id, actual_channels_id)


@when("{} request onboarding channels feed")
def step_impl(context, user):
	if user == 'I':
		current_session = context.user.session
	else:
		context.user = User()
		context.user.session = requests.Session()
		current_session = context.user.session

	context.r = current_session.get(context.apiUrls.channels_onboarding)


@when("{} request trending channels")
def step_impl(context, user):
	if user == 'I':
		current_session = context.user.session
	else:
		context.user = User()
		context.user.session = requests.Session()
		current_session = context.user.session
	skip = 0
	take = 200
	finished = False
	context.trendingChannels = []
	while not finished:
		r = current_session.get(context.apiUrls.trending_channels(take=take, skip=skip))
		read_channels = r.json()
		context.trendingChannels.extend(read_channels)
		finished = len(read_channels) < take
		skip += len(read_channels)


@then("only public channels returns")
def step_impl(context):
	channel_privacy = [channel['isPrivate'] for channel in context.trendingChannels]
	assert all(x == False for x in channel_privacy), "Expected all channels is public, but it is not"


@step("I add {:d} members to the channel")
def step_impl(context, count):
	saved_channel = context.channel
	for x in range(count):
		user = User()
		user.register(context)
		context.API.follow_channel(user.session, saved_channel.id)
	context.channel = saved_channel


@then('I delete {channels_type}')
def step_impl(context, channels_type):
	if channels_type == "the channel":
		context.user.session.delete(context.apiUrls.channel_private(str(context.channel.id)))
	elif channels_type == "all my channels":
		for channel in context.channels:
			context.user.session.delete(context.apiUrls.channel_private(str(channel.id)))


@then("the trending channels feed contains {channel_order}")
def step_impl(context, channel_order):
	channels = context.trendingChannels
	if channel_order == "channel1 at the first place":
		assert len(channels) > 0, "Channel feed should be not empty"
		assert channels[0]['id'] == context.channel.id, "The channel expected at first position, but {} got".format(
			channels[0]['id'])

	elif channel_order == "the channel":
		assert len(channels) > 0, "Channel feed should be not empty"
		assert any(
			channel['id'] == context.channel.id for channel in channels), "The channel expected in feed but it doesn't"

	elif channel_order == "channel2 at the first place then channel1":
		assert len(channels) > 0, "Channel feed should be not empty"
		assert channels[0]['id'] == context.channels[1].id, "The channel expected at first position, but {} got".format(
			channels[0]['id'])
		assert channels[1]['id'] == context.channels[
			0].id, "The channel expected at second position, but {} got".format(
			channels[1]['id'])


@then("the trending channels feed does not contain the channel")
def step_impl(context):
	channels = context.trendingChannels
	assert all(x['id'] != context.channel.id for x in channels), "The channel is not expected in feed, but it is"


@step("I unsubscribe from my personal channel")
def step_impl(context):
	context.API.unfollow_channel(context.user.session, context.channel.id)
