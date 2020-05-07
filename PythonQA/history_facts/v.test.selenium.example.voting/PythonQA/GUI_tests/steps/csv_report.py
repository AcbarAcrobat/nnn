from behave import *
from shared.api_objects import *


@when('{} downloads csv report')
def step_impl(context, user):
	if user == 'that user':
		s = context.user2.session
	elif user == 'I':
		s = context.user.session
	elif user == 'super user':
		s = context.superuser.session
	elif user == 'anonymous user':
		s = requests.Session()  # blank session for anonymous access emulation
	else:
		s = context.user2.session
	context.r = s.get(context.apiUrls.vortex.com_private(context.vortex.com.id) + '/votes/results/csv')
	log_response(context.r)


@then('csv report is {}')
def step_impl(context, report_status):
	if report_status == 'shared':
		assert context.r.status_code == 200
	else:
		assert context.r.status_code != 200
