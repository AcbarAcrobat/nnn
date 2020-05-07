# Created by cmjk at 2/8/2017
  @nonbrowser @suite1
Feature: vortex.com feed
  Scenario Outline: vortex.com feed me as actor
    Given I am any user
    And I created a <type> channel
    And I created a <privacy> <state> vortex.com
    And I have <vote status> vote in vortex.com
    And I changed my permissions to <role> in <entity>
    When I request vortex.com feed
    Then vortex.com feed contains <output>
Examples:
  | privacy | state   | vote status| type     | role                                     | entity  | output  |
  | private | started | cast       | personal | owner                                    | channel | 1 vortex.com |
  | public  | started | not cast   | personal | owner                                    | channel | 0 vortex.com |
  | public  | started | cast       | private  | member                                   | channel | 1 vortex.com |
  | public  | started | not cast   | private  | viewSecurity, viewProfile, createBallot  | channel | 0 vortex.com |
  | public  | started | not cast   | public   | member                                   | channel | 0 vortex.com |
  | private | started | not cast   | public   | voter                                    | vortex.com   | 1 vortex.com |
  | private | started | not cast   | private  | voter                                    | vortex.com   | 1 vortex.com |
  | public  | started | not cast   | private  | viewSecurity, vote                       | vortex.com   | 0 vortex.com |
  | private | started | not cast   | private  | vote                                     | vortex.com   | 0 vortex.com |
  | public  | started | cast       | public   | voter                                    | vortex.com   | 0 vortex.com |

  Scenario Outline: vortex.com feed as non-actor
    Given I am any user
    And user created a <type> channel
    And user created a <privacy> <status> vortex.com
    And user changed my permissions to <role> in <entity>
    And I have <vote status> vote in vortex.com
    When I request vortex.com feed
    Then vortex.com feed contains <output>
Examples:
  | privacy | status  | vote status | type     | role                                   | entity  | output  |
  | public  | started | not cast    | private  | member                                 | channel | 1 vortex.com |
  | public  | started | not cast    | private  | takedownBallot,viewProfile,viewBallots | channel | 0 vortex.com |
  | public  | started | cast        | public   | member                                 | channel | 0 vortex.com |
  | private | started | cast        | public   | voter                                  | vortex.com   | 1 vortex.com |
  | private | started | not cast    | private  | voter                                  | vortex.com   | 1 vortex.com |
  | private | started | cast        | personal | voter                                  | vortex.com   | 1 vortex.com |
  | private | started | not cast    | personal | viewBallot,vote                        | vortex.com   | 0 vortex.com |
  | public  | started | not cast    | private  | viewSecurity,viewBallot                | vortex.com   | 0 vortex.com |
  | private | started | not cast    | private  | viewBallot                             | vortex.com   | 0 vortex.com |
  | public  | started | not cast    | public   | voter                                  | vortex.com   | 0 vortex.com |
  | public  | started | not cast    | public   | voter                                  | vortex.com   | 0 vortex.com |

  Scenario Outline: vortex.com filtering as actor
    Given I am any user
    And I created a <type> channel
    And I created a <privacy> <status> vortex.com
    And I have <vote status> vote in vortex.com
    And I changed my permissions to <role> in <entity>
    When I request vortex.com feed
    Then vortex.com feed contains <output>
Examples:
  | privacy | status              | vote status | type     | role   | entity  | output  |
  | private | published_in_future | not cast    | personal | owner  | vortex.com   | 0 vortex.com |
  | public  | drafted             | not cast    | private  | member | channel | 0 vortex.com |
  | private | ended               | not cast    | public   | voter  | vortex.com   | 0 vortex.com |

  Scenario Outline: vortex.com filtering as non-actor
    Given I am any user
    And user created a <type> channel
    And user created a <privacy> <status> vortex.com
    And user changed my permissions to <role> in <entity>
    And I have <vote status> vote in vortex.com
    When I request vortex.com feed
    Then vortex.com feed contains <output>
Examples:
  | privacy | status              | vote status | type    | role            | entity  | output  |
  | public  | published_in_future | not cast    | private | member          | channel | 0 vortex.com |
  | private | drafted             | not cast    | public  | voter,editDraft | vortex.com   | 0 vortex.com |
  | public  | not_started         | not cast    | private | member          | channel | 0 vortex.com |
  | private | not_started         | not cast    | public  | voter           | vortex.com   | 0 vortex.com |

  Scenario Outline: vortex.com filtering ended with votes
    Given I am any user
    And user created a <type> channel
    And user created a <privacy> started vortex.com
    And user changed my permissions to <role> in <entity>
    And I have <vote status> vote in vortex.com
    And vortex.com has already finished
    When I request vortex.com feed
    Then vortex.com feed contains <output>
Examples:
  | privacy | vote status | type    | role   | entity  | output  |
  | public  | not cast    | private | member | channel | 0 vortex.com |
  | public  | cast        | private | member | channel | 1 vortex.com |
  | private | cast        | public  | voter  | vortex.com   | 1 vortex.com |
  | public  | not cast    | private | member | channel | 0 vortex.com |
  | private | not cast    | public  | voter  | vortex.com   | 0 vortex.com |


  Scenario: vortex.com feed sorting case 1
    Given I am any user
    # vortex.com 1
    And I created a private drafted vortex.com
    # vortex.com 2
    And I created a public channel
    And I created a private started vortex.com
    And I have cast vote in vortex.com
    And I changed my permissions to voter in vortex.com
    # vortex.com 3
    And I created a private channel
    And I created a private started vortex.com
    And I have cast vote in vortex.com
    And I changed my permissions to voter in vortex.com
    # vortex.com 4
    And I created a private channel
    And I created a public not_started vortex.com
    And I changed my permissions to member in channel
    # vortex.com 5
    And I created a private channel
    And I created a public started vortex.com
    And I changed my permissions to member in channel
    # vortex.com 6
    And I created a private channel
    And I created a public started vortex.com
    And I changed my permissions to member in channel
    And I have cast vote in vortex.com
    And vortex.com has already finished
    # vortex.com 7
    And I created a personal channel
    And I created a private started vortex.com
    And I have not cast vote in vortex.com
    And vortex.com has already finished
    When I request vortex.com feed
    Then vortex.com feed contains 4 vortex.com
    And vortex.coms are returned in the following order vortex.com6,vortex.com5,vortex.com3,vortex.com2

  Scenario: non-verified user doesn't see vortex.com in vortex.com feed
    Given I am non-verified user
    And I am invited to become a member of a private vortex.com
    When I request vortex.com feed
    Then vortex.com feed contains 0 vortex.com

  Scenario: vortex.com feed sorting case 2
    Given I am any user
    # vortex.com 1
    And I created a personal channel
    And I created a private started vortex.com
    And I have not cast vote in vortex.com
    And vortex.com has already finished
    # vortex.com 2
    And I created a private channel
    And I created a public started vortex.com
    And I changed my permissions to member in channel
    And I have cast vote in vortex.com
    And vortex.com has already finished
    # vortex.com 3
    And I created a private channel
    And I created a public started vortex.com
    And I changed my permissions to member in channel
    # vortex.com 4
    And I created a private channel
    And I created a public not_started vortex.com
    And I changed my permissions to member in channel
    # vortex.com 5
    And I created a private channel
    And I created a private started vortex.com
    And I have cast vote in vortex.com
    And I changed my permissions to voter in vortex.com
    # vortex.com 6
    And I created a public channel
    And I created a private started vortex.com
    And I have cast vote in vortex.com
    And I changed my permissions to voter in vortex.com
    # vortex.com 7
    And I created a private drafted vortex.com
    When I request vortex.com feed
    Then vortex.com feed contains 4 vortex.com
    And vortex.coms are returned in the following order vortex.com6,vortex.com5,vortex.com3,vortex.com2
