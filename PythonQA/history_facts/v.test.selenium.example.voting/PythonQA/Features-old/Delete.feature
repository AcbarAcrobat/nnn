Feature: Delete
	As vortex.com system user i have possibility to delete my account

@NightlyRun @Browser:Chrome
Scenario: User gets confirmation dialog for account deletion
	Given I am existing vortex.com user
	When I try to delete my account
	Then I get confirmation dialog asking for user password

@NightlyRun @Browser:Chrome
Scenario: When user cancels confirmation dialog his account is not deleted
	Given I am existing vortex.com user
	When I try to delete my account
	Then I get confirmation dialog asking for user password
	When I cancel confirmation dialog
	Then I don't get deleted from vortex.com

@NightlyRun @Browser:Chrome
Scenario: When user provides correct password in confirmation dialog his account gets deleted
	Given I am existing vortex.com user
	When I try to delete my account
	Then I get confirmation dialog asking for user password
	When I provide correct password in confirmation dialog
	Then I get logged out from vortex.com
	And I get succesful user deletion message
    And I get deleted from vortex.com

@NightlyRun @Browser:Chrome
Scenario: When user provides incorrect password in confirmation dialog his account is not deleted
	Given I am existing vortex.com user
	When I try to delete my account
	Then I get confirmation dialog asking for user password
	When I provide incorrect password in confirmation dialog
	Then I get error message in confirmation dialog
	And I don't get deleted from vortex.com

@NightlyRun @Browser:Chrome
Scenario: Check user ballot existence after deletion
	Given I am existing vortex.com user
	And I have any mine ballot
	When I delete my account
    Then All my ballots get deleted from vortex.com

@NightlyRun @Browser:Chrome
Scenario: Check user channel existence after deletion
	Given I am existing vortex.com user
	And I have any mine channel
	When I delete my account
    Then All my channels get deleted from vortex.com

@NightlyRun @Browser:Chrome
Scenario: Check user comments after deletion
	Given I am existing vortex.com user
	And I have any comment
	When I delete my account
    Then My comments are not deleted from vortex.com

@NightlyRun @Browser:Chrome
Scenario: Deleted user cannot login into system
	Given I am existing vortex.com user
	When I delete my account
	Then I can't login into vortex.com

@NightlyRun @Browser:Chrome
Scenario: Delete user account with attempt to sign up with it
	Given I am existing vortex.com user
	When I delete my account
	Then I can register into the system with deleted user

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can delete his channel
	Given I am any authenticated user
	And I have my channel
	When I try to delete my channel
	Then I got my channel deleted from the system

@NightlyRun @Browser:Chrome
Scenario: Authenticated user cannot delete not his channel
	Given I am any authenticated user
	When I have not mine channel
    Then I cannot delete not mine channel

@NightlyRun @Browser:Chrome
Scenario: Authenticated user can delete his ballot
	Given I am any authenticated user
	And I have any mine ballot
	When I try to delete my ballot
	Then I got my ballot deleted from the system

