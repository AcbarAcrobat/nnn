# Created by Cmjk at 01.03.2017
@suite3
Feature: verify email tickets

  Scenario: User can verify email through ticket
    Given I am non-verified user
    When I activate verify email ticket
    Then login form with my email prefilled is shown
    When I fill in my password
    And I click the signup button
    Then I am successfully authenticated
    And my email is verified

  Scenario: User can verify email through ticket when logged in as the same user
    Given I am non-verified user
    And I am logged in
    When I activate verify email ticket
    Then I am successfully authenticated
    And my email is verified


  Scenario: User can verify email through ticket when logged in as another user
    Given I am non-verified user
    And user is logged in though the UI
    When I activate verify email ticket
    Then login form with my email prefilled is shown
    When I fill in my password
    And I click the signup button
    Then I am successfully authenticated
    And my email is verified
