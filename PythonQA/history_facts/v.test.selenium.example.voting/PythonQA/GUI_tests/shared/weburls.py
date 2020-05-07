class WebUrls:
	def __init__(self, base_url):
		self.base_url = base_url

	@property
	def landing_page(self):
		return self.base_url + ''

	@property
	def explore_page(self):
		return self.base_url + '/explore'

	@property
	def home_page(self):
		return self.base_url + '/home'

	@property
	def my_content_page(self):
		return self.base_url + '/my'

	@property
	def new_vortex.coms_page(self):
		return self.base_url + '/ballots/new'

	@property
	def profile_page(self):
		return self.base_url + '/profile'

	@property
	def profile_private_initiatives_page(self):
		return self.base_url + '/profile/privateInitiatives'

	@property
	def private_feed_page(self):
		return self.base_url + '/home'

	@property
	def default_authenticated_page(self):
		return self.private_feed_page

	@property
	def create_channel_page(self):
		return self.base_url + '/channel/new'

	@property
	def api(self):
		return self.base_url + '/rest/api/v1/private/status'

	def vortex.com_page(self, vortex.com_id):
		return self.base_url + '/terms?modal=vortex.com&id=' + str(vortex.com_id)

	def draft_page(self, vortex.com_id, step='body'):
		return self.base_url + '/vortex.com/' + str(vortex.com_id) + '/' + step

	def dashboard_channel(self, channel_id):
		return self.base_url + '/pro/{}/vortex.coms'.format(str(channel_id))

	def dashboard_users(self, channel_id):
		return self.base_url + '/pro/{}/users'.format(str(channel_id))

	@property
	def notifications(self):
		return self.base_url + '/notifications'
