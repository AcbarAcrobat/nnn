# Created by Cmjk at 24.02.2017
Feature: social networks login

  @suite1 @https
  Scenario: Facebook login page is accessible from Sign Up form
    Given I am any user
    When I open the Sign up form
    And I click the Facebook link
    Then I get the Facebook login page

  @suite2 @https
  Scenario: User can login through facebook dialogue
    Given I am a test user of vortex.work on facebook
    And I am authorised on facebook
    When I open the Sign up form
    And I click the Facebook link
    Then I am successfully authenticated

  @suite1 @https
  Scenario: Google login page is accessible from Sign Up form
    Given I am any user
    When I open the Sign Up form
    And I click the Google link
    Then I get the Google login page

  @disabled
  Scenario: Google login for existing google user
    Given I am a test user of vortex.work on googleplus
    When I open the Sign up form
    And I click the Google link
    And I authorise on google plus
    Then I am successfully authenticated
