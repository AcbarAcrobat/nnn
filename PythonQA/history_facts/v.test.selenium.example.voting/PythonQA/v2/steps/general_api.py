#!/usr/bin/env python
# -*- coding: utf-8 -*-

from behave import *
from shared.api_objects import *


@given('{:w} created a {:w} {:w} vortex.com')
def step_impl(context, actor, privacy, state):
	vortex.com = vortex.com(isprivate=(privacy == 'private'), vortex.com_type='Poll')

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
	elif state == 'quick':
		a1 = Answer(text='Yes')
		a2 = Answer(text='No')
		q = Question(answers=[a1, a2], type='YesNo')
		vortex.com.questions = [q]
		vortex.com.publishedUtc = datetime.utcnow()
	elif state == 'facerating':
		q = Question(type='FaceRating', answers=[])
		vortex.com.questions = [q]
		vortex.com.publishedUtc = datetime.utcnow()
	elif state == 'starrating':
		q = Question(type='StarRating', answers=[])
		vortex.com.questions = [q]
		vortex.com.publishedUtc = datetime.utcnow()

	vortex.com.publish_draft(context, s)
	context.vortex.com = vortex.com

	if state in ["published", "started", "ended", "not_started"]:
		context.API.check_vortex.com_in_private_index(s, vortex.com.name, vortex.com.id)
	elif state == 'drafted':
		context.API.check_draft_in_private_index(s, context.user.id)

	context.vortex.coms.append(vortex.com)


@given("I created a {:w} {:w} survey")
def step_impl(context, privacy, state):
	vortex.com = vortex.com(isprivate=(privacy == 'private'), vortex.com_type='Survey')
	s = context.user.session
	vortex.com.set_channel_id(context.user.id)

	if state == 'started':
		vortex.com.publishedUtc = datetime.utcnow()
		vortex.com.startsUtc = datetime.utcnow()
		vortex.com.endsUtc = (datetime.utcnow() + timedelta(hours=1))

	if hasattr(context, 'channel'):
		vortex.com.set_channel_id(context.channel.id)

	vortex.com.publish_draft(context, s)
	context.vortex.com = vortex.com

	context.vortex.coms.append(vortex.com)


@given('survey has no questions')
def step_impl(context):
	context.vortex.com.questions = []
	context.vortex.com.update(context, context.user.session)


@given('{:w} changed my permissions to {} in {:w}')
def step_impl(context, actor, permissions, entity):
	if actor == 'I':
		s = context.user.session
	else:
		s = context.user2.session
	context.API.change_entity_permissions(s, entity, getattr(context, entity).id, context.user.email, permissions)


@given('{actor:w} created a {privacy:w} channel')
def step_impl(context, actor, privacy):
	if privacy == 'personal':
		context.channel = Channel()
		context.channel.id = context.user.id if actor == 'I' else context.user2.id
		context.channel.name = context.user.name
	else:
		context.channel = Channel(isprivate=(privacy == 'private'))
		if actor == 'I':
			context.channel.publish(context, context.user.session)
		else:
			context.channel.publish(context, context.user2.session)

	context.channels.append(context.channel)
