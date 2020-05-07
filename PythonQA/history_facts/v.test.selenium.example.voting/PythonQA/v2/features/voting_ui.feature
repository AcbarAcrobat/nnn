# Created by Cmjk at 19.04.2017
@suite3
Feature: voting through ui

  Scenario Outline: User can vote in a quick/custom vote
    Given I am verified user
    And I created a private <type> vortex.com
    And I navigate to vortex.com page
    When I cast my vote
    Then my vote is cast
    And vote results are shown
    And vote count is updated
Examples:
    |type|
    |quick|
    |started|

  Scenario Outline: User can vote in a face or star rating vote
    Given I am verified user
    And I created a private <type> vortex.com
    And I navigate to vortex.com page
    When I cast my vote
    Then my vote is cast
    And vote count is updated
    And vote results are shown
Examples:
    |type|
    |facerating|
    |starrating|

  Scenario: user can vote in a survey
    Given I am verified user
    And I created a private started survey
    And I navigate to vortex.com page
    When I cast my votes in a survey
    Then my vote is cast
    And vote count is updated
    And vote results are shown

  Scenario: when vote is cast results are shown for 5 seconds
    Given I am verified user
    And I created a private quick vortex.com
    And I navigate to vortex.com page
    When I cast my vote
    Then next button is shown and removed

  Scenario: more from channel button is shown when voting on vortex.com page
    Given I am verified user
    And I created a public channel
    And I created a public started vortex.com
    And I created a public started vortex.com
    When I request vortex.com directly
    And I cast my vote
    Then more from channel button is shown
