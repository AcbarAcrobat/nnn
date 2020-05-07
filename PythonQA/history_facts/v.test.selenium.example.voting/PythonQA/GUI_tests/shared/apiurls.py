class ApiUrls:
	def __init__(self, api_url):
		self.api_url = api_url

	@property
	def login(self):
		return self.api_url + 'auth/login'

	@property
	def signup(self):
		return self.api_url + 'auth/signup'

	def channel_private(self, channel_id=None):
		return self.api_url + 'private/channels/' + ('' if channel_id is None else str(channel_id))

	def channel_public(self, channel_id=None):
		return self.api_url + 'channels/' + ('' if channel_id is None else str(channel_id))

	def vortex.com_private(self, vortex.com_id=None):
		return self.api_url + 'private/ballots/' + ('' if vortex.com_id is None else str(vortex.com_id))

	def vortex.com_public(self, vortex.com_id=None):
		return self.api_url + 'private/ballots/' + ('' if vortex.com_id is None else str(vortex.com_id))

	def votes(self, vortex.com_id):
		return self.vortex.com_private(vortex.com_id) + "/votes"

	def voices(self, vortex.com_id):
		return self.vortex.com_private(vortex.com_id) + "/voices"

	def mailing_events_all(self, vortex.com_id):
		return self.vortex.com_private(vortex.com_id) + '/mailingEvents?mailingEventSelect=all'

	def analytic_dimensions(self, vortex.com_id):
		return self.vortex.com_private(vortex.com_id) + '/analyticDimensions'

	def private_author_search(self, author_id):
		return self.api_url + 'private/search/ballots/author?authorId={}'.format(author_id)

	@property
	def search(self):
		return self.api_url + 'search/new?'

	@property
	def private_search(self):
		return self.api_url + 'private/search?'

	def vortex.com_properties(self, vortex.com_id):
		return self.api_url + 'private/ballotProperties/{}'.format(str(vortex.com_id))

	def channel_subscriptions(self, channel_id):
		return self.api_url + 'private/subscriptions/channel/{}'.format(str(channel_id))

	@property
	def get_vortex.coms_by_tag_id(self):
		return self.api_url + 'search/ballots/tag?ballotselect=id&tagId='

	def channel_security_private(self, channel_id):
		return self.api_url + 'private/security/channel/{}'.format(str(channel_id))

	def vortex.com_security_private(self, vortex.com_id):
		return self.api_url + 'private/security/ballot/{}'.format(str(vortex.com_id))

	@property
	def signout(self):
		return self.api_url + 'auth/signout'

	@property
	def status(self):
		return self.api_url + 'private/status'

	@property
	def private_me(self):
		return self.api_url + 'private/me'

	def private_users(self, user_id):
		return self.api_url + 'private/users/{}'.format(str(user_id))

	@property
	def private_me_other_host(self):
		if '1' in self.api_url.split('.')[0]:
			prefix = self.api_url.replace('1', '2', 1)
		else:
			prefix = self.api_url.replace('2', '1', 1)
		return prefix + 'private/me'

	def ticket_info(self, ticket_id):
		return self.api_url + 'auth/ticket/info/{}'.format(ticket_id)

	@property
	def notifications(self):
		return self.api_url + 'private/notifications'

	@property
	def private_feed(self):
		return self.api_url + 'private/privatefeed'

	@property
	def private_drafts(self):
		return self.api_url + 'private/drafts/ballots/'

	@property
	def reset_password(self):
		return self.api_url + 'auth/forgot-password'

	@property
	def verify_email(self):
		return self.api_url + 'auth/verify-email'

	@property
	def channels_featured_feed(self):
		return self.api_url + 'channels/featured'

	@property
	def home_feed(self):
		return self.api_url + 'homefeed'

	def votable_ballots(self, channelId):
		return self.api_url + 'private/channels/' + str(channelId) + '/ballots/votable?select=title,id'

	@property
	def channels_onboarding_private(self):
		return self.api_url + 'private/channels/onboarding'

	@property
	def channels_onboarding(self):
		return self.api_url + 'channels/onboarding'

	def trending_channels(self, take=200, skip=0):
		return self.api_url + 'channels/trending?take={}&skip={}'.format(take, skip)