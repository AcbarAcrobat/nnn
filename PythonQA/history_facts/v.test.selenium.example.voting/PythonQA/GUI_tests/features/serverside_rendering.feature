# Created by Cmjk at 24.02.2017
@nonbrowser
Feature: serverside rendering

  Scenario: serverside rendering for crawlers and bots is running positive
    Given superuser requested serverside render of a vortex.com that exists
    Then I receive code 200 as response
    And meta tags and values are valid

# @suite2
  Scenario Outline: serverside rendering for crawlers and bots is running negative
    Given I requested serverside render of a vortex.com that <options>
    Then I receive code <code_response> as response
    Examples:
      | options        | code_response |
      | does not exist | 404           |
      | is private     | 403           |
