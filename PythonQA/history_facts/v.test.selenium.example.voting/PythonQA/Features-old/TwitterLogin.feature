Feature: TwitterLogin
	Feature to test vortex.com login with twitter social network

@SmokeTests @Browser:Chrome
Scenario: Twitter login page is accessible from Sign Up form
Given I am any user
And I have Sign Up form opened
When I click Twitter link
Then I get Twitter login page

@BugsToFix @Browser:Chrome
Scenario: Sign Up with Twitter for new user
Given I am new user of vortex.com with valid Twitter account
When I sign up with my Twitter account
And I grant Twitter access to vortex.com
Then I get successfully authenticated

@NightTests @Browser:Chrome
Scenario: Sign Up with Twitter for new user closing Twitter login page
Given I am new user of vortex.com with valid Twitter account
When I sign up with my Twitter account
And I close Twitter login page
Then I don't get authenticated

@NightTests @BugsToFix @Browser:Chrome
Scenario: Sign Up with Twitter for new user with e-mail already used in vortex.com
Given I am new user of vortex.com with valid Twitter account
And My twitter e-mail is already used in vortex.com
When I sign up with my Twitter account
And I grant Twitter access to vortex.com
Then I get error saying user already taken

@NightTests @Browser:Chrome
Scenario: Sign Up with Twitter for new user denying Twitter access to vortex.com
Given I am new user of vortex.com with valid Twitter account
When I sign up with my Twitter account
And I deny Twitter access to vortex.com
Then I don't get authenticated