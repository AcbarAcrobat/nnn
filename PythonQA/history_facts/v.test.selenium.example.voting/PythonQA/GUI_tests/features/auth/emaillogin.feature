Feature: email login
    @suite1
Scenario: a user can login from the landing page
    Given I am an existing user
    When I login with valid credentials
    Then I am successfully authenticated
    And I am taken to the user default authenticated page

    @suite2
Scenario: Login form is accessible from Sign Up form
    Given I am any user
    When I open the Sign Up form
    And I click the Sign In link
    Then I get a valid Sign In form

    @notimplemented
Scenario: Login with empty credentials
    Given I am any user
    When I open the Sign In form
    And I login with empty credentials
    Then I get a warning saying Field required

    @notimplemented
Scenario: Login with too long credentials
    Given I am any user
    When I open the Sign In form
    And I login with credentials that are too long
    Then I get a warning saying Invalid email

    @notimplemented
Scenario: Login with special symbols in credentials
    Given I am any user
    When I open the Sign In form
    And I login with special symbols in credentials
    Then I get a warning saying Invalid email

    @suite1
Scenario: Authenticated user can sign out
    Given I am verified user
    When I click the sign out button
    Then I am no longer authenticated

    @suite1
Scenario: Error message is shown when signing in with the wrong password
    Given I am any user
    When I open the Sign In form
    And I login with wrong password
    Then I get a warning saying Oops! That email / password combination is not valid. Please try again.

    @suite1
Scenario: Error message is shown when signing in with the wrong email
    Given I am any user
    When I open the Sign In form
    And I login with wrong email
    Then I get a warning saying Oops! That email / password combination is not valid. Please try again.
