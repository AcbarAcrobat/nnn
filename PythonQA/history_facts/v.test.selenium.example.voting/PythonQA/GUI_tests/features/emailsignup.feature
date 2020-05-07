Feature: email sign up
    @suite1
Scenario: sign up for new user
    Given I am non-registered user
    When I sign up with valid credentials
    Then I am successfully authenticated

    @suite2
Scenario: sign up for an existing user
    Given I am existing user
    When I sign up with valid credentials
    Then I am successfully authenticated
