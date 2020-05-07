Feature: personal channel
  @suite1 @nonbrowser
  Scenario: newly created user shall has channel with the same id and isPersonal=true and all textual fields shall be the same
    Given I am non-verified user
    Then my personal channel is created
    And my personal channel has isPersonal flag set to true

  @suite1
  Scenario: navigating to personal channel by id redirect to user profile
    Given I am verified user
    When I navigate to my personal channel
    Then I am taken to the profile page

  @suite2 @nonbrowser
  Scenario: delete of user shall delete its personal channel too
    Given I am any user
    When I delete my user
    Then my personal channel is removed

  @suite2
  Scenario: Create standalone vote from UI shall get user personal channel id
    Given I am verified user
    When I create a vote with all required fields provided
    Then vote is part of my personal channel

  @suite2 @nonbrowser
  Scenario: Create standalone petition from API with channelId = null and check that channel id get user personal channel id
    Given I am existing user
    And I created a public started vortex.com
    Then vote is part of my personal channel

  @suite1
  Scenario: Private Initiatives created in the personal channel shall be displayed on user profile page
    Given I am verified user
    And I created a private started vortex.com
    Then the vortex.com appears in private vortex.coms in user profile

  @suite2
  Scenario: Click on user initiative caption shall open user page not channel
    Given I am verified user
    And I created a private started vortex.com
    When I navigate to my personal channel
    And I click vortex.com owner button
    Then I am taken to the profile page


  @suite2 @nonbrowser
  Scenario: Personal channel owner should not unfollow its own channel through the API
    Given I am any user
    When I unfollow my personal channel
    Then I am following my personal channel

  @suite2
  Scenario: Personal channel owner should not unfollow its own channel through the UI
    Given I am verified user
    When I navigate to my user id page
    Then follow button is not available

  @suite2
  Scenario: Open security page for personal channel shall redirect to profile page and do not show access management page
    Given I am verified user
    When I navigate to my personal security page
    Then I am taken to the profile page

  @suite2 @nonbrowser
  Scenario: Deleting personal channel is not possible
    Given I am any user
    When I delete my personal channel
    Then my personal channel is not removed

  @suite1 # case 9
  Scenario: Drafts created in the personal channel shall be displayed on user profile page
    Given I am verified user
    And I created a public drafted vortex.com
    Then the vortex.com appears in draft vortex.coms in user profile
