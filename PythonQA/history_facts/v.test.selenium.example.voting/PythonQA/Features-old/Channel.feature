Feature: Channel feature
	Feature to test user possibility to create and manipulate channel

@RegressionTests @Browser:Chrome
Scenario: User can create channel with minimal required fields provided
	Given I am any authenticated user
	When I am creating a channel with minimal required fields provided
	Then I get navigated to valid channel page

@SmokeTests @Browser:Chrome
Scenario: User can create channel with all required fields provided
	Given I am any authenticated user
	When I am creating a channel with all required fields provided
	Then I get navigated to valid channel page

@NightTests @Browser:Chrome 
Scenario: User cannot publish channel with empty fields provided
	Given I am any authenticated user
	When I am creating a channel with empty fields provided
	Then I get error appeared for every required filled that is empty

@RegressionTests @Browser:Chrome
Scenario: Created channel appears on the system
	Given I am any authenticated user
	And I am creating a channel with minimal required fields provided
	When I search for my channel
	Then My channel appears

@NightTests @Browser:Chrome
Scenario: User can assign ballot to just created channel
	Given I am any authenticated user
	And I am creating a channel with minimal required fields provided
	When I choose ballot creation option within the channel
	And I am creating a vote with minimal required fields provided
	Then channel successfully assigned to the ballot

@NightTests @Browser:Chrome
Scenario: Channel page contains assigned to this channel ballot
	Given I am any authenticated user
    And I am creating a channel with minimal required fields provided
	And I choose ballot creation option within the channel
	When I am creating a vote with minimal required fields provided
	And I save created vote as a draft
	Then I can see this ballot at channel page respectively


