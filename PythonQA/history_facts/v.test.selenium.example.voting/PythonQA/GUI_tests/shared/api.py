import os
from time import sleep

import requests
from shared.constants import PATH_TO_EMAILS

from shared.api_actions import ApiRequest, log_response


class API:
	def __init__(self, urls):
		self.urls = urls

	def cast_vote(self, session, vortex.com_id, question_count=1, skip_question=False):
		url = self.urls.votes(vortex.com_id)
		votes = []
		for i in range(question_count):
			votes.append([1, 0])
		if skip_question:
			votes[-1] = None
		r = ApiRequest(session, 'post', url, payload=votes)
		r.perform()

	def request_password_reset(self, session, email):
		url = self.urls.reset_password
		r = ApiRequest(session, 'post', url, payload={'email': email})
		r.perform()

	def get_ticket_info(self, ticket_id):
		url = self.urls.ticket_info(ticket_id)
		r = ApiRequest(requests.session(), 'get', url)
		r.perform()
		return r.response

	def change_entity_permissions(self, session, entity_type, entity_id, email, permissions, delete=False):
		if permissions == 'administrator':
			permissions = 'admin'
		elif permissions == 'participant':
			if entity_type == 'vortex.com':
				permissions = 'voter'
			else:
				permissions = 'member'

		j = dict()
		j['permissions'] = permissions
		j['email'] = email

		url = getattr(self.urls, "{}_security_private".format(entity_type))(entity_id)

		r = ApiRequest(session, 'delete' if delete else 'post', url, payload=[j])
		r.perform()

	def follow_channel(self, session, channel_id):
		url = self.urls.channel_subscriptions(channel_id)
		p = {'isSubscribed': True}
		r = ApiRequest(session, 'put', url, payload=p)
		r.perform()

	def unfollow_channel(self, session, channel_id):
		url = self.urls.channel_subscriptions(channel_id)
		p = {'isSubscribed': False}
		r = ApiRequest(session, 'put', url, payload=p)
		r.perform()

	def does_public_channel_exist(self, channel_id):
		url = self.urls.channel_public(channel_id)
		r = ApiRequest(requests.session(), 'get', url)
		r.perform()
		return r.status_code == 200

	@staticmethod
	def upload_image_to_url(session, url, path_to_img):
		boundary = "1234567890"
		r = session.prepare_request(requests.Request('PUT', url))
		r.headers['content-type'] = 'multipart/related; boundary=%s' % boundary
		boundary = str.encode(boundary)
		with open(path_to_img, 'rb') as file:
			image = file.read()
		r.body = b"--%s\r\nx-parameterName: %s\r\ncontent-length: %d\r\n\r\n%s\r\n--%s--\r\n" % (
			boundary, b"image", len(image), image, boundary)
		r.headers['content-length'] = '%d' % len(r.body)
		r.headers['user-agent'] = 'behave tests'
		response = session.send(r)
		log_response(response)
		if response.status_code != 200:
			raise Exception("Could not upload image to url {}, response code {}".format(url, response.status_code))

	def update_channel_field(self, session, channel_id, field, value='42'):
		url = self.urls.channel_private(channel_id)
		j = dict()
		j['id'] = channel_id
		if field == 'bio':
			key = 'about'
		elif field == 'short description':
			key = 'description'
		else:
			key = 'name'

		j[key] = value
		r = ApiRequest(session, 'put', url, payload=j)
		return r.perform()

	def check_home_feed_emptyness(self, session):
		url = self.urls.private_feed
		retries = 0
		while retries != 20:
			sleep(0.5)
			retries += 1
			r = session.get(url)
			if len(r.json()['results']) != 0:
				return
		raise Exception("Maximum retries for home feed exceeded (10 seconds elapsed)")

	def check_voted_status(self, session, vortex.com_id):
		url = self.urls.vortex.com_properties(vortex.com_id)
		r = ApiRequest(session, 'get', url)
		r.perform()
		return r.response[0]['voted']

	def verify_email_with_ticket(self, session, email):
		fldr = os.path.join(*PATH_TO_EMAILS, 'Verify Email', email)
		path_to_file = os.path.join(fldr, os.listdir(fldr)[0])
		with open(path_to_file) as f:
			ticket_email_text = f.read()
		# extract invite link from text file
		ticket_url = ticket_email_text.split("href=")[1].split(' ')[0]
		ticket_id = ticket_url.split('/')[-1][0:-1]
		to_send = {'ticket': ticket_id}
		r = ApiRequest(session, 'post', self.urls.verify_email, payload=to_send)
		r.perform()
		if r.status_code != 200:
			raise Exception(
				'Could not verify email {} using ticket {}. Got code {}'.format(
					email, ticket_id, r.status_code))

	def signup(self, email, password='123456', name='Bandersnatch Crumplesack'):
		# returns user_id as int if successful
		credentials = {'email': email, 'password': password, 'name': name}
		r = ApiRequest(requests.session(), 'post', self.urls.signup, payload=credentials)
		r.perform()
		if r.status_code == 200:
			return r.response['id']
		else:
			raise Exception("Could not sign up, response code {}, error message {}".format(r.status_code, r.text))

	def login(self, email, password='123456'):
		credentials = {'email': email, 'password': password}
		r = ApiRequest(requests.session(), 'post', self.urls.login, payload=credentials)
		return r.status_code == 200

	def check_vortex.com_in_private_index(self, session, query, entity_id):
		# every 0.2 seconds, checks whether an entity with set name has appeared in index
		while True:
			sleep(0.2)
			url = self.urls.private_search + 'ballotselect=id&channelselect=id&q={}&entityType=ballot%2Cchannel'.format(
				query)
			r = ApiRequest(session, 'get', url)
			r.perform()
			if {"id": entity_id} in r.response["ballots"]:
				break

	def check_draft_in_private_index(self, session, author_id):
		# every 0.2 seconds, checks whether an entity with set name has appeared in index
		while True:
			sleep(0.2)
			url = self.urls.private_drafts + 'user?&authorId={}&ballotselect=id&channelselect=id&userselect=id'.format(
				str(author_id))
			r = ApiRequest(session, 'get', url)
			r.perform()
			if r.response != {'results': [], 'ballots': []}:
				break

	def get_channel_featured_feed(self, session, take=None, skip=None):
		url = self.urls.channels_featured_feed
		separator = "?"
		if take is not None:
			url = url + separator + "take=" + str(take)
			separator = "&"
		if skip is not None:
			url = url + separator + "skip=" + str(skip)
			separator = "&"

		r = ApiRequest(session, 'get', url)
		r.perform()
		return r.response

	def get_vortex.com_info(self, session, vortex.com_id):
		r = ApiRequest(session, 'get', self.urls.vortex.com_private(vortex.com_id))
		r.perform()
		return r.response
