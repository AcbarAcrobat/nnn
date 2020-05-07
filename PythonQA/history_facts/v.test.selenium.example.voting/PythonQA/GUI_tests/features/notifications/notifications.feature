# Created by Cmjk at 20.01.2017
Feature: notifications

  @suite1 # case 0
  Scenario Outline: Invited to entity
    Given I am verified user
    And I am invited to become a member of a <privacy> <entity>
    When I navigate to the notifications page
    Then the number of pending notifications is 1
    And total user notification count is 1
    Examples:
      | privacy | entity  |
      | private | channel |
      | private | vortex.com   |

  @suite1 # case 1 + 2
  Scenario Outline: Removed from entity
    Given I am verified user
    And I am invited to become a member of a <privacy> <entity>
    And I have been removed from the <entity>
    When I navigate to the notifications page
    Then the number of pending notifications is 2
    And total user notification count is 2
    And no entity links are visible on my notifications page
    Examples:
      | privacy | entity  |
      | private | channel |
      | private | vortex.com   |


  @suite1 # case 3
  Scenario Outline: Entity deleted with existing notification
    Given I am verified user
    And user created a private started vortex.com
    And user changed my permissions to participant in vortex.com
    And user created a private <entity>
    And user changed my permissions to participant in <entity2>
    And <entity2> has been deleted
    And I am on the profile page
    Then total user notification count is 1
    And the number of pending notifications is 1

    Examples:
      | entity        | entity2 |
      | channel       | channel |
      | started vortex.com | vortex.com   |

  @suite1 # case 4
  Scenario Outline: Entity deleted with no existing notifications
    Given I am verified user
    And I am invited to become a member of a <privacy> <entity>
    And <entity> has been deleted
    And I am on the profile page
    Then the number of pending notifications is 0
    And total user notification count is 0
    Examples:
      | privacy | entity  |
      | private | channel |
      | private | vortex.com   |

  @suite1 # case 5-6
  Scenario: Unverified user cannot access notifications
    Given I am non-verified user
    And I am authorized on vortex.com
    When I navigate to the notifications page
    Then you need to verify your email to see notifications page is shown

  @suite1 # case 7
  Scenario: Invites to drafts spawn no notifications
    Given I am verified user
    And I am invited to become a member of a private draft
    When I navigate to the notifications page
    Then the number of pending notifications is 0
    And total user notification count is 0

  @investigating # case 8
  Scenario: Notification created when entity is published from draft
    Given I am verified user
    And I am invited to become a member of a private draft
    And I have published the draft
    When I navigate to the notifications page
    Then the number of pending notifications is 1
    And total user notification count is 1

  @suite1 # case 9
  Scenario Outline: Notifications screen has notifications
    Given I am verified user
    And I am invited to become a member of a <privacy> <entity>
    When I navigate to the notifications page
    And I click <entity> notification link
    Then I am taken to the <entity>
    Examples:
      | privacy | entity  |
      | private | vortex.com   |
      | private | channel |
