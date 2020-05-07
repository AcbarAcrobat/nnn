Feature: Analytics
	Feature to test analytics charts

@NightTests @Browser:Chrome
Scenario: User can create initiative and see analytics on it
Given I am any authenticated user
	And I have any active ballot that I can vote for
	When I access ballot page directly
	And I select any valid answears
	And I cast my vote
	When I search voted ballot
	Then I can see analytics chart with my vote counted
