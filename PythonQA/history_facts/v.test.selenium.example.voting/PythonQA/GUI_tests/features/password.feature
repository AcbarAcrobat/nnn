@suite2
Feature: password change UI

  Scenario: Authenticated user can change password
    Given I am verified user
    When I open change password form
    And I fill out the change password form with valid passwords
    And I submit the change password form
    Then my password is changed

  Scenario: New and old password cannot be equal
    Given I am verified user
    When I open change password form
    And I fill out the change password form with the same password
    And I submit the change password form
    Then an error message saying Passwords should not be equal is shown

  Scenario Outline: New password missing
    Given I am verified user
    When I open change password form
    And I fill out the change password form with just the <input field> password
    And I submit the change password form
    Then a special border is applied to <unfilled field> password field
    Examples:
      | input field | unfilled field |
      | current     | new            |
      | new         | current        |

  Scenario: Both new and current password missing
    Given I am verified user
    When I open change password form
    And I submit the change password form
    Then a special border is applied to new password field
    Then a special border is applied to current password field

  Scenario: change password form can be closed
    Given I am verified user
    When I open change password form
    And I close the change password form
    Then change password form is closed
