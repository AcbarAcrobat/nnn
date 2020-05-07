# Created by Cmjk at 01.03.2017
Feature: invite user tickets
# logged in? no; orphan? yes; merge? no;
    @skip
Scenario Outline: New user can accept invites to channels and vortex.coms through tickets
    Given I am non-registered user
    And I am invited to become a member of a <privacy> <entity>
    When I activate invite user ticket
    And I fill out required fields in login form
    Then I am authorised on vortex.com
    And I am taken to the <entity>
Examples:
|privacy|entity|
|private|vortex.com|
|private|channel|


# logged in? yes; same account? no; orphan? yes;
Scenario Outline: New user can merge accounts through invite tickets
    Given I am non-registered user
    And I am invited to become a member of a <privacy> <entity>
    When another account is logged in
    And I activate invite user ticket
    And I choose merge into current account
    Then I am taken to the <entity>
    And accounts are merged
Examples:
|privacy|entity|
|private|vortex.com|
|private|channel|


    @skip
# logged in? no; orphan? no;
Scenario Outline: Non-verified user can accept invites to channels and vortex.coms through tickets
    Given I am non-verified user
    And I am invited to become a member of a <privacy> <entity>
    When I activate invite user ticket
    And I fill out required fields in login form
    Then I am authorised on vortex.com
    And I am taken to the <entity>
    And my email is verified
Examples:
|privacy|entity|
|private|vortex.com|
|private|channel|


# logged in? yes; same account? yes;
    @skip
Scenario Outline: Existing user can accept invites into channels and vortex.coms through tickets
    Given I am non-verified user
    And I am invited to become a member of a <privacy> <entity>
    When I login with valid credentials
    And I activate invite user ticket
    Then I am taken to the <entity>
    And my email is verified
Examples:
|privacy|entity|
|private|channel|
|private|vortex.com|

# logged in? yes; same account? no;
    @skip
Scenario Outline: Existing user can accept invites into channels and vortex.coms through tickets, another account is logged in
    Given I am non-verified user
    And I am invited to become a member of a <privacy> <entity>
    When another account is logged in
    And I activate invite user ticket
    And I choose ticket account
    And I fill out required fields in login form
    Then I am taken to the <entity>
    And my email is verified
Examples:
|privacy|entity|
|private|vortex.com|
|private|channel|


    @suite2
Scenario: Invalid tickets are handled properly
    Given I am any user
    When I navigate to an invalid ticket link
    Then I am taken to invalid ticket view

# logged in? yes; verified? yes;
    @skip
Scenario Outline: Existing verified user can accept invites into channels and vortex.coms through tickets
    Given I am verified user
    And I am invited to become a member of a <privacy> <entity>
    When I activate invite user ticket
    Then I am taken to the <entity>
Examples:
|privacy|entity|
|private|vortex.com|
|private|channel|

# logged in? no; verified? yes;
  @skip @3.1
Scenario Outline: Existing verified user can accept invites into channels and vortex.coms through tickets, not logged in
    Given I am any user
    And I am invited to become a member of a <privacy> <entity>
    When I activate invite user ticket
    And I fill out required fields in login form
    Then I am taken to the <entity>
Examples:
|privacy|entity|
|private|vortex.com|
|private|channel|


# logged in? yes; same account? yes;
    @skip @2.2
Scenario Outline: Existing user can accept invites into channels and vortex.coms through tickets, logged in, same account
    Given I am non-verified user
    And I am invited to become a member of a <privacy> <entity>
    When I login with valid credentials
    And I activate invite user ticket
    Then I am taken to the <entity>
    And my email is verified
Examples:
|privacy|entity|
|private|channel|
|private|vortex.com|

# logged in? yes; same account? no;
    @skip @2.3
Scenario Outline: Existing user can accept invites into channels and vortex.coms through tickets, logged in, different account
    Given I am non-verified user
    And I am invited to become a member of a <privacy> <entity>
    When another account is logged in
    And I activate invite user ticket
    And I choose ticket account
    And I fill out required fields in login form
    Then I am taken to the <entity>
    And my email is verified
Examples:
|privacy|entity|
|private|vortex.com|
|private|channel|

# logged in? yes; same account? no; orphan? yes;
    @skip @1.2
Scenario Outline: New user can merge accounts through invite tickets
    Given I am non-registered user
    And I am invited to become a member of a <privacy> <entity>
    When another account is logged in
    And I activate invite user ticket
    And I choose merge into current account
    Then I am taken to the <entity>
    And accounts are merged
Examples:
|privacy|entity|
|private|vortex.com|
|private|channel|
