Feature: FacebookLogin
	Feature to test vortex.com login with facebook social network

@SmokeTests @Browser:Chrome
Scenario: Facebook login page is accessible from Sign Up form
Given I am any user
And I have Sign Up form opened
When I click Facebook link
Then I get Facebook login page

@BugsToFix @Browser:Chrome
Scenario: Sign Up with Facebook for new user
Given I am new user of vortex.com with valid Facebook account
When I sign up with my Facebook account
And I grant Facebook access to vortex.com
Then I get successfully authenticated

@NightTests @Browser:Chrome
Scenario: Sign Up with Facebook for new user closing Facebook login page
Given I am new user of vortex.com with valid Facebook account
When I sign up with my Facebook account
And I close Facebook login page
Then I don't get authenticated

@NightTests @BugsToFix @Browser:Chrome
Scenario: Sign Up with Facebook for new user with e-mail already used in vortex.com
Given I am new user of vortex.com with valid Facebook account
And My Facebook e-mail is already used in vortex.com
When I sign up with my Facebook account
And I grant Facebook access to vortex.com
Then I get error saying user already taken

@NightTests @Browser:Chrome
Scenario: Sign Up with Facebook for new user denying Facebook access to vortex.com
Given I am new user of vortex.com with valid Facebook account
When I sign up with my Facebook account
And I deny Facebook access to vortex.com
Then I don't get authenticated





