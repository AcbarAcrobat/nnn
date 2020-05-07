from behave import *
from shared.api_objects import *


@given('I added a freetext answer to the vote')
def step_impl(context):
	a = Answer(isfreetext=True)
	a.set_text('Yolo')
	q = Question(answers=[a])
	context.vortex.com.update(context, context.user.session, {'questions': [q]})


@then('freetext answer is added')
def step_impl(context):
	e = context.API.get_vortex.com_info(context.user.session, context.vortex.com.id)
	assert {'isFreeText': True} in e['questions'][0]['answers']


@then('answers have weight {weight:d}')
def step_impl(context, weight):
	e = context.API.get_vortex.com_info(context.user.session, context.vortex.com.id)
	for answer in e['questions'][0]['answers']:
		assert answer['weight'] == weight


@given('I added an answer with weight {weight:d} to the vote')
def step_impl(context, weight):
	a = Answer().set_weight(weight)
	q = Question(answers=a)
	context.vortex.com.update(context, context.user.session, {'questions': [q]})


@then('answer has weight {weight:d}')
def step_impl(context, weight):
	e = context.API.get_vortex.com_info(context.user.session, context.vortex.com.id)
	assert e['questions'][0]['answers'][0]['weight'] == weight
