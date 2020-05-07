from selenium.webdriver.common.by import By


def participant_xpath(email):
	return "//span[contains(.,'" + email.lower() + "')]"


def participant_with_email(email):
	return By.XPATH, participant_xpath(email)


class ChannelSelectors:
	def __init__(self, channel_id):
		self.id = channel_id

	@property
	def channel_dashboard(self):
		return By.CSS_SELECTOR, ".primary-sidebar a[href='/pro/{}/vortex.coms']".format(str(self.id))


class AccessManagementElements:
	def __init__(self, role):
		self.role = role
		if role == 'administrator':
			self.prefix = ".qa-administrators-group"
		elif role == 'contributor':
			self.prefix = ".qa-contributors-group"
		else:
			self.prefix = ".qa-participants-group"

	@property
	def label(self):
		return self.prefix + ' label'

	@property
	def dropdown_toggle(self):
		return self.prefix + ' button.dropdown-toggle'

	@property
	def move_to_owners(self):
		return self.prefix + ' .qa-convert-to-owners a'

	@property
	def move_to_administrator(self):
		return self.prefix + ' .qa-convert-to-administrators a'

	@property
	def move_to_contributor(self):
		return self.prefix + ' .qa-convert-to-contributors a'

	@property
	def move_to_participant(self):
		return self.prefix + ' .qa-convert-to-participants a'


# Cross-page

IMAGE_IS_BLANK = (By.CSS_SELECTOR, '.img-input--blank')
PUBLISH_BALLOT = (By.CSS_SELECTOR, "button.next")
SAVE_BALLOT_AS_DRAFT = (By.CSS_SELECTOR, "button.qa-save-draft")
COMMENT_INPUT_FIELD = (By.CSS_SELECTOR, ".comment .form-control")
ADD_COMMENT = (By.CSS_SELECTOR, ".comment .submit")
SEARCH = (By.CSS_SELECTOR, "input[placeholder=search]")
SEARCH_RESULT_CHANNEL = (By.CSS_SELECTOR, '.found-items .entity-preview-channel .entity-preview-name span')
SEARCH_RESULT_BALLOT = (By.CSS_SELECTOR, ".ballot span")
PROFILE_AVATAR_DROPDOWN = (By.CSS_SELECTOR, "div.dropdown.btn-group")
CHANGE_PASSWORD = (By.CSS_SELECTOR, ".edit-password")
SIGN_OUT = (By.CSS_SELECTOR, '.test-button-signout')
ENTER_CURRENT_PASSWORD = (By.NAME, 'password')
ENTER_NEW_PASSWORD = (By.NAME, 'newPassword')
BUTTON_IN_PROGRESS = (By.CSS_SELECTOR, 'button.in-progress')
PRIVATE_FEED_INVITE_COUNT = (By.CSS_SELECTOR, "span.invites")
TOAST_ALERT = (By.CSS_SELECTOR, ".alerts-container")
PRIVATE_FEED_BALLOT = (By.CSS_SELECTOR, "a.entity-preview-info")
SEARCH_BUTTON = (By.CSS_SELECTOR, "button.open-search")
ERROR_DESCRIPTION = (By.CSS_SELECTOR, ".vortex.com-error-description")
# Landing (/)

LOG_IN = (By.CSS_SELECTOR, '.button-login')
SIGN_UP = (By.CSS_SELECTOR, ".qa-switch-to-signup")
CHANNEL = (By.CSS_SELECTOR, ".popular-author-view")
INITIATIVE = (By.CSS_SELECTOR, ".ballot-small")
TAG_LARGESCREEN = (By.CSS_SELECTOR, ".aside-secondary .trends-list a[href*='/tag']")
TAG_SMALLSCREEN = (By.CSS_SELECTOR, ".aside-primary .trends-list a[href*='/tag']")
TAG_PAGE_HEADER = (By.CSS_SELECTOR, ".header-title")
GENERIC_FOLLOW_BUTTON = (By.CSS_SELECTOR, "button.fllw-btn")

# LogInFrame

AUTH_MODAL = (By.CSS_SELECTOR, '.qa-auth-modal')
USER_NAME_INPUT_FIELD = (By.CSS_SELECTOR, '.qa-input-name')
EMAIL_INPUT_FIELD = (By.CSS_SELECTOR, ".qa-input-email")
PASSWORD_INPUT_FIELD = (By.CSS_SELECTOR, ".qa-input-password")
SUBMIT = (By.CSS_SELECTOR, '.qa-btn-submit')
GOOGLE = (By.CSS_SELECTOR, "button.lgn-wth-goog")
FACEBOOK = (By.CSS_SELECTOR, "button.lgn-wth-fcbk")
FORM_SWITCH_SIGN_IN = (By.CSS_SELECTOR, ".qa-switch-to-sign-in")
FORM_SWITCH_SIGN_UP = (By.CSS_SELECTOR, ".qa-switch-to-sign-up")
EMAIL_INPUT_FIELD_HEADER = (By.XPATH, "//span[contains(.,'Email')]")
PASSWORD_INPUT_FIELD_HEADER = (By.XPATH, "//span[contains(.,'Password')]")
ERROR_ALERT = (By.CSS_SELECTOR, ".error-message")

SocialNetworkSelectors = dict()
SocialNetworkSelectors['google'] = 'button.lgn-wth-goog'
SocialNetworkSelectors['facebook'] = 'button.lgn-wth-fcbk'
SocialNetworkSelectors['linkedin'] = 'button.lgn-wth-lnkdn'


# Channel Page (/new/channel)

CHANNEL_NAME_INPUT_FIELD = (By.CSS_SELECTOR, "input.vortex.com-input")
CHANNEL_DESCRIPTION_INPUT_FIELD = (By.CSS_SELECTOR, "textarea.vortex.com-input")
CHANNEL_LOGO = (By.CSS_SELECTOR, '.pic-profile .media-preview__content')
CHANNEL_LOGO_INPUT = (By.CSS_SELECTOR, ".qa-profile-photo-input")
CHANNEL_SAVE = (By.CSS_SELECTOR, "button.save-profile")
CHANNEL_PROFILE = (By.CSS_SELECTOR, ".short-profile")
CHANNEL_PRIVACY_CHECKBOX = (By.CSS_SELECTOR, ".checkbox")
CHANNEL_PRIVACY_CHECKBOX_STATUS = (By.CSS_SELECTOR, "[type=checkbox]")
PROFILE_EDIT = (By.CSS_SELECTOR, ".short-profile .qa-edit-profile")
CHANNEL_DELETE = (By.CSS_SELECTOR, ".qa-delete-channel")
CHANNEL_PARTICIPANTS = (By.XPATH, "//span[contains(.,'participants')]")
CHANNEL_ADD_ADMINS = (By.XPATH, "//button[contains(.,'administrator')]")
CHANNEL_ADD_CONTRIBUTORS = (By.XPATH, "//button[contains(.,'contributor')]")
CHANNEL_ADD_PARTICIPANTS = (By.XPATH, "//button[contains(.,'participant')]")
CHANNEL_ADD_ROLE_BUTTON = (By.CSS_SELECTOR, ".popup-actions .async-button")
CHANNEL_ACCEPT_INVITE = (By.CSS_SELECTOR, ".sbscrb-button-desktop button.qa-accept-channel-invite")
CHANNEL_FOLLOWER_COUNT = (By.CSS_SELECTOR, ".tab-bar .tab-link[href*='/followers'] .tab-additional")
CHANNEL_ACCESS_MANAGEMENT = (By.CSS_SELECTOR, ".tab-bar .tab-link[href*='/security']")
CHANNEL_PHOTO_WRAPPER = (By.CSS_SELECTOR, ".photo .image-wrapper")
CHANNEL_COVER_WRAPPER = (By.CSS_SELECTOR, ".cover .image-wrapper")
PROFILE_EDIT_PAGE_LOGO = (By.CSS_SELECTOR, ".photo .display-image")
ENTITY_CONFIRM_DELETION = (By.CSS_SELECTOR, ".confirmation-actions button")
EDIT_PROFILE_BUTTON = (By.CSS_SELECTOR, "button.qa-edit-profile")

# Ballot Page

ADD_ANSWER = (By.CSS_SELECTOR, "a.add-option")
REMOVE_ANSWER = (By.CSS_SELECTOR, "button.vortex.com-cross")
BALLOT_EDITOR_TITLE = (By.CSS_SELECTOR, ".ballot-editor-title")
BALLOT_IMAGE_PICKER = (By.CSS_SELECTOR, ".ballot-image-picker")
BALLOT_CREATE_NEW = (By.CSS_SELECTOR, "button.button-create-new")
BALLOT_TYPE_OPTIONS = (By.CSS_SELECTOR, ".radio")
BALLOT_SELECT_REGION = (By.CSS_SELECTOR, ".qa-region-input-container input")
BALLOT_SELECT_REGION_SEARCH_RESULTS = (By.XPATH, "//ul[@class='dropdown-menu open']")
BALLOT_UPLOAD_BACKGROUND_IMAGE = (By.CSS_SELECTOR, ".qa-ballot-image-picker")
BALLOT_TITLE_INPUT_FIELD = (By.CSS_SELECTOR, "input[type='text']")
BALLOT_END_DATE = (By.CSS_SELECTOR, ".end-date input")
BALLOT_SAVE = (By.CSS_SELECTOR, "button.qa-save-draft")
BALLOT_COMMENT_BLOCK = (By.CSS_SELECTOR, ".comment")
BALLOT_COMMENT = (By.CSS_SELECTOR, ".ballot-item-comment")
BALLOT_NEXT = (By.CSS_SELECTOR, "button.next")
BALLOT_ITEM_TEXT = (By.CSS_SELECTOR, ".ballot-item-comment .text")
BALLOT_TEXT_FIELDS = (By.CSS_SELECTOR, ".page-main input.form-control")
BALLOT_TEXT_AREA = (By.CSS_SELECTOR, "textarea.vortex.com-input")
BALLOT_ADD_QUESTION = (By.CSS_SELECTOR, ".qa-add-question")
BALLOT_STATUS = (By.CSS_SELECTOR, ".ballot-item-dates")
BALLOT_CHECKBOX = (By.CSS_SELECTOR, "span.vortex.com-input-replace")
GO_TO_VOTING = (By.CSS_SELECTOR, ".go-to-voting")
PETITION_SIGN = (By.CSS_SELECTOR, ".ballot-item-voting-action button")
PETITION_RESULTS = (By.CSS_SELECTOR, ".ballot-item-results-petition")
SINGLE_ANSWER_QUESTION = (By.CLASS_NAME, "ballot-item-question")
MULTIPLE_ANSWER_QUESTION = (By.XPATH, "//div[@class='question-view multiple-answers not-empty']")
BALLOT_ANSWER_SELECTOR = (By.CSS_SELECTOR, ".ballot-item-answer:not(.cant-vote) .ballot-item-answer-content")
COMMENT_COUNT = (By.CSS_SELECTOR, ".modal-body .ballot-item-comments-count")
RESULTS_VISIBILITY_INPUT = (By.CSS_SELECTOR, "button[id=result-visibility-input]")
RESULTS_VISIBILITY_OPTIONS = (By.CSS_SELECTOR, ".results-visibility-input [role=presentation]")
VOTE_COUNT = (By.CSS_SELECTOR, ".modal-body .ballot-item-status .votes")
VOTE_CAST = (By.CSS_SELECTOR, ".qa-vote-submit")
TAG_INPUT_FIELD = (By.CSS_SELECTOR, ".vortex.com-input-addons-wrapper input")
TAG_BALLOT_PAGE = (By.CSS_SELECTOR, ".ballot-item-tags .tag-item")
ALERT_ERROR_MESSAGE = (By.CSS_SELECTOR, "[role=alert] p")
BALLOT_OPTIONS_MODAL = (By.CSS_SELECTOR, ".modal-content #options-dropdown")
BALLOT_OPTIONS_NON_MODAL = (By.CSS_SELECTOR, "#options-dropdown")
BALLOT_EDIT_SECURITY = (By.CSS_SELECTOR, ".qa-option-edit-security")
BALLOT_ADD_OBSERVERS = (By.XPATH, "//div/button[contains(.,'observer')]")
BALLOT_ADD_PARTICIPANTS = (By.XPATH, "//div/button[contains(.,'participant')]")
BALLOT_ADD_ROLE_BUTTON = (By.CSS_SELECTOR, ".popup-actions .async-button")
BALLOT_SECURITY_GALLERY = (By.CSS_SELECTOR, ".security-editor-group")
BALLOT_VOTED = (By.CSS_SELECTOR, ".votes.voted")
BALLOT_SHARE_FACEBOOK = (By.CSS_SELECTOR, "li.option-shr-fcbk")
BALLOT_IMAGE_GALLERY = (By.CSS_SELECTOR, ".ballot-item-image")
SHARE_BUTTON = (By.NAME, "__CONFIRM__")
USE_TITLE_AS_Q = (By.CSS_SELECTOR, ".qa-title-as-a-question")
BALLOT_TITLE = (By.CSS_SELECTOR, ".ballot-item-title")
BALLOT_DELETE = (By.CSS_SELECTOR, ".modal-body .qa-option-delete")
BALLOT_RESULTS_AVAILABLE = (By.CSS_SELECTOR, ".modal-body .ballot-item-answer-result-progress")
EXPANDER = (By.CSS_SELECTOR, ".expander")
QUESTION_TEXT_INPUT_FIELD = (By.CSS_SELECTOR, "[placeholder='Enter question text']")
PROBLEM_TEXT_INPUT_FIELD = (By.CSS_SELECTOR, ".questions-answer .public-DraftEditor-content")
ANSWER_TEXT_INPUT_FIELD = (By.CSS_SELECTOR, ".questions-answer .public-DraftEditorPlaceholder-inner")
DRAFT_ANSWER_TEXT_INPUT_FIELD = (By.CSS_SELECTOR, ".questions-answer .public-DraftEditor-content")
SHARE_BALLOT_LINK = (By.CSS_SELECTOR, ".shr-lnk")
SHARE_BALLOT_FACEBOOK_MODAL = (By.CSS_SELECTOR, ".ballot-item-vote-followup .shr-fcbk")
SHARE_BALLOT_TWITTER_MODAL = (By.CSS_SELECTOR, ".ballot-item-vote-followup .shr-twttr")
BALLOT_EDIT_BUTTON = (By.CSS_SELECTOR, ".qa-option-edit")

# Facebook

FACEBOOK_EMAIL_INPUT = (By.NAME, 'email')
FACEBOOK_PASSWORD_INPUT = (By.NAME, 'pass')
FACEBOOK_LOGIN_BUTTON = (By.ID, 'loginbutton')

# Twitter

TWITTER_SIGNIN = (By.CSS_SELECTOR, '.button.black')
TWITTER_EMAIL_INPUT = (By.CSS_SELECTOR, '[type=text')
TWITTER_PASSWORD_INPUT = (By.CSS_SELECTOR, '[type=password')
TWITTER_LOGIN_BUTTON = (By.ID, 'signupbutton')
TWITTER_AUTHORISE = (By.ID, 'allow')

# Profile

SAVE_CHANGES = (By.CSS_SELECTOR, "button.save-profile")
PROFILE_PAGE_TEXT_INPUT = (By.CSS_SELECTOR, "input[type=text]")
GENDER_SELECTOR = (By.CSS_SELECTOR, "button#gender-picker")
MALE_GENDER_OPTION = (By.CSS_SELECTOR, ".vortex.com-select li ~ li a")
CUSTOM_GENDER_INPUT = (By.CSS_SELECTOR, "[placeholder='Specify']")
PROFILE_DATE_INPUT = (By.CSS_SELECTOR, ".date-picker input")
PROFILE_PRIVATE_INITIATIVES = (By.CSS_SELECTOR, ".tab-bar .tab-link[href^='/profile']")
PROFILE_NAME_INPUT = (By.CSS_SELECTOR, ".name input")
PROFILE_BIO_INPUT = (By.CSS_SELECTOR, ".about textarea")

# Dashboard

DASHBOARD_ADD_OWNER = (By.CSS_SELECTOR, ".modal-body li ~ li")
DASHBOARD_ADD_ADMINISTRATOR = (By.CSS_SELECTOR, ".modal-body li")
USER_MANAGEMENT = (By.CSS_SELECTOR, "li.user-management")
DASHBOARD_ADD_PARTICIPANTS = (By.CSS_SELECTOR, "button.add-participants")
DELETE_LINE = (By.CSS_SELECTOR, ".delete-row button")
TABLE_LINE = (By.CSS_SELECTOR, ".spreadsheet tbody tr")
USER_MANAGEMENT_CHECKBOX = (By.CSS_SELECTOR, ".invites .qa-bool-input")
