Feature: tracking picture
    @suite1 @nonbrowser
Scenario Outline: New user can accept invites to channels and vortex.coms through tickets
    Given I am non-registered user
    And I am invited to become a member of a private <entity>
    When I access invite user ticket
    Then ticket contains valid url and fields
    And ticket contains channel info
    And ticket contains link to <entity>
Examples:
|entity|
|channel|
|vortex.com |

    @suite2 @nonbrowser
Scenario: Verify email
    Given I am non-verified user
    When I access verify email ticket
    Then email subject is One more step!
    And ticket contains valid url and fields

    @suite2 @nonbrowser
Scenario: Forgot password
    Given I am any user
    And I have requested password reset
    When I access forgot password ticket
    Then email subject is Reset vortex.com password.
    And ticket contains valid url and fields


    @suite2 @nonbrowser # todo: enable when weird symbol in subject fixed
Scenario Outline: change permission in vortex.com
    Given I am any user
    And I created a public drafted vortex.com
    And I invited <user_type> user to become participant in my vortex.com
    When I add editDraft right to user
    And user access <ticket_type> ticket
    Then email subject contains <subject>
    And ticket contains valid url and fields
    And ticket contains channel info
    And ticket contains link to vortex.com
Examples:
    | user_type | ticket_type       | subject                          |
    | another   | change permission | You’re now a participant.        |
    | orphaned  | invite user       | You’ve been invited to vote.     |


    @suite1 @nonbrowser
Scenario: Open email shall add to ticketMailState state Opened
    Given I am non-registered user
    And I am invited to become a member of a private vortex.com
    When I access invite user ticket
    And I load tracking pixel url
    Then email subject contains You’ve been invited to vote.
    And ticket openedUtc value is not null

    @suite2
Scenario: Open link from email shall add to ticketMailState state Clicked
    Given I am non-registered user
    And I am invited to become a member of a private vortex.com
    When I access invite user ticket
    And I activate invite user ticket
    Then email subject is You’ve been invited to vote.
    And ticket clickedUtc value is not null

    @suite1 @nonbrowser
Scenario: Response to request for ticket details shall retun filled clickedUtc field
    Given I am non-verified user
    When I access verify email ticket
    Then ticket clickedUtc value is not null
