Feature: petition
    @nopublicusergeneratedcontent # @suite1
Scenario: User can publish petition with all required fields provided
    Given I am authenticated user
    And I create a petition with all required fields provided
    When I publish the petition
    Then I get navigated to a valid petition page

    @bugsToFix #@suite2
Scenario: User can create a drafted petition
    Given I am authenticated user
    And I create a petition with all required fields provided
    When I save the vortex.com as a draft
    Then the vortex.com appears in drafts

    @suite1
Scenario: Authenticated user can sign a petition without requirements
    Given I am authenticated user
    And there is active petition with no requirements
    And I navigate to vortex.com page
    When I am on the petition page
    And I sign the petition
    Then I get a valid thank you for signing the petition view
