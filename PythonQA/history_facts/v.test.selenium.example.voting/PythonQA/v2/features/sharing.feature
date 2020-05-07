# Created by Cmjk at 05.06.2017
Feature: sharing
  # vortex.coms can be shared through email and social media outlets

  Scenario: Facebook sharing
    Given I am verified user
    And I created a public started vortex.com
    And I navigate to vortex.com page
    And I am a test user of vortex.work on facebook
    When I share vortex.com to facebook
    And I authorise on facebook
    Then I am taken to a valid share vortex.com page

  Scenario: user can request vortex.com directly
    Given I am verified user
    And I created a private started vortex.com
    And I uploaded a cover image to vortex.com
    When I request vortex.com directly
    Then vortex.com is rendered
