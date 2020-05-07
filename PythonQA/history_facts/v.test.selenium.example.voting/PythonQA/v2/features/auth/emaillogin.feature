@suite3
Feature: email login

  Scenario: a user can login from the landing page
    Given I am an existing user
    When I login with valid credentials
    Then I am successfully authenticated
    And I am taken to the user default authenticated page

  Scenario: Sign up form as accessible from login form
    Given I am any user
    When I open the Sign up form
    Then I get a valid Sign In form


  Scenario: Authenticated user can sign out
    Given I am verified user
    And I am on the home page
    When I click the sign out button
    Then I am no longer authenticated

  Scenario Outline: Error message is shown when signing in with the wrong password
    Given I am any user
    When I open the Sign In form
    And I login with wrong <field>
    Then I get a warning saying <message>
    Examples:
      | field    | message                                                                 |
      | email    | Oops! That email / password combination is not valid. Please try again. |
      | password | Oops! That email / password combination is not valid. Please try again. |

  Scenario Outline: email and password validation
    Given I am any user
    When I open the Sign In form
    And I login with empty <field>
    Then I get a warning saying <message>
  Examples:
    | field    | message                     |
    | email    | enter a valid email address |
    | password | Password is required        |
