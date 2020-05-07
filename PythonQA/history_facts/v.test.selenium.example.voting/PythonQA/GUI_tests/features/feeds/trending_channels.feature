# Created by roman at 07-Jun-17
Feature: Trending channels

  @suite2 @nonbrowser
  Scenario: User requests trending channels
    Given I am a verified user
    And I created a public channel
    And I created a private channel
    And I created a public channel
    When anonymous user request trending channels
    Then only public channels returns

  @suite2 @nonbrowser
  Scenario: Channels with most subscribers are first in trending communities feed
    Given I am a verified user
    And I created a public channel
    And I add 20 members to the channel
    When I request trending channels
    Then only public channels returns
    And the trending channels feed contains channel1 at the first place
    And I delete the channel

  @suite2 @nonbrowser
  Scenario: Channels with the same name and popularity sorted by id
    Given I am verified user
    And I created a public channel
    And I add 20 members to the channel
    And I created a public channel
    And I add 20 members to the channel
    When I request trending channels
    Then only public channels returns
    And the trending channels feed contains channel2 at the first place then channel1
    And I delete all my channels

  @suite2 @nonbrowser
  Scenario: There is no private channels in trending communities
    Given I am verified user
    And I created a private channel
    And I add 20 members to the channel
    When I request trending channels
    Then only public channels returns
    And the trending channels feed does not contain the channel

  @suite2 @nonbrowser
  Scenario: Channels with 0 popularity are in trending feed
    Given I am supper user
    And I created a public channel
    And I unsubscribe from my personal channel
    When I request trending channels
    Then only public channels returns
    And the trending channels feed contains the channel
    And I delete the channel