Feature: DirectAccess
    I am navigated to valid landing page
	In order to check site
	availability I want to be able
	to opent any of vortex.com pages directly

@SmokeTests @Browser:Chrome
Scenario: Anonymous user can access landing page directly
	Given I am anonymous user
	When I access landing page directly
	Then I am navigated to valid landing page

@NightTests @Browser:Chrome
Scenario: Authenticated user can explore actual vortex.com content
	Given I am any authenticated user
	When I access explore page directly
	Then I see any new vortex.com content

@SmokeTests @Browser:Chrome
Scenario: Anonymous user can access backend api page directly
	Given I am anonymous user
	When I access backend api page directly
	Then I receive data from backend

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can access landing page directly
	Given I am any authenticated user
	When I access landing page directly
	Then I am navigated to valid landing page

@NightlyRun @Browser:Chrome
Scenario: Anonymous user can access any published ballot page directly
	Given I am anonymous user
	And I have any published ballot
	When I access ballot page directly
	Then I am navigated to valid ballot page

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can access any published ballot page directly
	Given I am any authenticated user
	And I have any published ballot
	When I access ballot page directly
	Then I am navigated to valid ballot page

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can access mine published ballot page directly
	Given I am any authenticated user
	And I have mine published ballot
	When I access ballot page directly
	Then I am navigated to valid ballot page

@NightlyRun @Browser:Chrome
Scenario: Anonymous user can access any draft ballot page directly
	Given I am anonymous user
	And I have any draft ballot
	When I access ballot page directly
	Then I am navigated to not found page

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can access mine draft ballot page directly
	Given I am any authenticated user
	And I have mine draft ballot
	When I access ballot page directly
	Then I am navigated to not found page

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can access non mine ballot page directly
	Given I am any authenticated user
	And I have non mine ballot
	When I access ballot page directly
	Then Sign in option is shown

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can access missing ballot page directly
	Given I am any authenticated user
	And I have id of already not existed ballot
	When I access ballot page directly
	Then I am navigated to not found page

@NightlyRun @Browser:Chrome
Scenario: Anonymous user can access search results page directly
	Given I am anonymous user
	When I access search results page directly
	Then I am navigated to valid search results page

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can access search results page directly
	Given I am any authenticated user
	When I access search results page directly
	Then I am navigated to valid search results page

@NightlyRun @Browser:Chrome
Scenario: Anonymous user can access home page directly
	Given I am anonymous user
	When I access home page directly
	Then Sign in option is shown

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can access home page directly
	Given I am any authenticated user
	When I access home page directly
	Then I am navigated to valid home page

@NightlyRun @Browser:Chrome
Scenario: Anonymous user can access explore page directly
	Given I am anonymous user
	When I access explore page directly
	Then Sign in option is shown

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can access explore page directly
	Given I am any authenticated user
	When I access explore page directly
	Then I am navigated to valid explore page

@NightlyRun @Browser:Chrome
Scenario: Anonymous user can access notifications page directly
	Given I am anonymous user
	When I access notifications page directly
	Then Sign in option is shown

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can access notifications page directly
	Given I am any authenticated user
	When I access notifications page directly
	Then I am navigated to valid notifications page

@NightlyRun @Browser:Chrome
Scenario: Anonymous user can access me page directly
	Given I am anonymous user
	When I access me page directly
	Then Sign in option is shown

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can access me page directly
	Given I am any authenticated user
	When I access me page directly
	Then I am navigated to valid me page

@NightlyRun @Browser:Chrome
Scenario: Anonymous user can access channel page directly
	Given I am anonymous user
	And I have any channel
	When I access channel page directly
	Then I am navigated to valid channel page

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can access channel page directly
	Given I am any authenticated user
	And I have any channel
	When I access channel page directly
	Then I am navigated to valid channel page

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can access missing channel page directly
	Given I am any authenticated user
	And I have id of already not existed channel
	When I access channel page directly
	Then I am navigated to not found page

@NightlyRun @Browser:Chrome
Scenario: Anonymous user can access my ballots page directly
	Given I am anonymous user
	When I access my ballots page directly
	Then Sign in option is shown

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can access my ballots page directly
	Given I am any authenticated user
	When I access my ballots page directly
	Then I am navigated to valid my ballots page

@NightlyRun @Browser:Chrome
Scenario: First time signed up user see no ballots accessing his ballots page directly
	Given I am any authenticated user
	When I access my ballots page directly
	Then I see my ballots page with no ballots on it

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can access my ballots page with draft ballot on it directly
	Given I am any authenticated user
	And I have mine draft ballot
	When I access my ballots page directly
	Then I see my ballots page with draft ballot on it

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can access my ballots page with active ballot on it directly
	Given I am any authenticated user
	And I have my active ballot
	When I access my ballots page directly
	Then I see my ballots page with active ballot on it

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can access my ballots page with coming soon ballot on it directly
	Given I am any authenticated user
	And I have mine coming soon ballot
	When I access my ballots page directly
	Then I see my ballots page with coming soon ballot on it

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can access my ballots page with finished ballot on it directly
	Given I am any authenticated user
	And I have my finished ballot
	When I access my ballots page directly
	Then I see my ballots page with finished ballot on it

@NightlyRun @Browser:Chrome
Scenario: Anonymous user can access my channels page directly
	Given I am anonymous user
	When I access my channels page directly
	Then Sign in option is shown

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can access my channels page with no channels on it directly
	Given I am any authenticated user
	And I have no channels
	When I access my channels page directly
	Then I see my channels page with no channels on it

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can access my channels page with channels on it directly
	Given I am any authenticated user
	And I have my channel
	When I access my channels page directly
	Then I see my channels page with channels on it

@NightlyRun @Browser:Chrome
Scenario: Anonymous user can access my feed page directly
	Given I am anonymous user
	When I access my feed page directly
	Then Sign in option is shown

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can access my feed page directly
	Given I am any authenticated user
	When I access my feed page directly
	Then I am navigated to my feed page

@NightlyRun @Browser:Chrome
Scenario: Anonymous user can access all ballots page directly
	Given I am anonymous user
	When I access all ballots page directly
	Then I am navigated to valid all ballots page

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can access all ballots page directly
	Given I am any authenticated user
	When I access all ballots page directly
	Then I am navigated to valid all ballots page

@NightlyRun @Browser:Chrome
Scenario: Anonymous user can access all categories page directly
	Given I am anonymous user
	When I access all categories page directly
	Then I am navigated to valid all categories page

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can access all categories page directly
	Given I am any authenticated user
	When I access all categories page directly
	Then I am navigated to valid all categories page

@NightlyRun @Browser:Chrome
Scenario: Anonymous user can access all channels page directly
	Given I am anonymous user
	When I access all channels page directly
	Then I am navigated to valid all channels page

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can access all channels page directly
	Given I am any authenticated user
	When I access all channels page directly
	Then I am navigated to valid all channels page



