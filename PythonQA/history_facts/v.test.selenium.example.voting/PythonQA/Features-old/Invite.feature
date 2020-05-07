Feature: Invite
	Feature to test invite functionality

@NightTests @Browser:Chrome
Scenario: Content mannager have possibility to edit initiative draft
	Given I am content manager of vortex.com
	And I have my organization
	And I choose administration management tab within the organization
	And I am assigning new organization owner
	Then organization owner has possibility to reach vortex.com through mail send link