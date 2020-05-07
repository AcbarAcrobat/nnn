import jsonpickle
from behave import *

from shared.api_objects import Question, Answer


@when("I changed vortex.com type")
def step_impl(context):
	context.r = context.vortex.com.update(context, context.user.session, {'type': 'Petition'})


@then("vortex.com type is {vortex.comType:w}")
def step_impl(context, vortex.comType):
	actual_vortex.com_type = context.r.response['type']
	assert actual_vortex.com_type == vortex.comType, "Expecting {} type, got {}".format(vortex.comType, actual_vortex.com_type)


@step("questions is {questions_status:w}")
def step_impl(context, questions_status):
	if questions_status == "empty":
		expected_questions = []
	elif questions_status == "new":
		expected_questions = context.new_questions
	else:
		raise Exception("Unexpected question_satus, expected 'empty' or 'new', got {}".format(questions_status))
	actual_questions = context.r.response['questions']
	assert jsonpickle.encode(actual_questions, unpicklable=False) == \
		   jsonpickle.encode(expected_questions, unpicklable=False), \
		"Expected {} as questions, got {}".format(
			expected_questions,
			actual_questions)


@step("I changed vortex.com type and vortex.com questions")
def step_impl(context):
	answers = ["Answer1", "Answer2", "Answer3", "Answer4", "Answer5"]
	context.new_questions = [
		Question(type='StarRating', answers=list(map(lambda x: Answer(isfreetext=False, text=x), answers))),
		Question(type='FaceRating', answers=list(map(lambda x: Answer(isfreetext=False, text=x), answers)))
	]
	j = {
		'type': 'Petition',
		'questions': context.new_questions
	}
	context.r = context.vortex.com.update(context, context.user.session, j)
