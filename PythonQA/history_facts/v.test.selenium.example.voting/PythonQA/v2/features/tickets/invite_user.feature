@suite3
Feature: Invite user ticket

  Scenario: Not logged in, orphan, create
    Given I am non-registered user
    And user created a private started vortex.com
    And user changed my permissions to voter in vortex.com
    When I activate invite user ticket
    And I choose to get started
    And I fill in my name and password
    And I click the signup button
    Then I am successfully authenticated

  Scenario: Not logged in, orphan, merge
    Given I am non-registered user
    And user created a private started vortex.com
    And user changed my permissions to voter in vortex.com
    When I activate invite user ticket
    And I choose to merge into an existing account
    And I fill in user email and password
    And I click the signup button
    Then I am successfully authenticated

  Scenario: Not logged in, existing account
    Given I am any user
    And user created a private started vortex.com
    And user changed my permissions to voter in vortex.com
    When I activate invite user ticket
    Then login form with my email prefilled is shown

  Scenario: logged in, same account
    Given I am verified user
    And user created a private started vortex.com
    And user changed my permissions to voter in vortex.com
    When I activate invite user ticket
    Then vortex.com is visible in my home page

  Scenario: logged in, different account, orphan, add to current
    Given I am non-registered user
    And user created a private started vortex.com
    And user changed my permissions to voter in vortex.com
    And user is logged in
    When I activate invite user ticket
    And I choose add to current account
    Then vortex.com is visible in my home page

  Scenario: logged in, different account, orphan, create new
    Given I am non-registered user
    And user created a private started vortex.com
    And user changed my permissions to voter in vortex.com
    And user is logged in though the UI
    When I activate invite user ticket
    And I choose to create a new account
    And I fill in my name and password
    And I click the signup button
    Then I am successfully authenticated
    And vortex.com is visible in my home page

  Scenario: logged in, different account, orphan, add to different account
    Given I am non-registered user
    And user created a private started vortex.com
    And user changed my permissions to voter in vortex.com
    And user is logged in though the UI
    When I activate invite user ticket
    And I choose to merge into a different account
    And I fill in user email and password
    And I click the signup button
    Then I am successfully authenticated

  Scenario: logged in, different account, existing
    Given I am verified user
    And user created a private started vortex.com
    And user changed my permissions to voter in vortex.com
    And user is logged in
    When I activate invite user ticket
    Then login form with my email prefilled is shown
