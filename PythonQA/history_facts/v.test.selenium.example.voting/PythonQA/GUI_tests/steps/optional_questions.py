from behave import *
from shared.api_objects import *


@given('I added a {:w} question to the vortex.com')
def step_impl(context, q_type):
	if not hasattr(context, 'q'):
		context.q = []
	context.q.append(Question(isoptional=(q_type == 'optional')))


@then('question is {:w}')
def step_impl(context, q_is):
	r = ApiRequest(context.user.session, 'get', context.apiUrls.vortex.com_private(context.vortex.com.id))
	r.perform()
	for question in r.response['questions']:
		if q_is == 'optional':
			assert question['optional']
		else:
			assert 'optional' not in question.keys()


@when('{} changes vortex.com question optional state')
def step_impl(context, actor):
	if actor == 'content manager':
		s = context.superuser.session
	else:
		s = context.user.session
	r = ApiRequest(s, 'get', context.apiUrls.vortex.com_private(context.vortex.com.id))
	r.perform()
	r.response['questions'][0]['optional'] = True
	r = ApiRequest(s, 'put', context.apiUrls.vortex.com_private(context.vortex.com.id), payload=r.response)
	r.perform()


@then('there is a mandatory and optional question in the vortex.com')
def step_impl(context):
	r = ApiRequest(context.user.session, 'get', context.apiUrls.vortex.com_private(context.vortex.com.id))
	r.perform()
	questions = r.response['questions']
	assert questions[0]['optional'] is True
	assert 'optional' not in questions[1].keys()
