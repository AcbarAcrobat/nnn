Feature: Auth
 Authentification feature

@NightlyRun @Browser:Chrome
Scenario: Simple login with facebook
Given I am new user of vortex.com
When I login with facebook
Then I get user logged into system

@NightlyRun @Browser:Chrome
Scenario: Signup with correct user
Given I am new user of vortex.com
When I am signing up into system with correct credentials
Then I am successfully authentificated into system
When I am signing in into system with just signed up user
Then I am successfully authentificated into system

@NightlyRun @Browser:Chrome
Scenario: Signin with deleted user
Given I am new user of vortex.com
When I am signing up into system with correct credentials
Then I am successfully authentificated into system
When I delete user from profile
And I am signing in into system with just signed up user
Then I have error message that the user is not in the system

@NightlyRun @Browser:Chrome
Scenario: Register with facebook
Given I am new user of vortex.com
When I sign up with facebook
And I grant access to vortex.com in facebook
Then I get message about successfull login

@NightlyRun @Browser:Chrome
Scenario: Sign in with facebook second time
Given I am already registered with facebook user
When I am signing into system through facebook
Then I am successfully logged into system

@NightlyRun @Browser:Chrome
Scenario: Sign in with facebook when somebody already registered with facebook email
Given I am already registered with email user
And I already registered in the system with facebook email
When I am signing into system through facebook
Then I get warning message that this email is already taken

@NightlyRun @Browser:Chrome
Scenario: Sign in with already created user
Given I am already registered with email user
When I am signing into system with already registered user email credentials
Then I am successfully logged into system

@NightlyRun @Browser:Chrome
Scenario: Sign in with empty fields
Given I am already registered with email user
When I am signing into system with empty fields
Then I get warning message that input fields shouldn't be empty

@NightlyRun @Browser:Chrome
Scenario: Sign in with abracadbra fields
Given I am already registered with email user
When I am signing into system with abracadbra fields
Then I get warning message that input fields should be valid email and password

@NightlyRun @Browser:Chrome
Scenario: Sign in with incorrect password
Given I am already registered with email user
And I already registered in the system
When I am signing into system with correct email and incorrect password
Then I get warning message that password is incorrect

@NightlyRun @Browser:Chrome
Scenario: Sign in with invalid email and valid password
Given I am already registered with email user
When I am signing into system with incorrect email and correct password
Then I get warning message that email is incorrect

@NightlyRun @Browser:Chrome
Scenario: Sign in with valid email and empty password
Given I am already registered with email user
When I am signing into system with correct email and empty password
Then I get warning message that password is emtpy

@NightlyRun @Browser:Chrome
Scenario: Sign in with empty  email and valid password
Given I am already registered with email user
When I am signing into system with empty email and correct password
Then I get warning message that email is emtpy

@NightlyRun @Browser:Chrome
Scenario: Sign in with empty email and incorrect password
Given I am already registered with email user
When I am signing into system with empty email and incorrect password
Then I get warning message that email is emtpy and password is incorrect

@NightlyRun @Browser:Chrome
Scenario: Sign in with incorrect email and empty password
Given I am already registered with email user
When I am signing into system with incorrect email and empty password
Then I get warning message that email is incorrect and password is emtpy

@NightlyRun @Browser:Chrome
Scenario: Sign in with incorrect email and valid password
Given I am already registered with email user
When I am signing into system with random not excisted credentials
Then I get warning message that such user is not exists in the system

@NightlyRun @Browser:Chrome
Scenario: Signup with incorrect email
Given I am new user of vortex.com
When I am signing into system with incorrect email
Then I get warning message

@NightlyRun @Browser:Chrome
Scenario: Signup with different passowrds
Given I am new user of vortex.com
When I am signing into system with different passowrds
Then I get warning message

@NightlyRun @Browser:Chrome
Scenario: Signup with empty fields
Given I am new user of vortex.com
When I am signing into system with empty fields
Then I get warning message

@NightlyRun @Browser:Chrome
Scenario: Signup with abracadabra fields
Given I am new user of vortex.com
When I am signing into system with abracadabra fields
Then I get warning message

@NightlyRun @Browser:Chrome
Scenario: Signup with already existed user
Given I am already registered with email user
When I am signing into system with already registered user credentials
Then I get warning message that this user is already excist in system

@NightlyRun @Browser:Chrome
Scenario: Signup with correct email and empty password
Given I am new user of vortex.com
When I am signing into system with correct email and empty password
Then I get warning message that input fields shouldn't be empty

@NightlyRun @Browser:Chrome
Scenario: Signup with correct email and incorrect password
Given I am new user of vortex.com
When I am signing into system with correct email and incorrect password
Then I get warning message that password is incorrect

@NightlyRun @Browser:Chrome
Scenario: Signup with incorrect email and empty password
Given I am new user of vortex.com
When I am signing into system with incorrect email and empty password
Then I get warning message that input fields shouldn't be empty

@NightlyRun @Browser:Chrome
Scenario: Signup with empty email and incorrect password
Given I am new user of vortex.com
When I am signing into system with empty email and incorrect password
Then I get warning message that input fields shouldn't be empty

@NightlyRun @Browser:Chrome
Scenario: Signup with empty email and correct password
Given I am new user of vortex.com
When I am signing into system with empty email and correct password
Then I get warning message that input fields shouldn't be empty

@NightlyRun @Browser:Chrome
Scenario: Signup with incorrect email and correct password
Given I am new user of vortex.com
When I am signing into system with incorrect email and correct password
Then I get warning message that email pattern is incorrect

@NightlyRun @Browser:Chrome
Scenario: Signup with one password field valid and other password field empty
Given I am new user of vortex.com
When I am signing into system with one password field valid and other password field empty
Then I get warning message that input fields shouldn't be empty

@NightlyRun @Browser:Chrome
Scenario: Signup with one password field empty and other password field valid
Given I am new user of vortex.com
When I am signing into system with one password field empty and other password field valid
Then I get warning message that input fields shouldn't be empty

@NightlyRun @Browser:Chrome
Scenario: Signin with content manger
Given I am content manager of vortex.com
When I am signing up into system with correct credentials
Then I am successfully authentificated into system


