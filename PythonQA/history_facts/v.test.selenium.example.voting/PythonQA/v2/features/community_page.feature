# Created by Cmjk at 07.06.2017
@suite3
Feature: community page

  Scenario: portrait button takes user to personal channel
    Given I am verified user
    And I am on the home page
    When I click the portrait button
    Then I am taken to my personal channel page
    And my personal channel page has no votes

  Scenario Outline: votes appear in personal channel after being created
    Given I am verified user
    And I created a public <type> vortex.com
    And I am on my personal channel page
    Then <ui_name> votes count is 1
Examples:
  | type    | ui_name |
  | started | open    |
  | drafted | drafted |
  | ended   | closed  |

  Scenario: votes created from personal channel page belong to user's personal channel
    Given I am verified user
    And I am on my personal channel page
    When I click the new button
    And I create a quick vote
    And I publish the vote
    Then vortex.com is created
    And vortex.com channelId matches user id

  Scenario: open vote counts are updated when a vote is made on community page
    Given I am verified user
    And I created a public channel
    And I created a public started vortex.com
    And I created a public started vortex.com
    And I am on the channel page
    Then community page notifications count is 2
    And open votes count is 2
    When I cast my vote
    Then community page notifications count is 1
    And open votes count is 1

  Scenario: pending votes are displayed on community page
    Given I am verified user
    And I created a public channel
    And I created a public started vortex.com
    And I have cast my vote in vortex.com
    And I am on the channel page
    Then pending votes count is 1
