@nonbrowser @suite1
Feature: YesNo question type

  Scenario Outline: Creating valid yes-no question
    Given I am verified user
    And I created a drafted private vortex.com
    When I add question with YesNo type with answers: <input_answers>
    Then I receive code 200 as response
    And question type is YesNo
    And question has answers: <output_answers>
  Examples:
    | input_answers                              | output_answers                             |
    | []                                         | [ Yes, No ]                                |
    | [ Yes, No ]                                | [ Yes, No ]                                |
    | [ Some answer text 1, Some answer text 2 ] | [ Some answer text 1, Some answer text 2 ] |

  Scenario Outline: Creating invalid yes-no question
    Given I am verified user
    And I created a drafted private vortex.com
    When I add question with YesNo type with <count> answers
    Then I receive code 400 as response
  Examples:
    | count |
    | 1     |
    | 3     |