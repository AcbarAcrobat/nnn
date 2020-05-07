Feature: EmailLoginFeature
	Feature to test user login with email

@SmokeTests @Browser:Chrome
Scenario: Login for existing user
Given I am existing user   
When I login with my credentials
Then I get successfully authenticated

@RegressionTests @Browser:Chrome
Scenario: Login form is accessible from Sign Up form
Given I am any user  
And I have Sign Up form opened
When I click Login link
Then I get valid Login form

@BugsToFix @Browser:Chrome
Scenario: Login ressurects deleted user 
Given I am existing user 
And I have any ballot
And I have any channel
When I delete my account
And I login with my credentials
Then I get successfully authenticated
And I have my ballot and channel ressurected in the system

@RegressionTests @Browser:Chrome
Scenario: Login with empty credentials
Given I am any user
When I login with empty credentials
Then I get warning saying 'Field required'

@RegressionTests @Browser:Chrome
Scenario: Login with too long credentials
Given I am any user
When I login with too long credentials
Then I get warning saying 'Invalid email'

@RegressionTests @Browser:Chrome
Scenario: Login with special symbols in credentials
Given I am any user
When I login with special symbols in credentials
Then I get warning saying 'Invalid email'







