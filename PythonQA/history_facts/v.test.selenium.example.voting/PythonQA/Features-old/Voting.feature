Feature: Voting feature

    @SmokeTests @Browser:Chrome
    Scenario: Authenticated user can vote for ballot without requirnments
	Given I am any authenticated user
	And I have any active ballot that I can vote for
	When I access ballot page directly
	And I select any valid answears
	And I cast my vote
	Then I get valid thank you for voting view

	@NightlyRun @Browser:Chrome
	Scenario: Authenticated user can vote for vote once requirenment ballot 
	Given I am any authenticated user
	And I have active ballot with vote once requirnment
	When I access ballot page directly
	And I select any valid answears
	And I cast my vote
	Then I get valid thank you for voting view

	@NightlyRun @Browser:Chrome
	Scenario: Authenticated user can vote for ballot with vote once requirenment only once
	Given I am any authenticated user
	And I have active ballot with vote once requirnment
	When I access ballot page directly
	And I select any valid answears
	And I cast my vote
	Then I get valid thank you for voting view
	Then Instead of button for voting i see result section
	
    @NightlyRun @Browser:Chrome
	Scenario: Authenticated user can vote for ballot with specific email pattern
	Given I am any authenticated user
	And I have active ballot with email pattern matching user email
	When I access ballot page directly
	And I select any valid answears
	And I cast my vote
	Then I get valid thank you for voting view

    @NightlyRun @Browser:Chrome
	Scenario: Authenticated user cannot vote for a ballot with specific email pattern
	Given I am any authenticated user
	And I have active ballot with email pattern different from user email
	When I access ballot page directly
	And I select any valid answears
	And I cast my vote
	Then I get ballot can be voted only with specific email pattern error

	@NightlyRun @Browser:Chrome
	Scenario: Authenticated user should get age requirenments error
	Given I am any authenticated user
	And I have active ballot with age requirnments 
	When I access ballot page directly
	And I select any valid answears
	And I cast my vote
	Then I get age requirnments error

	@NightlyRun @Browser:Chrome
	Scenario: Authenticated user can vote for a ballot with the same location 
	Given I am any authenticated user
	And I have active ballot with location requirnments matching user location
	When I access ballot page directly
	And I select any valid answears
	And I cast my vote
	Then I get persona verification pop up

	@NightlyRun @Browser:Chrome
	Scenario: Authenticated user cannot vote for a ballot with different location  
	Given I am any authenticated user
	And I have active ballot with location requirnments not matching user location
	When I access ballot page directly
	And I select any valid answears
	And I cast my vote
	Then I get persona verification pop up

	@NightlyRun @Browser:Chrome
	Scenario: Authenticated user should be asked for the documents voting for ballot with face requirenments 
	Given I am any authenticated user
	And I have active ballot with face requirnments 
	When I access ballot page directly
	And I select any valid answears
	And I cast my vote
	Then I get persona verification pop up
