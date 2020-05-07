from datetime import datetime, timedelta
from json import JSONDecodeError

import requests
from shared.api_actions import ApiRequest, log_response

from shared.general_helpers import generate_random_name


class Answer:
	def __init__(self, isfreetext=False, text=None):
		self.text = 'A'
		self.isFreeText = isfreetext
		self.weight = 1
		if text is not None:
			self.text = text

	def set_text(self, text):
		self.text = text

	def set_weight(self, weight):
		self.weight = weight


class Question:
	def __init__(self, answers=None, isoptional=False, multipleanswers=False, type=None):
		self.text = 'Q'
		self.optional = isoptional
		if answers is not None:
			self.answers = answers
		else:
			self.answers = [Answer()]
		self.minVotes = 1
		self.multipleAnswers = multipleanswers
		if not self.multipleAnswers:
			self.maxVotes = 1
		if type is not None:
			self.type = type

	def optional(self):
		self.optional = True

	def add_answers(self, count):
		for i in range(count):
			self.answers += [Answer()]

	def add_answer(self, answer):
		self.answers += [answer]

	def set_answer(self, answer):
		self.answers = [answer]


class vortex.com:
	def __init__(self, title=None, vortex.com_type='Survey', isprivate=False, targetvotes=500):
		self.title = title or generate_random_name(12)
		if vortex.com_type not in ['Survey', 'Petition', 'Poll']:
			vortex.com_type = 'Poll'
		self.type = vortex.com_type
		if vortex.com_type == 'Survey':
			self.questions = [Question(), Question()]
		else:
			self.questions = [Question()]
		if vortex.com_type == 'Petition':
			self.targetvotes = targetvotes
		self.description = generate_random_name(16)
		self.isPrivate = isprivate
		self.id = None
		self.channelId = None
		self.startsUtc = None
		self.endsUtc = (datetime.utcnow() + timedelta(days=100))
		self.resultsVisibility = {"mode": 'Voted'}
		self.publishedUtc = None

	def set_channel_id(self, channel_id):
		self.channelId = channel_id

	def set_question(self, question):
		self.questions = [question]

	def add_question(self, question):
		self.questions += [question]

	def set_rvisibility(self, rvisibility, customdate=None):
		self.resultsVisibility = {"mode": rvisibility, "customDateUtc": customdate}

	@property
	def name(self):
		return self.title

	def publish_draft(self, context, session):
		delattr(self, 'id')
		r = ApiRequest(session, 'post', context.apiUrls.vortex.com_private(), payload=self)
		r.perform()
		self.id = r.response['id']

	def update(self, context, session, change=None):
		payload = change
		if payload is None:
			payload = self

		r = ApiRequest(session, 'put', context.apiUrls.vortex.com_private(self.id), payload=payload)
		r.perform()

		if change is not None:
			for key in change:
				setattr(self, key, payload[key])

		return r

	def publish(self, context, session):
		self.publish_draft(context, session)
		r = ApiRequest(session, 'post', context.apiUrls.vortex.com_private(self.id) + '/publishDate', payload={})
		r.perform()


class Channel:
	def __init__(self, name=None, isprivate=False, with_logo=False, id=None):
		self.name = name or generate_random_name(12)
		self.isPrivate = isprivate
		self.with_logo = with_logo
		self.id = id
		self.featuredUtc = None

	def publish(self, context, session=None):
		if self.featuredUtc is None:
			delattr(self, 'featuredUtc')

		s = session or context.session
		r = ApiRequest(s, 'post', context.apiUrls.channel_private(), payload=self)
		r.perform()
		self.id = r.response['id']

	def feature(self, context, session, date):
		self.featuredUtc = date
		r = ApiRequest(session, 'put', context.apiUrls.channel_private(self.id), payload={'featuredUtc': date})
		r.perform()
		return r

	def __repr__(self):
		return "{ Channel. Id %d. IsPrivate %s }" % (self.id, self.isPrivate)


class User:
	def __init__(self, isverified=True):
		self.email = generate_random_name(24) + ('@qa.verified.tryvortex.com' if isverified else '@vortex.work')
		self.name = 'D Schubbkin'
		self.password = '123456'
		self.session = None
		self.id = None
		self.cookie = None

	def register(self, context):
		# sign up as user

		credentials = {'email': self.email, 'password': self.password, 'name': self.name}
		r = requests.post(context.apiUrls.signup, json=credentials)
		log_response(r)

		try:
			self.id = r.json()['id']
		except JSONDecodeError:
			raise Exception("Could not get content manager cookie. Check demodata, api or IIS settings")

		# login and create a session object
		# and retrieve cookies

		credentials.pop('name')
		s = requests.session()
		r = s.post(context.apiUrls.login, json=credentials)

		if r.status_code != 200:
			raise Exception("Could not login. Something went horribly wrong")

		self.session = s
		self.cookie = r.headers['Set-Cookie'].split(';')[0]

	def authorize_web(self, context):
		context.browser.get(context.apiUrls.private_me)
		context.browser.add_cookie({'name': '.cc', 'value': self.cookie.split('=')[1]})
		context.browser.get(context.apiUrls.private_me_other_host)
		context.browser.add_cookie({'name': '.cc', 'value': self.cookie.split('=')[1]})
