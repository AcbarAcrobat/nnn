Feature: EmailSignUpFeature
	Feature to test user sign up with email

@SmokeTests @Browser:Chrome
Scenario: Sign Up for new user
Given I am new user   
When I sign up with my credentials
Then I get successfully authenticated

@RegressionTests @Browser:Chrome
Scenario: Sign Up for existing user
Given I am existing user   
When I sign up with my credentials
Then I get successfully authenticated

@RegressionTests @Browser:Chrome
Scenario: Sign Up with empty credentials
Given I am any user   
When I sign up with empty credentials
Then I get warning saying 'Field required'

@RegressionTests @Browser:Chrome
Scenario: Signup with too long credentials
Given I am any user
When I sign up with too long credentials
Then I get warning saying 'Invalid email'

@RegressionTests @Browser:Chrome
Scenario: Signup with special symbols in credentials
Given I am any user
When I sign up with special symbols in credentials
Then I get warning saying 'Invalid email'

@RegressionTests @Browser:Chrome
Scenario: Sign Up for deleted user
Given I am deleted user 
When I sign up with my credentials
Then I get successfully authenticated


