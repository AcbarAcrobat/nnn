@nonbrowser @suite2
Feature: report for marketing
  Scenario: Usual user can't download report
    Given I am verified user
    When I request marketing report
    Then I receive code 401 as response

  Scenario: Anonymous access is disabled
    Given I am anonymous user
    When I request marketing report
    Then I receive code 401 as response


  Scenario: vortex.com user can download report
    Given I am vortex.com employee
    When I request marketing report
    Then I receive code 200 as response