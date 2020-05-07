Feature: search
    @nopublicusergeneratedcontent # @suite2
Scenario: Changing pages with search results open resets search field
    Given I am authenticated user
    And I am on the home page
    When I search for something
    And I click on Explore button
    Then the search field is reset
