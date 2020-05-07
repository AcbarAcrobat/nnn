# Created by roman at 06-Jun-17
Feature: Channels onboarding

  @suite2 @nonbrowser
  Scenario: Content manager can update onboarding feed
    Given I am super user
    And user created a public channel
    And user created a public channel
    And user created a public channel
    When I update channels onboarding feed with all channels
    And I request onboarding channels feed
    Then onboarding channels feed contains all channels

  @suite2 @nonbrowser
  Scenario Outline: Only content manager can update onboarding feed
    Given I am <user>
    And user created a public channel
    And user created a public channel
    And user created a public channel
    When I update channels onboarding feed with all channels
    Then I receive code <response_code> as response
    Examples:
      | user           | response_code |
      | super user     | 200           |
      | verified user  | 401           |
      | vortex.com employee | 401           |


  @suite2 @nonbrowser
  Scenario: Guest can request onboarding feed
    Given I am super user
    And user created a public channel
    And user created a public channel
    And user created a public channel
    When I update channels onboarding feed with all channels
    And anonymous user request onboarding channels feed
    Then onboarding channels feed contains all channels

  @suite2 @nonbrowser
  Scenario: Onboarding channels can't contains private channels
    Given I am super user
    And user created a private channel
    When I update channels onboarding feed with all channels
    Then I receive code 400 as response

  @suite2 @nonbrowser
  Scenario: Update onboarding feed with new channels
    Given I am super user
    And user created a public channel
    And user created a public channel
    And user created a public channel
    When I update channels onboarding feed with A1 and A2
    And I update channels onboarding feed with A3 and A2
    And I request onboarding channels feed
    Then onboarding channels feed contains A3 and A2

  @suite2 @nonbrowser
  Scenario: Clean up onboarding feed
    Given I am super user
    And user created a public channel
    And user created a public channel
    When I update channels onboarding feed with all channels
    And I update channels onboarding feed with no channels
    And I request onboarding channels feed
    Then onboarding channels feed contains no channels