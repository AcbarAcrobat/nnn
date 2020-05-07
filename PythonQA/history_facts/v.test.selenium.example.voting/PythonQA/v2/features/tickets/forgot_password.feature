@suite3
Feature: forgot password tickets

Scenario: User can request password reset
  Given I am any user
  When I request password reset
  Then forgot password ticket is generated

 Scenario: User can use forgot password ticket to reset password
   Given I am any user
   And I requested password reset
   When I activate forgot password ticket
   And I input a new password
   Then my password is changed

Scenario: invalid ticket page
  Given I am any user
  When I navigate to invalid ticket page
  Then an invalid ticket page is shown
