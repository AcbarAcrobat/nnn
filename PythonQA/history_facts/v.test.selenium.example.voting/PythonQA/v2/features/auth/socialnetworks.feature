# Created by Cmjk at 24.02.2017
@https @suite3
Feature: social networks login

@skip
  Scenario: Facebook login page is accessible from Sign Up form
    Given I am any user
    When I open the Sign up form
    And I click the facebook link
    Then I get the Facebook login page

@skip
  Scenario: User can login through facebook dialogue
    Given I am a test user of vortex.work on facebook
    And I am authorised on facebook
    When I open the Sign up form
    And I click the facebook link
    Then I am successfully authenticated

  Scenario: Google login page is accessible from Sign Up form
    Given I am any user
    When I open the Sign Up form
    And I click the google link
    Then I get the Google login page

  Scenario: Google login for existing google user
    Given I am a test user of vortex.work on googleplus
    When I open the Sign up form
    And I click the google link
    And I authorise on googleplus
    Then I am successfully authenticated

  Scenario: LinkedIn login page is accessible from Sign Up form
    Given I am any user
    When I open the Sign Up form
    And I click the linkedin link
    Then I get the LinkedIn login page

  Scenario: LinkedIn login for existing linkedin user
    Given I am a test user of vortex.work on linkedin
    When I open the Sign up form
    And I click the linkedin link
    And I authorise on linkedin
    Then I am successfully authenticated
