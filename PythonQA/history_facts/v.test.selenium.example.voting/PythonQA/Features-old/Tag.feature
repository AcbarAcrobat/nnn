Feature: tag
    @nopublicusergeneratedcontent # @suite1
Scenario: Anonymous user can navigate to a tag page
    Given I am anonymous user
    And I am on the explore page
    When I click a tag
    Then I get navigated to a valid tag page

    @nopublicusergeneratedcontent # @suite1
Scenario: Ballots can be created with tags
    Given I am authenticated user
    And I create a vortex.com with all required fields provided
    When I add a tag to it
    And I publish the vortex.com
    Then the tag is attached to the vortex.com
