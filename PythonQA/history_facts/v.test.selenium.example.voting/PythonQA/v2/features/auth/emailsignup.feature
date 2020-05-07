@suite3
Feature: email sign up

  Scenario: sign up for new user
    Given I am non-registered user
    When I sign up with valid credentials
    Then I am successfully authenticated

  Scenario: sign up for an existing user
    Given I am existing user
    When I sign up with valid credentials
    Then I am successfully authenticated

  Scenario: name is a required field for signing up
    Given I am non-registered user
    And signup form is open
    When I fill in my email and password
    And I click the signup button
    Then I get a warning saying Name is required
