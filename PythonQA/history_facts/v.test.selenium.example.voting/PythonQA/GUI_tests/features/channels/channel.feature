Feature: channel
  @suite1
Scenario: A user can create channel with all required fields provided
    Given I am verified user
    When I create a channel with all required fields provided
    Then I get navigated to a valid public channel page

  @suite1
Scenario: A user can create a private channel with all required fields provided
    Given I am verified user
    When I create a private channel with all required fields provided
    Then I get navigated to a valid private channel page

  @suite1
Scenario: A channel creator can delete his channel
    Given I am verified user
    And I created a private channel
    When I am on the channel page
    And I delete the channel
    Then the channel is removed

  @suite2
Scenario: A non-verified user can't create channels
    Given I am non-verified user
    And I am authorized on vortex.com
    When I create a private channel with all required fields provided
    Then channel is not created
    And you need to verify your email banner is shown

  @suite2
Scenario: User can create channel with minimal required fields provided
    Given I am verified user
    When I create a channel with minimum required fields provided
    Then I get navigated to a valid channel page


  @suite2
Scenario Outline: A channel owner/administrator can edit the channel
    Given I am verified user
    And I created a <type> channel
    And I changed my permissions to <role> in channel
    When I am on the channel page
    And I click edit channel button
    Then I get navigated to a valid channel edit page
Examples:
|role|type|
|owner|private|
|administrator|private|

  @suite2
Scenario Outline: A channel member becomes channel follower and has channel in menu
    Given I am any user
    And I created a <type> channel
    And I invited another user to become <role> in my channel
    When that user logs in and navigates to the channel
    Then user becomes a channel follower
Examples:
|role|type|
|owner|private|
|administrator|private|
|participant|private|

  @disabled
Scenario Outline: Privacy checkbox in channel edit reflects channel type
    Given I am verified user
    And I created a <type> channel
    When I am on the channel page
    And I click edit channel button
    Then privacy checkbox is <status>
Examples:
|type|status|
|private|checked|
|public |unchecked|

  @suite2
Scenario Outline: A channel owner/administrator can edit the channel values
    Given I am verified user
    And I created a private channel
    And I changed my permissions to <role> in channel
    And I created a public started vortex.com
    When I am on the channel page
    And I click edit channel button
    And I edit the <field> field in my channel settings
    And I save changes
    And I click edit channel button
    Then updated value of channel field <field> is shown
Examples:
|role|field|
|owner|name|
|administrator|name|
|owner|bio|
|owner|short description|
|administrator|bio|
|administrator|short description|


  @suite1
Scenario Outline: A private channel with vortex.coms in it can be deleted
    Given I am verified user
    And I created a private channel
    And I created a <vortex.com_type> started vortex.com
    When I am on the channel page
    And I delete the channel
    Then the channel is removed
Examples:
|vortex.com_type|
|public      |
|private     |

  @suite2
Scenario Outline: A channel with vortex.coms in it can be deleted
    Given I am verified user
    And I created a <channel_type> channel
    And I created a public started vortex.com
    And vortex.com has <vote_count> votes
    When I am on the channel page
    And I delete the channel
    Then the channel is <channel_status>
Examples:
|channel_type|vote_count|channel_status|
|public|threshhold - 1|removed   |
|private|threshhold - 1|removed   |
|private|threshhold + 1|removed   |

Examples:
|channel_type|vote_count|channel_status|
|public|threshhold + 1|not removed|
|public|threshhold    |not removed|
|private|threshhold    |removed   |

  @suite2
Scenario Outline: Channel admin cannot delete channel
    Given I am verified user
    And I created a <channel_type> channel
    And I changed my permissions to administrator in channel
    When I am on the channel page
    And I click edit channel button
    Then the delete channel button is <button_status>
Examples:
|channel_type|button_status|
|public|not visible|
|private|not visible|


  @suite2
Scenario Outline: Channel member cannot edit channel info
    Given I am verified user
    And I created a <channel_type> channel
    And I changed my permissions to member in channel
    When I am on the channel page
    Then Edit Channel button is not available
Examples:
|channel_type|
|public|

Examples:
|channel_type|
|private|


  @suite2 @nonbrowser
Scenario Outline: A channel participant cannot edit the channel
    Given I am any user
    And I created a <type> channel
    And I changed my permissions to participant in channel
    When I update channel <field> through the API
    Then I receive code 401 as response
Examples:
|type|field|
|public|name|
|private|name|

Examples:
|type|field|
|public|bio|
|public|short description|
|private|bio|
|private|short description|


  @suite1
  Scenario: Channel can be created with logo
    Given I am verified user
    And I created a private channel
    And I have uploaded channel logo
    When I am on the channel page
    Then channel logo is seen

  @suite1
  Scenario: Channel logo can be uploaded
    Given I am verified user
    And I created a private channel
    When I am on the channel page
    And I click edit channel button
    And I upload image2 as channel logo
    And I save changes
    Then channel logo is seen
