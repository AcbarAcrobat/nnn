Feature: home page

  @suite1
  Scenario: User invited to a private vortex.com can see vortex.com in the live tab on home page
    Given I am verified user
    And user created a private started vortex.com
    And I am invited to become participant of that vortex.com
    Then vortex.com is visible in my home page
    And vortex.com is available in live tab
    And the number of pending notifications is 1

  @suite2
  Scenario: User invited to a private vortex.com in a channel can see vortex.com in the live tab on home page
    Given I am verified user
    And user created a private channel
    And user created a private started vortex.com
    And I am invited to become participant of that vortex.com
    Then vortex.com is visible in my home page
    And vortex.com is available in live tab
    And the number of pending notifications is 1

  @suite2
  Scenario: Clicking profile photo in home feed redirects to profile page
    Given I am verified user
    And I created a private started vortex.com
    And I am on the home page
    When I click vortex.com owner button
    Then I am taken to the profile page

  @suite2
  Scenario: Clicking another user's profile photo redirects to profile page
    Given I am verified user
    And user created a private started vortex.com
    And I am invited to become participant of that vortex.com
    And I am on the home page
    When I click vortex.com owner button
    Then I am taken to vortex.com owner page
