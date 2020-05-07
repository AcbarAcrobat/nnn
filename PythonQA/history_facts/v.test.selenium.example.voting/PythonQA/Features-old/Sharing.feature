Feature: initiative sharing
    @nopublicusergeneratedcontent # @unstable
Scenario: facebook user can share initiatives on his timeline
    Given I am a test user of vortex.work on facebook
    And I am authorised on facebook
    When I navigate to the explore page
    And I share a vortex.com on facebook
    Then the vortex.com is shared on my timeline
