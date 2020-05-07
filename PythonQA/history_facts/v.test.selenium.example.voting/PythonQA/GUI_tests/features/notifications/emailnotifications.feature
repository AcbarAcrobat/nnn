Feature: email notifications
    @suite1
Scenario: emails are not sent to participants in a private vortex.com draft
    Given I am verified user
    And I created a private drafted vortex.com
    And I navigate to draft page
    When I invite a user to be participant in my vortex.com
    Then vortex.com started notification is not sent to vortex.com owner
    And vortex.com started notification is not sent to vortex.com invitee

    @blocked # todo: run SeS for this
Scenario Outline: emails are sent to owner and participants when private vortex.com is published
    Given I am verified user
    And I created a private drafted vortex.com
    And I invited another user to become <role> in my vortex.com
    And I navigate to draft page
    When I publish the draft
    Then vortex.com started notification is sent to vortex.com invitee
    And vortex.com started notification is sent to vortex.com owner
Examples:
|role|
|editor|
|participant|

    @suite1 @nonbrowser
Scenario: emails are not sent to owner and participants in a private vortex.com draft
    Given I am any user
    And I created a private drafted vortex.com
    And I invited another user to become participant in my vortex.com
    Then vortex.com started notification is not sent to vortex.com invitee
    And vortex.com started notification is not sent to vortex.com owner

    @suite2
Scenario Outline: email is sent to user on permission change
    Given I am verified user
    And I created a private channel
    And I invited another user to become <role> in my channel
    When I am on the channel page
    And I change user channel role to <role2>
    Then change permission notification is sent to vortex.com invitee
Examples:
|role|role2|
|administrator|participant|
|participant|administrator|

    @suite2
Scenario: email is sent to editor on editor removal from vortex.com
    Given I am verified user
    And I created a private started vortex.com
    And I invited another user to become editor in my vortex.com
    When I remove user from vortex.com
    Then remove role notification is sent to vortex.com invitee

    @suite2
Scenario: email not sent when draft is deleted
    Given I am verified user
    And I created a private drafted vortex.com
    And I navigate to draft page
    When I delete the draft
    Then email is not sent to vortex.com owner

    @suite2 @nonbrowser
Scenario: email is sent to editor when editor loses editDraft right in draft
    Given I am any user
    And I created a private drafted vortex.com
    And I invited another user to become editor in my vortex.com
    When I remove editDraft right from user
    Then remove role notification is sent to vortex.com invitee

    @suite2 @nonbrowser
Scenario: email is sent to editor when participant receives editDraft right in draft
    Given I am any user
    And I created a private drafted vortex.com
    And I invited another user to become participant in my vortex.com
    When I add editDraft right to user
    Then change permission notification is sent to vortex.com invitee

    @suite2 @nonbrowser
Scenario: remove from editor any right except editDraft
    Given I am any user
    And I created a private drafted vortex.com
    And I invited another user to become editor in my vortex.com
    When I remove publish right from user
    Then change permission notification is not sent to vortex.com invitee
