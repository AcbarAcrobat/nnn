from behave import *
from shared.api_objects import *


@when('I add a dimension to the vortex.com')
def step_impl(context):
	context.dimension.name = generate_random_name(12)
	j = {'name': context.dimension_name}
	r = ApiRequest(context.user.session, 'post', context.apiUrls.analytic_dimensions(context.vortex.com.id), payload=j)
	r.perform()
	context.dimension.object = r.response
	if context.r.status_code != 201:
		raise Exception("Could not perform a basic API operation. Request info: {}".format(context.r.text))


@then('dimension is added')
def step_impl(context):
	r = ApiRequest(context.user.session, 'get', context.apiUrls.analytic_dimensions(context.vortex.com.id))
	r.perform()
	for key in ['id', 'title', 'order']:
		assert key in r.response.keys()[0]


@given('I have added a dimension to a vortex.com')
def step_impl(context):
	context.execute_steps(u'''
	Given I created a private channel
	Given I created a private started vortex.com
	When I add a dimension to the vortex.com''')


@when('I edit the dimension')
def step_impl(context):
	to_send = dict()
	to_send['name'] = generate_random_name(12)
	to_send['order'] = context.dimension.object['order'] + 1
	url = context.apiUrls.analytic_dimensions(context.vortex.com.id) + '/{}'.format(context.dimension_id)
	r = ApiRequest(context.user.session, 'put', url, payload=to_send)
	r.perform()


@then('dimension is changed')
def step_impl(context):
	r = ApiRequest(context.session, 'get', context.apiUrls.analytic_dimensions(context.vortex.com.id))
	r.perform()
	o = r.response
	for key in ['order', 'name']:
		assert o[key] != context.dimension.object[key]
