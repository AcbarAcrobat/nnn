# Created by Cmjk at 04.01.2017
Feature: dashboard
  @disabled
  Scenario Outline: Channel Dashboard button is available for roles on channel page
    Given I am authenticated user
    And I created a public channel
    And I changed my permissions to participant in channel
    When I am on the channel page
    Then <button> button is not visible
Examples:
|button|
|channel_dashboard|

  @bugsToFix #@disabled
  Scenario Outline: dashboard buttons take the user to the dashboard of the appropriate channel
    Given I am authenticated user
    And I created a <privacy> channel
    And I changed my permissions to <role> in channel
    When I am on the channel page
    When I click <button> button
    Then I am taken to a valid dashboard page
Examples:
|role|privacy|button|
|owner|public |channel dashboard|
|owner|private|channel dashboard|
|administrator|public |channel dashboard|
|administrator|private|channel dashboard|


  @disabled
  Scenario Outline: channel privacy and my role are listed in dashboard
    Given I am authenticated user
    And I created a <privacy> channel
    And I am on channel dashboard page
    Then channel privacy is shown as <privacy>
    And channel role is shown as owner
Examples:
|privacy|
|public |
|private|

  Scenario Outline: vortex.coms show up in dashboard
    Given I am authenticated user
    And I created a <privacy> channel
    And I created a public started vortex.com
    And I am on channel dashboard page
    When I click the vortex.com
    Then I am taken to a valid vortex.com edit page
    Then vortex.com is visible on the dashboard page
Examples:
  | privacy |
  | public  |
  | private |

  @disabled
  Scenario: Navigation buttons work with vortex.coms present on the page
    Given I am authenticated user
    And I created a private channel
    And I created a private started vortex.com
    And I am on channel dashboard page
    When I open add participants form
    Then I am taken to a valid add participants page


  @unstable
  Scenario Outline: User can switch dashboard channels using dropdown menu
    Given I am authenticated user
    And I created a <privacy1> channel
    And I created a <privacy2> channel
    And I am on channel dashboard page
    When I switch channels using dropdown menu
    Then dashboard channel is switched
Examples:
|privacy1|privacy2|
|public  |public  |
|private |public  |
|public  |private |
|private |private |

  @disabled
  Scenario Outline: User can add participants through the dashboard
    Given I am authenticated user
    And I created a <privacy> channel
    And I am on channel dashboard page
    When I add a user as <role>
    Then user is added to the channel
    And user is listed as <role>
    And user count is 2
Examples:
|privacy|role|
|public|owner|
|public|administrator|
|public|participant|
|private|owner|
|private|administrator|
|private|participant|

  @disabled
  Scenario: Add participants form generates new lines when necessary
    Given I am authenticated user
    And I created a private channel
    And I have opened add participants form
    When I click the email input field
    Then another line as added to the form
    And delete line button appears

  @disabled
  Scenario: delete line button
    Given I am authenticated user
    And I created a private channel
    And I have opened add participants form
    When I click the email input field
    And I delete a line
    Then a line is deleted

  @disabled
  Scenario: add participants form can be closed
    Given I am authenticated user
    And I created a private channel
    And I have opened add participants form
    When I close add participants form
    Then add participants form is closed

  @disabled
  Scenario: all users can be selected using select all checkbox
    Given I am authenticated user
    And I created a private channel
    And I invited another user to become participant in my channel
    And I am on user management dashboard page
    When I click select all users button
    Then 2 users are selected

  @disabled
  Scenario: users can be removed from the channel using delete button
    Given I am authenticated user
    And I created a private channel
    And I invited another user to become participant in my channel
    And I am on user management dashboard page
    When I select invited user
    And delete user from channel
    Then user is deleted

  @disabled
  Scenario Outline: user role can be changed through the dashboard
    Given I am authenticated user
    And I created a private channel
    And I invited another user to become participant in my channel
    And I am on user management dashboard page
    When I change user dashboard role to <role>
    Then selected user is listed as <role>
Examples:
|role|
|administrator|
|owner        |
