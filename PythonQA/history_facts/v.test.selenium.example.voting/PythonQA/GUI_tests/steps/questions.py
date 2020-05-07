from behave import *

from shared.api_objects import *


@when('I add question with {question_type:w} type')
def step_impl(context, question_type):
    type = None
    if question_type != 'unset':
        type = question_type

    context.vortex.com.add_question(Question(type=type, answers=[]))
    context.r = context.vortex.com.update(context, context.user.session)

@when('I add question with {question_type:w} type with {count:d} answers')
def step_impl(context, question_type, count):
    type = None
    if question_type != 'unset':
        type = question_type

    context.vortex.com.add_question(Question(type=type, answers=[(count * [Answer(isfreetext=False)])]))
    context.r = context.vortex.com.update(context, context.user.session)

@when('I add question with {optional_value:w} isoptional')
def step_impl(context, optional_value):
    isoptional = None
    if optional_value != 'unset':
        isoptional = optional_value == 'True'

    context.vortex.com.set_question(Question(isoptional=isoptional))
    context.vortex.com.update(context, context.user.session)

@then('question {field:w} is {value:w}')
def step_impl(context, field, value):
    s = context.user.session
    r = ApiRequest(s, 'get', context.apiUrls.vortex.com_private(context.vortex.com.id))
    r.perform()
    actual = r.response['questions'][-1][field]

    assert str(actual) == value, 'Question %s is %s, should be %s' % (field, actual, value)
@then('question has {count:d} answers')
def step_impl(context, count):
    s = context.user.session
    r = ApiRequest(s, 'get', context.apiUrls.vortex.com_private(context.vortex.com.id))
    r.perform()
    answers = r.response['questions'][-1]['answers']
    assert len(answers) == count, 'Answer count is %d, should be %d' % (len(answers), count)

@when('I add question with {question_type:w} type with answers: {answers:array}')
def step_impl(context, question_type, answers):
    type = None
    if question_type != 'unset':
        type = question_type


    context.vortex.com.add_question(Question(type=type, answers=list(map(lambda x: Answer(isfreetext=False, text=x), answers))))
    context.r = context.vortex.com.update(context, context.user.session)

@then('question has answers: {answers_expected:array}')
def step_impl(context, answers_expected):
    s = context.user.session
    r = ApiRequest(s, 'get', context.apiUrls.vortex.com_private(context.vortex.com.id))
    r.perform()
    answers_actual = r.response['questions'][-1]['answers']
    assert len(answers_actual) == len(answers_expected), 'Answers count is %d, should be %d' % (len(answers_actual), len(answers_expected))
    for x in zip(range(len(answers_actual)), answers_actual, answers_expected):
        assert x[1]['text'] == x[2], 'Answer[%d] is "%s", but it text should be "%s"' % x
