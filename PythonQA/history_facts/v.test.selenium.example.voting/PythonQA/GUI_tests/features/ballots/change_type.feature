# Created by roman at 5/2/2017

@nonbrowser @suite1
Feature: Change ballot type

  Scenario: User can't change vortex.com type if it is published
    Given I am verified user
    And I created a private published vortex.com
    When I changed vortex.com type
    Then I receive code 403 as response

  Scenario: User can change vortex.com type and questions resets
    Given I am verified user
    And I created a private drafted vortex.com
    When I add question with YesNo type
    And I changed vortex.com type
    Then vortex.com type is Petition
    And questions is empty

  Scenario: User can change vortex.com type and new questions sets
    Given I am verified user
    And I created a private drafted vortex.com
    When I add question with YesNo type
    And I changed vortex.com type and vortex.com questions
    Then vortex.com type is Petition
    And questions is new
