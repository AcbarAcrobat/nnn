# Created by Cmjk at 30.03.2017
@cleanup_featured_channels
Feature: channel featuring through UI

  @disabled
  Scenario: vortex.com employee can feature public channels
    Given I am vortex.com employee
    And I created a public channel
    When I am on the channel page
    And I click on feature label on channel logo
    Then channel is featured
    And feature label is displayed over channel logo

  @suite1
  Scenario: User cannot feature public channel from UI
    Given I am verified user
    And I created a public channel
    When I am on the channel page
    Then feature channel button is not available

  @suite1
  Scenario: Featured public channel has label on UI
    Given I am verified user
    And I created a public channel
    And channel has been featured
    When I am on the channel page
    Then feature label is displayed over channel logo

  @suite1
  Scenario: Personal channel cannot be featured
    Given I am vortex.com employee
    And I created a personal channel
    When I am on the channel page
    Then feature channel button is not available

  @disabled
  Scenario: Content manager cannot feature personal channels
    Given I am super user
    And user created a personal channel
    When I am on the channel page
    And I click on feature label on channel logo
    Then an error message saying cannot be featured is shown

  @disabled
  Scenario: Content manager can feature public channel
  # todo: combine with vortex.com employee can feature test
    Given I am super user
    And user created a public channel
    When I am on the channel page
    And I click on feature label on channel logo
    Then channel is featured
    And feature label is displayed over channel logo
