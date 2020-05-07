# Created by Cmjk at 18.04.2017
@suite3
Feature: vortex.com creation

  Scenario: User can go from empty feed to vote creation page
    Given I am verified user
    And I am on the home page
    When I click the create vote button
    Then I am taken to a valid create vote page

  Scenario Outline: Quick votes can be created
    Given I am verified user
    And I am on the vote creation page
    When I create a <vote_type> vote
    And I publish the vote
    Then I am taken to the vote created page
    And vortex.com is created
Examples:
    |vote_type|
    |quick    |
    |custom   |
    |starrating|
    |facerating|
    |survey    |

  Scenario: vortex.com can be created with image
    Given I am verified user
    And I am on the vote creation page
    When I create a quick vote
    And I add an image to the vote
    And I publish the vote
    Then I am taken to the vote created page
    And vortex.com is created

  Scenario: custom end date can be set when creating vortex.com
    Given I am verified user
    And I am on the vote creation page
    When I create a custom vote
    And I set a custom end date
    And I publish the vote
    Then I am taken to the vote created page
    And vote end date is set to correct value

  Scenario: custom end time can be set when creating vortex.com
    Given I am verified user
    And I am on the vote creation page
    When I create a custom vote
    And I set a custom end time
    And I publish the vote
    Then I am taken to the vote created page
    And vote end time is set to correct value

  Scenario Outline: answers can be added and removed in custom votes
    Given I am verified user
    And I am on the vote creation page
    When I create a custom vote
    And I <action> an answer
    Then answer count is <count>
Examples:
    |action|count|
    |add   |3    |
    |remove|1    |

  Scenario: vortex.com with empty answers cannot be created
    Given I am verified user
    And I am on the vote creation page
    When I create a custom vote
    And I add an answer
    Then next button is not visible

  Scenario: survey vortex.com with less than 2 questions cannot be created
    Given I am verified user
    And I created a private drafted survey
    And I navigate to draft page
    When I remove a question
    Then next button is not visible

  Scenario: survey vortex.com can be created with an optional question
    Given I am verified user
    And I created a private drafted survey
    And I navigate to draft page
    When I add an optional question
    And I publish the vote
    Then I am taken to the vote created page
    And vote has an optional question

  Scenario: survey can be created with mixed question types
    Given I am verified user
    And I created a private drafted survey
    And survey has no questions
    And I navigate to draft page
    When I add a facerating question
    And I add a starrating question
    And I add a text question
    And I press next button
    And I publish the vote
    Then I am taken to the vote created page
    And vote has a question of each kind

  Scenario: default endsUtc date is 8pm 1 week from now
    Given I am verified user
    And I am on the vote creation page
    When I create a quick vote
    And I publish the vote
    Then I am taken to the vote created page
    And vortex.com is created
    And vote end date is set to default value
    And vote end time is set to default value
