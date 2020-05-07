Feature: Vote publishing
	Feature to test user possibility to create and publish vote

@NightTests @Browser:Chrome
Scenario: User can publish vote with minimal required fields provided
	Given I am any authenticated user
	And I am creating a vote with minimal required fields provided
	When I publish vote
	Then I get navigated to valid vote page

@RegressionTests @Browser:Chrome
Scenario: User can publish vote with all required fields provided
	Given I am any authenticated user
	And I am creating a vote with all required fields provided
	When I publish vote
	Then I get navigated to valid vote page

@NightTests @Browser:Chrome
Scenario: User cannot publish vote with empty fields provided
	Given I am any authenticated user
	And I am creating a vote with empty fields provided
	When I publish vote
	Then I get list of errors about required fields that are not filled

@RegressionTests @Browser:Chrome
Scenario: Published vote appears on the system
	Given I am any authenticated user
	And I am creating a vote with minimal required fields provided
	And I publish vote
	When I search for my ballot
	Then My ballot appears

@RegressionTests @Browser:Chrome
Scenario: User can create drafted vote 
	Given I am any authenticated user
    And I am creating a vote with minimal required fields provided
	When I save created vote as a draft
	Then I am navigated to valid vote draft page

@NightTests @Browser:Chrome
Scenario: User can publish drafted vote 
	Given I am any authenticated user
    And I am creating a vote with minimal required fields provided
	And I save created vote as a draft
	When I publish drafted vote
	Then I get navigated to valid vote page

