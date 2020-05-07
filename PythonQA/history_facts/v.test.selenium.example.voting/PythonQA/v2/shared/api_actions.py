import jsonpickle
import json
from requests_toolbelt.utils import dump
from datetime import datetime
from time import sleep


class DatetimeHandler(jsonpickle.handlers.BaseHandler):
	def flatten(self, obj, data):
		return obj.strftime("%Y-%m-%dT%H:%M:%S+00:00")


class ApiRequest:
	def __init__(self, session, method, url, payload=None):
		self.session = session
		self.method = method
		self.url = url
		self.payload = None
		self.response = None
		self.status_code = None
		if payload is not None:
			jsonpickle.handlers.registry.register(datetime, DatetimeHandler)
			self.payload = jsonpickle.encode(payload, unpicklable=False)

	def perform(self):
		r = getattr(self.session, self.method)(self.url, json=json.loads(self.payload or "{}"))
		log_response(r)

		if r.status_code >= 500:
			raise self._get_response_exception(True)

		self.status_code = r.status_code
		self._raw_response = r

		try:
			self.response = r.json()
		except ValueError:
			pass

		return self

	def perform_with_checks(self, throw_on_success=False, throw_on_client_error=True, throw_on_redirect=False, throw_on_info=False):
		self.perform()

		if throw_on_info and self.status_code >= 100 and self.status_code < 200:
			raise self._get_response_exception(False)

		if throw_on_success and self.status_code >= 200 and self.status_code < 300:
			raise self._get_response_exception(False)

		if throw_on_redirect and self.status_code >= 300 and self.status_code < 400:
			raise self._get_response_exception(False)

		if throw_on_client_error and self.status_code >= 400 and self.status_code < 500:
			raise self._get_response_exception(True)

	def _get_response_exception(self, dump_text):
		if dump_text:
			return Exception('Unexpected request status code %d %s (%s)' % (self.status_code, self.r.reason, self.r.text))
		else:
			return Exception('Unexpected request status code %d %s' % (self.status_code, self.r.reason))


def api_check_condition_with_retries(context, url_suffix, condition, timeout=0.2, max_retries=20):
	url = context.apiUrls.api_url + url_suffix
	retries = 0
	r = context.user.session.get(url)
	log_response(r)
	while getattr(r, condition[0]) == condition[1]:
		retries += 1
		sleep(timeout)
		r = context.session.get(url)
		log_response(r)
		if retries == max_retries:
			raise Exception("Condition {} = {} not fulfilled for url {}".format(condition[0], condition[1], url_suffix))


def log_response(request):
	try:
		print(dump.dump_response(request).decode('utf-8'), end='')
	# do not decode image requests
	except UnicodeDecodeError:
		print(dump.dump_response(request), end='')
	except UnicodeEncodeError:
		print(dump.dump_response(request), end='')
