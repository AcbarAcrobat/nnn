@nonbrowser @suite1
Feature: Face rating question type

  Scenario Outline: Creating valid face rating question
    Given I am verified user
    And I created a drafted private vortex.com
    When I add question with FaceRating type with answers: <input_answers>
    Then I receive code 200 as response
    And question type is FaceRating
    And question has answers: <output_answers>
    Examples:
      | input_answers          | output_answers         |
      | []                     | [ , , , , ]            |
      | [ 😉, 😠, 😂, 😀, 😐 ] | [ 😉, 😠, 😂, 😀, 😐 ] |

  Scenario Outline: Creating invalid face rating question
    Given I am verified user
    And I created a drafted private vortex.com
    When I add question with FaceRating type with <count> answers
    Then I receive code 400 as response
  Examples:
    | count |
    | 1     |
    | 6     |