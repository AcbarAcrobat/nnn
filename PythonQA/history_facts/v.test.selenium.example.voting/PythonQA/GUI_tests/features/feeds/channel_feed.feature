# Created by roman at 2/7/2017
@nonbrowser @suite1
Feature: channel feed

  Scenario Outline: There is a user who at least a member of channel with next vortex.com and I not voted in ballot
    Given I am any user
    And user created a private channel
    And user created a private <status> vortex.com
    And I am invited to become participant of that vortex.com
    And I have <vote_status> my vote in the vortex.com
    And vortex.com has <finish_status> finished
    When I request my channel feed
    Then channel feed contains the channel
    And channel ballotsCount property value equals <vortex.coms_count>
    Examples:
      | status              | vote_status | finish_status | vortex.coms_count |
      | started             | not cast    | not yet       | 1            |
      | started             | cast       | not yet       | 0            |
      | published           | not cast   | not yet       | 0            |
      | published_in_future | not cast   | not yet       | 0            |
      | started             | cast       | already       | 0            |
      | started             | not cast   | already       | 0            |
      | draft               | not cast   | not yet       | 0            |


  Scenario: Newly registered user shall receive own personal channel from feed only
    Given I am any user
    When I request my channel feed
    Then channel feed contains only my personal channel


  Scenario: Newly created channel shall appear in user channels feed
    Given I am any user
    And I created a private channel
    When I request my channel feed
    Then channel feed contains the channel


  Scenario Outline: When user has any right to channel than this channel appears in channels feed
    Given I am any user
    And I created a private channel
    And I changed my permissions to <role> in channel
    When I request my channel feed
    Then channel feed contains the channel
    Examples:
      | role          |
      | participant   |
      | administrator |
      | owner         |

  Scenario Outline: There is user who is member of channel1 and channel2 and there are vortex.coms in channels
    Given I am any user
    And user created a private channel
    And user created a private <status1> vortex.com
    And I am invited to become participant of that vortex.com
    And I have <vote_status_1> my vote in the vortex.com
    And vortex.com has <finish_status_1> finished
    And user created a private channel
    And user created a private <status2> vortex.com
    And I am invited to become participant of that vortex.com
    And I have <vote_status_2> my vote in the vortex.com
    And vortex.com has <finish_status_2> finished
    When I request my channel feed
    Then channel feed contains <order>
    Examples:
      | status1             | vote_status_1 | finish_status_1 | status2             | vote_status_2 | finish_status_2 | order                  |
    #a - a
      | started             | not cast     | not yet         | started             | not cast     | not yet         | channel2 then channel1 |
    #a - b-f
      | started             | not cast     | not yet         | started             | cast         | not yet         | channel1 then channel2 |
      | started             | not cast     | not yet         | published           | not cast     | not yet         | channel1 then channel2 |
      | started             | not cast     | not yet         | published_in_future | not cast     | not yet         | channel1 then channel2 |
      | started             | not cast     | not yet         | started             | cast         | already         | channel1 then channel2 |
      | started             | not cast     | not yet         | started             | not cast     | already         | channel1 then channel2 |
    #b - b-f
      | started             | cast         | not yet         | started             | cast         | not yet         | channel2 then channel1 |
      | started             | cast         | not yet         | published           | not cast     | not yet         | channel2 then channel1 |
      | started             | cast         | not yet         | published_in_future | not cast     | not yet         | channel2 then channel1 |
      | started             | cast         | not yet         | started             | cast         | already         | channel2 then channel1 |
      | started             | cast         | not yet         | started             | not cast     | already         | channel2 then channel1 |
    #c - b-f
      | published           | not cast     | not yet         | started             | cast         | not yet         | channel2 then channel1 |
      | published           | not cast     | not yet         | published           | not cast     | not yet         | channel2 then channel1 |
      | published           | not cast     | not yet         | published_in_future | not cast     | not yet         | channel2 then channel1 |
      | published           | not cast     | not yet         | started             | cast         | already         | channel2 then channel1 |
      | published           | not cast     | not yet         | started             | not cast     | already         | channel2 then channel1 |
    #d - b-f
      | published_in_future | not cast     | not yet         | started             | cast         | not yet         | channel2 then channel1 |
      | published_in_future | not cast     | not yet         | published           | not cast     | not yet         | channel2 then channel1 |
      | published_in_future | not cast     | not yet         | published_in_future | not cast     | not yet         | channel2 then channel1 |
      | published_in_future | not cast     | not yet         | started             | cast         | already         | channel2 then channel1 |
      | published_in_future | not cast     | not yet         | started             | not cast     | already         | channel2 then channel1 |
    #e - b-f
      | started             | cast         | already         | started             | cast         | not yet         | channel2 then channel1 |
      | started             | cast         | already         | published           | not cast     | not yet         | channel2 then channel1 |
      | started             | cast         | already         | published_in_future | not cast     | not yet         | channel2 then channel1 |
      | started             | cast         | already         | started             | cast         | already         | channel2 then channel1 |
      | started             | cast         | already         | started             | not cast     | already         | channel2 then channel1 |
    #a - b-f
      | started             | not cast     | already         | started             | cast         | not yet         | channel2 then channel1 |
      | started             | not cast     | already         | published           | not cast     | not yet         | channel2 then channel1 |
      | started             | not cast     | already         | published_in_future | not cast     | not yet         | channel2 then channel1 |
      | started             | not cast     | already         | started             | cast         | already         | channel2 then channel1 |
      | started             | not cast     | already         | started             | not cast     | already         | channel2 then channel1 |
    #g - a
      | draft               | not cast     | not yet         | started             | not cast     | not yet         | channel2 then channel1 |


  Scenario Outline: There is user who is member of channel1 and channel2 and there are vortex.coms in channels
    Given I am any user
    And user created a private channel
    And user created a private <status1> vortex.com
    And I am invited to become participant of that vortex.com
    And I have <vote_status_1> my vote in the vortex.com
    And vortex.com has <finish_status_1> finished
    And user created a private channel
    And user changed my permissions to participant in channel
    When I request my channel feed
    Then channel feed contains <order>
    Examples:
      | status1             | vote_status_1 | finish_status_1 | order                  |
      | started             | not cast     | not yet         | channel1 then channel2 |
      | started             | cast         | not yet         | channel2 then channel1 |
      | published           | not cast     | not yet         | channel2 then channel1 |
      | published_in_future | not cast     | not yet         | channel2 then channel1 |
      | started             | cast         | already         | channel2 then channel1 |
      | started             | not cast     | already         | channel2 then channel1 |


  Scenario Outline: Private channel should appear in channel feed with IsPrivate=true
    Given I am any user
    And I created a <privacy> channel
    And I changed my permissions to participant in channel
    When I request my channel feed
    Then channel feed contains the channel
    And channel isPrivate property value equals <isPrivate_value>
    Examples:
      | privacy | isPrivate_value |
      | private | True            |
      | public  | False           |
