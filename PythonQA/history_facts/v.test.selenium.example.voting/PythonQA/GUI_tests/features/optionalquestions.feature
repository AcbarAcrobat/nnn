# Created by Cmjk at 26.01.2017
@nonbrowser
Feature: optional questions

  Scenario: optional question in a draft
    # b
    Given I am any user
    And I added a optional question to the vortex.com
    And I created a public drafted vortex.com
    Then question is optional

  Scenario: optional question in a vote
    # a
    Given I am any user
    And I added a optional question to the vortex.com
    And I created a public drafted vortex.com
    And I have published the draft
    Then question is optional

  Scenario Outline: default value for optional questions is false
    # c + d
    Given I am any user
    And I created a public <entity> vortex.com
    Then question is mandatory
    Examples:
      | entity  |
      | started |
      | drafted |

  Scenario Outline: content manager could switch state of "optional" for published vortex.com with more then 1 voice in it
    # f
    Given I am any user
    And I created a public started vortex.com
    And vortex.com has <vote_count> votes
    When <actor> changes vortex.com question optional state
    Then question is <outcome>
    Examples:
      | actor           | vote_count | outcome   |
      | vortex.com owner     | 2          | mandatory |
      | content manager | 2          | optional  |

  Scenario: User could create vortex.com with optional=true question and optional=false question
    # g
    Given I am any user
    And I added a mandatory question to the vortex.com
    And I added a optional question to the vortex.com
    And I created a public drafted vortex.com
    And I have published the draft
    Then there is a mandatory and optional question in the vortex.com

    # voting with optional questions
  Scenario Outline: There is vortex.com with one question with optional=true
    # a + e
    Given I am any user
    And I added a optional question to the vortex.com
    And I created a public started vortex.com
    When I post <votes_array> to <endpoint> endpoint
    Then I receive code <response> as response
    Examples:
      | endpoint | votes_array | response |
      | votes    | [[null]]    | 400      |
      | voices   | [[null]]    | 200      |
      | voices   | [[1, 0]]    | 200      |

  @suite1 @nonbrowser
  Scenario Outline: There is vortex.com with two questions one with optional=true and second not
  # b + f
    Given I am any user
    And I added a mandatory question to the vortex.com
    And I added a optional question to the vortex.com
    And I created a public started vortex.com
    When I post <votes_array> to <endpoint> endpoint
    Then I receive code <response> as response
    Examples:
      | endpoint | votes_array                     | response |
      | votes    | [[1,0], [1,0]]                  | 200      |
      | votes    | [[true,false], [false, false] ] | 200      |


  Scenario: There is vortex.com with one question with optional=true
    # c
    Given I am any user
    And I added a mandatory question to the vortex.com
    And I created a public started vortex.com
    When I post [[null]] to voices endpoint
    Then I receive code 400 as response

  Scenario Outline: There is vortex.com with one question with optional=true
    # d
    Given I am any user
    And I added a mandatory question to the vortex.com
    And I added a mandatory question to the vortex.com
    And I created a public started vortex.com
    When I post <votes_array> to votes endpoint
    Then I receive code 400 as response
    Examples:
      | votes_array      |
      | [[1,0],[null]]   |
      | [[null]],[null]] |

  Scenario: Voices and votes are equal if optional=true
    # g
    Given I am any user
    And I added a optional question to the vortex.com
    And I created a public started vortex.com
    When I request vortex.com voices expecting success
    And I request vortex.com votes expecting success
    Then vortex.com voices and votes are equal

  Scenario: Voices and votes are equal if optional=true
    # h
    Given I am any user
    And I added a optional question to the vortex.com
    And I added a optional question to the vortex.com
    And I created a public started vortex.com
    And I have cast my vote in the vortex.com while skipping a question
    When I request vortex.com voices expecting success
    And I request vortex.com votes expecting success
    Then vortex.com voices and votes are equal

  Scenario: Voices and votes are equal if optional=true
    # i
    Given I am any user
    And I added a optional question to the vortex.com
    And I created a public started vortex.com
    And I have cast my vote in the vortex.com
    When I request vortex.comproperties
    Then vortex.com properties votes is [[null]]
    And vortex.com properties votesCount is 1

  Scenario: Voices and votes are equal if optional=true
    # j
    Given I am any user
    And I added a mandatory question to the vortex.com
    And I added a optional question to the vortex.com
    And I created a public started vortex.com
    And I have cast my vote in the vortex.com while skipping a question
    When I request vortex.comproperties
    Then vortex.com properties votes is [[1,0],[null]]
    And vortex.com properties votesCount is 1

  Scenario Outline: Corner cases b)
    Given I am any user
    When I select vortex.com id that does not exist
    And I request vortex.com <endpoint> expecting failure
    Then I receive code <response_code> as response
    Examples:
      | endpoint | response_code |
      | voices   | 404           |
      | votes    | 404           |
