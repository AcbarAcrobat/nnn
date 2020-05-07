Feature: vote
#
#  @suite1
#  Scenario: User can publish vote with all required fields provided
#    Given I am verified user
#    And I create a vote with all required fields provided
#    When I publish the vote
#    Then I get navigated to a valid vote page
#
#
#  @suite2
#  Scenario: User can create a drafted vote
#    Given I am verified user
#    And I create a vote with all required fields provided
#    When I save the vortex.com as a draft
#    Then the vortex.com appears in drafts
#
#  @suite2
#  Scenario: User can edit drafts
#    Given I am verified user
#    And I created a public drafted vortex.com
#    When I edit the draft
#    And I save draft changes
#    And I view the draft
#    Then updated draft values are shown
#
#  @suite1
#  Scenario: User can use vortex.com question as title
#    Given I am verified user
#    And I create a private vote without a title
#    When I publish the vote
#    Then vortex.com is available in live tab
#    And question is used as vortex.com title
#
#  @suite1
#  Scenario: User can add extra answers when creating a vote
#    Given I am verified user
#    And I create a vote with 2 answers
#    When I add an answer
#    Then the answer count becomes equal to 3
#
#  @suite1
#  Scenario: User can remove excess answers when creating a vote
#    Given I am verified user
#    And I create a vote with 3 answers
#    When I remove an answer
#    Then the answer count becomes equal to 2

  @suite1
  Scenario Outline: Ballots created from channel page are owned by the channel
    Given I am verified user
    And I created a <channel_privacy> channel
    And I create a <vortex.com_privacy> vote with all required fields provided
    When I publish the vortex.com
    Then I get navigated to a valid channel page
    And the vortex.com is visible in <vortex.com_privacy> initiatives tab
    Examples:
      | channel_privacy | vortex.com_privacy |
      | private         | private       |
#      | private         | public        |
#
#  @suite1
#  Scenario: Invalid page id is handled
#    Given I am any user
#    When I navigate to invalid vortex.com page
#    Then page parameters are invalid page is shown
#
#  @suite1
#  Scenario: User can edit open-ended vortex.com
#    Given I am verified user
#    And I created a private openended vortex.com
#    And I added a freetext answer to the vote
