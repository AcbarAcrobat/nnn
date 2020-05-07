Feature: Roles
	Feature to check vortex.com roles actions availability

@NightTests @Browser:Chrome
Scenario: Content mannager have possibility to edit initiative draft
	Given I am content manager of vortex.com
	And I am signing up into system with correct credentials
	And I am open any initiative draft
	When I edit any initiative draft information
	Then i get initiative draft saved successfully

@NightTests @Browser:Chrome
Scenario: Content mannager have possibility to edit published initiative
	Given I am content manager of vortex.com
	And I am signing up into system with correct credentials
	And I am open any published initiative
	When I edit any published initiative information
	Then i get published initiative saved successfully

@NightTests @Browser:Chrome
Scenario: Content mannager have possibility to edit channel
	Given I am content manager of vortex.com
	And I am signing up into system with correct credentials
	And I am open any channel
	When I edit any channel information
	Then i get channel saved successfully

@NightTests @Browser:Chrome
Scenario: Content mannager have possibility to edit organization
	Given I am content manager of vortex.com
	And I am signing up into system with correct credentials
	And I am open any organization
	When I edit any organizationinformation
	Then i get organization saved successfully
