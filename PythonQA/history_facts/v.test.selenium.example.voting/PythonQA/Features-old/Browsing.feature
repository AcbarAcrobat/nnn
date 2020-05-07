Feature: Browsing
	Feature represents user browsing expierence

    @NightlyRun @Browser:Chrome
	Scenario: Anonymous user can browse search results
	Given I am anonymous user
	When I browse search functionality 
	Then I am navigated to Search results page

    @NightlyRun @Browser:Chrome
	Scenario: Authenticated user can browse search results
	Given I am any authenticated user
	When I browse search functionality 
	Then I am navigated to Search results page

    @NightlyRun @Browser:Chrome
	Scenario: Anonymous user can browse categories
	Given I am anonymous user
	When I browse categories 
	Then I am navigated to all categories list
	 
    @NightlyRun @Browser:Chrome
	Scenario: Authenticated user can browse categories
	Given I am any authenticated user
	When I browse categories 
	Then I am navigated to all categories list

    @NightlyRun @Browser:Chrome
	Scenario: Anonymous user can browse all ballots
	Given I am anonymous user
	When I browse all ballots 
	Then I am navigated to all ballots page

    @NightlyRun @Browser:Chrome
	Scenario: Authenticated user can browse all ballots
	Given I am any authenticated user
	When I browse all ballots 
	Then I am navigated to all ballots page

    @NightlyRun @Browser:Chrome
	Scenario: Anonymous user can browse popular in region ballots
	Given I am anonymous user
	When I browse popular in region ballots
	Then I am navigated to popular in region ballots page

    @NightlyRun @Browser:Chrome
	Scenario: Authenticated user can browse popular in region ballots
	Given I am any authenticated user
	When I browse popular in region ballots
	Then I am navigated to popular in region ballots page

    @NightlyRun @Browser:Chrome
	Scenario: Anonymous user can browse ballot from landing page
	Given I am anonymous user
	When I browse any ballot from landing page
	Then I am navigated to the ballot page

    @NightlyRun @Browser:Chrome
	Scenario: Authenticated user can browse ballot from landing page
	Given I am any authenticated user
	When I browse any ballot from landing page
	Then I am navigated to the ballot page

    @NightlyRun @Browser:Chrome
	Scenario: Anonymous user can browse channel from landing page
	Given I am anonymous user
	When I browse any channel from landing page
	Then I am navigated to the channel page

    @NightlyRun @Browser:Chrome
	Scenario: Authenticated user can browse channel from landing page
	Given I am any authenticated user
	When I browse any channel from landing page
	Then I am navigated to the channel page

    @NightlyRun @Browser:Chrome
	Scenario: Anonymous user can browse ballot from home page
	Given I am anonymous user
	When I browse any ballot from home page
	Then I am navigated to the home page

    @NightlyRun @Browser:Chrome
	Scenario: Authenticated user can browse ballot from home page
	Given I am any authenticated user
	When I browse any ballot from home page
	Then I am navigated to the home page

    @NightlyRun @Browser:Chrome
	Scenario: Anonymous user can browse channel from home page
	Given I am anonymous user
	When I browse any channel from home page
	Then I am navigated to the home page

    @NightlyRun @Browser:Chrome
	Scenario: Authenticated user can browse channel from home page
	Given I am any authenticated user
	When I browse any channel from home page
	Then I am navigated to the home page

    @NightlyRun @Browser:Chrome
	Scenario: Anonymous user can browse notifications page
	Given I am anonymous user
	When I browse notifications page
	Then I am navigated to the notifications page

    @NightlyRun @Browser:Chrome
	Scenario: Authenticated user can browse notifications page
	Given I am any authenticated user
	When I browse notifications page
	Then I am navigated to the notifications page

    @NightlyRun @Browser:Chrome
	Scenario: Anonymous user can browse me page
	Given I am anonymous user
	When I browse me page
	Then I am navigated to valid me page

    @NightlyRun @Browser:Chrome
	Scenario: Authenticated user can browse me page
	Given I am any authenticated user
	When I browse me page
	Then I am navigated to valid me page

    @NightlyRun @Browser:Chrome
	Scenario: Anonymous user can browse quick search 
	Given I am anonymous user
	When I search anything in quick search  
	Then I am navigated to search results page

    @NightlyRun @Browser:Chrome
	Scenario: Authenticated user can browse quick search 
	Given I am any authenticated user
	When I search anything in quick search  
	Then I am navigated to search results page

    @NightlyRun @Browser:Chrome
	Scenario: Anonymous user can browse his feed
	Given I am anonymous user
	When I browse my feeds
	Then I can see my all feeds

    @NightlyRun @Browser:Chrome
	Scenario: Authenticated user can browse his feed
	Given I am any authenticated user
	When I browse my feeds
	Then I can see my all feeds

    @NightlyRun @Browser:Chrome
	Scenario: Anonymous user can browse his channels
	Given I am anonymous user
	When I browse my channels
	Then I can see my all channels
	 
    @NightlyRun @Browser:Chrome
	Scenario: Authenticated user can browse his channels
	Given I am any authenticated user
	When I browse my channels
	Then I can see my all channels

    @NightlyRun @Browser:Chrome
	Scenario: Anonymous user can browse his ballots
	Given I am anonymous user
	When I browse my ballots
	Then I can see my all ballots

    @NightlyRun @Browser:Chrome
	Scenario: Authenticated user can browse his ballots
	Given I am any authenticated user
	When I browse my ballots
	Then I can see my all ballots
