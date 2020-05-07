# Created by roman at 4/26/2017
@nonbrowser @suite1
Feature: Home feed

  Scenario Outline: Channel subscribers does not see empty channel in home feed
    Given I am vortex.com user
    And user created a <privacy> channel
    And user changed my permissions to member in channel
    When I request my home feed
    Then home feed contains no channels
    Examples:
      | privacy |
      | public  |
      | private |

  Scenario Outline: User see new vortex.coms in home feed
    Given I am vortex.com user
    And user created a <privacy> channel
    And user changed my permissions to member in channel
    And user created a public <type> vortex.com
    And I have <vote_status> my vote in the vortex.com
    When I request my home feed
    Then home feed contains <state in feed>
    Examples:
      | privacy | type        | vote_status | state in feed |
      | private | started     | not cast    | the channel   |
      | private | started     | cast        | no channels   |
      | private | ended       | not cast    | no channels   |
      | private | draft       | not cast    | no channels   |
      | private | not_started | not cast    | no channels   |
      | public  | started     | not cast    | the channel   |
      | public  | started     | cast        | no channels   |
      | public  | ended       | not cast    | no channels   |
      | public  | draft       | not cast    | no channels   |
      | public  | not_started | not cast    | no channels   |

  Scenario Outline: User see channels in home feed in correct order
    Given I am vortex.com user
    And user created a private channel
    And user changed my permissions to member in channel
    And user created a public drafted vortex.com
    And user created a public drafted vortex.com
    And user created a private channel
    And user changed my permissions to member in channel
    And user created a public drafted vortex.com
    And user created a public drafted vortex.com
    And user created a private channel
    And user changed my permissions to member in channel
    And user created a public drafted vortex.com
    And user created a public drafted vortex.com
    And user published vortex.coms in <publish_order> order
    When I request my home feed
    Then channels are listed in <result_order>
    And channels have <count> vortex.coms
    Examples:
      | publish_order      | result_order | count   |
      | [1, 2, 3, 4, 5, 6] | [3,2,1]      | [1,2,2] |
      | [4, 1, 6, 3, 2, 5] | [2,1,3]      | [2,2,1] |
      | [6, 4, 5, 3, 2, 1] | [1,2,3]      | [2,2,1] |
      | [6, 2, 5, 3, 1, 4] | [1,2,3]      | [2,2,1] |
      | [6, 2, 1, 3, 4, 5] | [1,3,2]      | [2,1,2] |
      | [6, 3, 5, 1, 2, 4] | [1,2,3]      | [2,2,1] |

  Scenario Outline: User see votable ballots
    Given I am vortex.com user
    And user created a <privacy> channel
    And user changed my permissions to member in channel
    And user created a public <type> vortex.com
    And I have <vote_status> my vote in the vortex.com
    When I request votable ballots for the channel
    Then votable ballots contains <state in result>
    Examples:
      | privacy | type        | vote_status | state in result |
      | private | started     | not cast    | the vortex.com       |
      | private | started     | cast        | no vortex.coms       |
      | private | ended       | not cast    | no vortex.coms       |
      | private | draft       | not cast    | no vortex.coms       |
      | private | not_started | not cast    | no vortex.coms       |
      | public  | started     | not cast    | the vortex.com       |
      | public  | started     | cast        | no vortex.coms       |
      | public  | ended       | not cast    | no vortex.coms       |
      | public  | draft       | not cast    | no vortex.coms       |
      | public  | not_started | not cast    | no vortex.coms       |

  Scenario: User see votable ballots in publish date descending order
    Given I am vortex.com user
    And user created a private channel
    And user changed my permissions to member in channel
    And user created a public started vortex.com
    And user created a public started vortex.com
    When I request votable ballots for the channel
    Then votable ballots contains vortex.com2 then vortex.com1