Feature: follow
    @nopublicusergeneratedcontent # @suite1
Scenario: Ballots from followed channels appear in home page feed
    Given I am authenticated user
    When I navigate to the explore page
    And I follow a channel
    Then vortex.coms from that channel appear in my home feed

    @nopublicusergeneratedcontent # @suite1
Scenario: Ballots from unfollowed channels are removed from home page feed
    Given I am authenticated user
    And I am following a channel with active vortex.coms
    When I unfollow the channel
    Then vortex.coms from that channel disappear from my home feed

    @nopublicusergeneratedcontent # @suite2
Scenario Outline: Follower list is updated when an entity's follow state changes
    Given I am authenticated user
    And I am <follow_status> a channel with active vortex.coms
    When I <follow_action> the channel
    Then the follower count is <changed> by 1
Examples:
|follow_status|follow_action|changed|
|following    |unfollow     |decreased|
|not following|follow       |increased|
