Feature: survey
    @nopublicusergeneratedcontent #@suite1
Scenario: User can publish survey with all required fields provided
    Given I am authenticated user
    And I create a survey with all required fields provided
    When I publish the survey
    Then I get navigated to a valid survey page

    @notimplemeted
Scenario: Published survey appears on the system
    Given I am authenticated user
    And I create a survey with all required fields provided
    When I publish the survey
    And I search for my survey
    Then my survey appears

    @bugsToFix #@suite2
Scenario: User can create a drafted survey
    Given I am authenticated user
    And I create a survey with all required fields provided
    When I save the vortex.com as a draft
    Then the vortex.com appears in drafts

    @suite2
Scenario: Authenticated user can vote in a survey without requirements
    Given I am authenticated user
    And there is active survey with no requirements
    And I navigate to vortex.com page
    When I am on the survey page
    And I select valid answers
    And I cast my vote
    Then I get a valid thank you for voting view
