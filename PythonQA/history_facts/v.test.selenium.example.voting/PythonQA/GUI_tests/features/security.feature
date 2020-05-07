Feature: security

  @suite2
  Scenario: User can create a private vote in a channel
    Given I am verified user
    And I created a private channel
    And I create a public vortex.com with all required fields provided
    When I publish the vortex.com
    Then vortex.com is available in live tab
# todo: view results verification

  @suite1
  Scenario: User can create a private vortex.com
    Given I am verified user
    And I create a private vortex.com with all required fields provided
    When I publish the vortex.com
    Then vortex.com is available in live tab
    And edit security form is available
    And I am listed as vortex.com admin

  @suite2
  Scenario: Ballot owner can edit vortex.com security
    Given I am verified user
    And I created a private started vortex.com
    And I navigate to vortex.com page
    When I invite a user to be participant in my vortex.com
    Then invited user is shown as participant

  @suite1
  Scenario Outline: private vortex.com visibility on pages
    Given I am verified user
    And I created a private started vortex.com
    When I navigate to the <page> page
    Then the vortex.com is <visibility>
    Examples:
      | page                   | visibility |
      | my_private_initiatives | visible    |
#|explore|hidden|
#|home   |hidden|

  @suite2
  Scenario Outline: Sign out from private page shows sign in form and Not Authorized page underneath
    Given I am verified user
    And I am on private <page> page
    When I click the sign out button
    Then sign in form is shown
    Then I see Not authorized to view this page
    Examples:
      | page |
      #blocked by 6909|channel|
      | feed |

  @suite1
  Scenario Outline: Content manager can delete vortex.coms
    Given I am content manager
    And user created a <privacy> started vortex.com
    And I navigate to vortex.com page
    When I delete the vortex.com
    Then the vortex.com is deleted
    Examples:
      | privacy |
      | public  |
      | private |

  @suite1
  Scenario Outline: Private channel owner can edit vortex.coms unless they have at least 1 vote
    Given I am verified user
    And I created a private channel
    And I created a public started vortex.com
    And vortex.com has <vote_count> votes
    And I navigate to vortex.com page
    When I am on the vortex.com page
    Then edit button is <edit_button_status>
    Examples:
      | vote_count     | edit_button_status |
      | threshhold - 1 | shown              |
      | threshhold     | not shown          |
      | threshhold + 1 | not shown          |

#todo: enable
  @disabled
  Scenario: adding user to private vortex.com also adds user to parent channel
    Given I am any user
    And user created a personal channel
    And user created a private started vortex.com
    And user changed my permissions to voter in vortex.com
    When I request channel security
    Then I am listed as channel member
