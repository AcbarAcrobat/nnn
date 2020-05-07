# Created by anton at 3/1/2017

@nonbrowser @suite1
Feature: author search
  Scenario: vortex.com in private channel should be searched
    Given I am any user
    And I created a private channel
    And I created a public started vortex.com
    When I do private search by author
    Then author search contains 1 vortex.com