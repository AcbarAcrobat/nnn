# Created by Cmjk at 01.03.2017
@suite1
Feature: forgot password ticket

  Scenario: User can request password reset
    Given I am any user
    When I request password reset
    And I activate forgot password ticket
    Then I am taken to reset password form

  @skip
  Scenario: User can reset password with ticket
    Given I am any user
    When I request password reset
    And I activate forgot password ticket
    And I set new password
      # Then I am authorised on vortex.com # it's not true anymore #TODO: we should check that u're logged out here
    Then my password is changed

  Scenario: User can request password reset through ticket when logged in as the same user
    Given I am any user
    When I request password reset
    And I login with valid credentials
    And I activate forgot password ticket
    Then I am taken to reset password form

  @skip
  Scenario: User can reset password through ticket when logged in as another user
    Given I am non-verified user
      # order matters
    When I request password reset
    And another account is logged in
    And I activate forgot password ticket
    And I choose ticket account
    Then I am taken to reset password form
    And my email is verified
    And I am logged in as ticket user

  @skip
  Scenario: User can choose current account when using someone else's reset password ticket
    Given I am non-verified user
      # order matters
    When I request password reset
    And another account is logged in
    And I activate forgot password ticket
    And I choose current account
    Then I am taken to the user default authenticated page
    And I am logged in as current user
