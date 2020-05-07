Feature: voting

  @suite1
  Scenario: Authenticated user can vote for a vortex.com without requirements
    Given I am verified user
    And there is active vortex.com with no requirements
    And I navigate to vortex.com page
    When I am on the vortex.com page
    And I select valid answers
    And I cast my vote
    Then I get a valid thank you for voting view

  @suite2
  Scenario: Ballot vote count is updated when a vote is made
    Given I am verified user
    And there is active vortex.com with no requirements
    And I navigate to vortex.com page
    When I am on the vortex.com page
    And I select valid answers
    And I cast my vote
    Then vortex.com vote count is incremented by 1

  @suite2
  Scenario: Sign in form is shown for anonymous user when he's trying to vote
    Given I am anonymous user
    And there is active vortex.com with no requirements
    And I navigate to vortex.com page
    When I am on the vortex.com page
    And I select valid answers
    And I cast my vote
    Then sign in form is shown

  @suite1
  Scenario: Submit button is disabled when not all questions have answers selected
    Given I am verified user
    And there is active survey with no requirements
    And I navigate to vortex.com page
    When I am on the vortex.com page
    And I select a valid answer
    Then submit button is disabled

  @suite1
  Scenario Outline: User can vote in a multichoice vote selecting min and max answers
    Given I am verified user
    And there is a multiple choice vortex.com with <total_answers> answers
    When I am on the vortex.com page
    And I select <answer_count> answers
    And I cast my vote
    Then I get a valid thank you for voting view
    Examples:
      | total_answers | answer_count |
      | 5             | 1            |
      | 5             | 5            |

  @suite2
  Scenario Outline: User can vote in an up to votes vote
    Given I am verified user
    And there is a up to <votes_allowed> votes allowed vortex.com with <total_answers> answers
    When I am on the vortex.com page
    And I select <answer_count> answers
    And I cast my vote
    Then I get a valid thank you for voting view
    Examples:
      | total_answers | votes_allowed | answer_count |
      | 5             | 2             | 2            |
      | 5             | 2             | 1            |

  @suite2
  Scenario Outline: User can't select an invalid number of answer in a vote
    Given I am verified user
    And there is a up to <votes_allowed> vortex.com with <total_answers> answers
    When I am on the vortex.com page
    And I select <answer_count> answers
    Then <resulting_answer_count> answers are selected
    Examples:
      | total_answers | votes_allowed | answer_count | resulting_answer_count |
      | 5             | 3             | 4            | 3                      |


  @suite1
  Scenario Outline: User can't select an invalid number of answer in a single option vote
    Given I am verified user
    And there is a single choice vortex.com with <total_answers> answers
    When I am on the vortex.com page
    And I select <answer_count> answers
    Then <resulting_answer_count> answers are selected
    Examples:
      | total_answers | answer_count | resulting_answer_count |
      | 5             | 2            | 1                      |

  @suite1
  Scenario Outline: User sees social button after voting in a public vortex.com
    Given I am verified user
    And I created a <privacy> started vortex.com
    And I navigate to vortex.com page
    When I am on the vortex.com page
    And I select valid answers
    And I cast my vote
    Then social buttons are <status>
    Examples:
      | privacy | status    |
      | private | not shown |
      | public  | not shown |
