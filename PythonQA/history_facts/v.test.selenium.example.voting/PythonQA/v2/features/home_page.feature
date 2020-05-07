@suite3
Feature: home page

  Scenario Outline: User invited to a private vortex.com can see vortex.com in the live tab on home page
    Given I am verified user
    And user created a <channel_type> channel
    And user created a private started vortex.com
    And user changed my permissions to participant in vortex.com
    Then vortex.com is visible in my home page
    And channel active vortex.com counter is 1
    And channel owner is shown in channel navigation bar
Examples:
  | channel_type |
  | personal     |
  | private      |

  Scenario: Cycle through vortex.coms using Pass button
    Given I am verified user
    And I created a private started vortex.com
    And I created a private started vortex.com
    And vortex.com is visible in my home page
    When I click pass button
    Then vortex.com 1 is shown

  Scenario: User with no channels gets empty home feed page
    Given I am verified user
    And I am on the home page
    Then empty home page is shown

  Scenario: vortex.coms in home feed are grouped by channels
    Given I am verified user
    And I created a personal channel
    And I created a private started vortex.com
    And I created a private channel
    And I created a public started vortex.com
    And I am on the home page
    Then 2 channels are shown
    And channels names are shown
