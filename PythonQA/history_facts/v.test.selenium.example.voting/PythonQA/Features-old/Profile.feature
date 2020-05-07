Feature: Profile
	As vortex.com system user i have possibility to view my account elements


@NightlyRun @Browser:Chrome
Scenario: Authenticated user can view his profile small picture
	Given I am any authenticated user
	And I have small picture at my profile
	When I navigating to my profile small picture
	Then I get my small picture

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can view his profile big picture
	Given I am any authenticated user
    And I have big picture at my profile
	When I navigating to my profile big picture
	Then I get my big picture

@NightTests @Browser:Chrome
Scenario: Authenticated user can change his profile name
	Given I am any authenticated user
    And I navigate to my profile
	When I change to my profile name
	Then I get my profile name successfully changed

@NightTests @Browser:Chrome
Scenario: Authenticated user can change his profile location
	Given I am any authenticated user
    And I navigate to my profile
	When I change to my profile location
	Then I get my profile location successfully changed

@NightTests @Browser:Chrome
Scenario: Authenticated user can change his profile date of birth
	Given I am any authenticated user
    And I navigate to my profile
	When I change to my profile date of birth
	Then I get my profile date of birth successfully changed

@NightTests @Browser:Chrome
Scenario: Authenticated user can change his profile gender
	Given I am any authenticated user
    And I navigate to my profile
	When I change to my profile gender
	Then I get my profile gender successfully changed


