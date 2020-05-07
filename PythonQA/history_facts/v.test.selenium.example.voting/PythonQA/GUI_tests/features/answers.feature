# Created by Cmjk at 18.01.2017
@nonbrowser
Feature: analytics

  Scenario: Voices endpoint
    Given I am any user
    And there is active vortex.com with no requirements
    Then vortex.com voices are available

  Scenario: Dimensions can be added
    Given I am any user
    And I created a private channel
    And I created a private started vortex.com
    When I add a dimension to the vortex.com
    Then dimension is added

  Scenario: Dimensions can be edited
    Given I am any user
    And I have added a dimension to a vortex.com
    When I edit the dimension
    Then dimension is changed

  Scenario: FreeText answers can be added to a vortex.com
    Given I am any user
    And I created a public drafted vortex.com
    And I added a freetext answer to the vote
    Then freetext answer is added

  Scenario: default answer weight is 1
    Given I am any user
    And I created a public started vortex.com
    Then answers have weight 1

  Scenario: answers can have weight
    Given I am any user
    And I created a public drafted vortex.com
    And I added an answer with weight 2 to the vote
    Then answer has weight 2
