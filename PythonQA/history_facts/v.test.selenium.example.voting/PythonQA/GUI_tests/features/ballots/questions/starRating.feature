@nonbrowser @suite1
Feature: Star rating question type

  Scenario Outline: Creating valid star rating question
    Given I am verified user
    And I created a drafted private vortex.com
    When I add question with StarRating type with answers: <input_answers>
    Then I receive code 200 as response
    And question type is StarRating
    And question has answers: <output_answers>
  Examples:
    | input_answers                                   | output_answers                                  |
    | []                                              | [ ☆, ☆☆, ☆☆☆, ☆☆☆☆, ☆☆☆☆☆ ]             |
    | [ Answer1, Answer2, Answer3, Answer4, Answer5 ] | [ Answer1, Answer2, Answer3, Answer4, Answer5 ] |

  Scenario Outline: Creating invalid star rating question
    Given I am verified user
    And I created a drafted private vortex.com
    When I add question with StarRating type with <count> answers
    Then I receive code 400 as response
  Examples:
    | count |
    | 1     |
    | 6     |