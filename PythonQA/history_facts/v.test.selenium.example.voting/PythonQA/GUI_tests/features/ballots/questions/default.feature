@nonbrowser @suite2
Feature: Default question type

  Scenario Outline: Default question type is Text.
    Given I am verified user
    And I created a drafted private vortex.com
    When I add question with <input_type> type
    Then question type is <output_type>
  Examples:
    | input_type | output_type |
    | unset      | Text        |
    | default    | Text        |
    | Text       | Text        |

  Scenario Outline: Default question optional field is true.
    Given I am verified user
    And I created a drafted public vortex.com
    When I add question with <input_optional> isoptional
    Then question optional is <output_optional>
  Examples:
    | input_optional | output_optional |
    | unset          | True            |
    | True           | True            |
    | False          | False           |