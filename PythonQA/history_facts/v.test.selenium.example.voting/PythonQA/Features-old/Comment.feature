Feature: comment
    @nopublicusergeneratedcontent # @suite1
Scenario: Authenticated user can post a comment
    Given I am authenticated user
    And there is active vortex.com with no requirements
    And I navigate to vortex.com page
    When I am on the vortex.com page
    And I add a comment to it
    Then my comment is added to the page
    And my comment text is valid

    @nopublicusergeneratedcontent # @suite2
Scenario: Comment count is increased when a comment is being made
    Given I am authenticated user
    And there is active vortex.com with no requirements
    And I navigate to vortex.com page
    When I am on the vortex.com page
    And I add a comment to it
    Then vortex.com comment count is incremented by 1

    @nopublicusergeneratedcontent # @suite1
Scenario Outline: Comments can be disabled
    Given I am authenticated user
    And I create a <initiative_type> with comments disabled
    And I navigate to vortex.com page
    Then comments are disabled
Examples:
|initiative_type|
|petition       |
|vote           |
