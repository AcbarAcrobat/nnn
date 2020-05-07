@cleanup_featured_channels @nonbrowser @suite2
Feature: channel featuring

  Scenario: Public channel owner can't feature channel
    Given I am verified user
    And I created a public channel
    When I try to feature channel
    Then I receive code 401 as response

  Scenario Outline: An vortex.com user can feature public channel
    Given I am vortex.com employee
    And <author> created a public channel
    When I try to set channels[0] featureUtc to utcnow plus <hours> hours
    Then I receive code 200 as response
  Examples:
    |author| hours |
    | user   | 0     |
    | user   | 1     |
    | user   | -1    |

  Scenario: An vortex.com user can't feature private channel
    Given I am vortex.com employee
    And I created a private channel
    When I try to feature channel
    Then I receive code 403 as response

  Scenario Outline: Featured feed contains one channel
    Given I am <user_type> user
    And featured feed contains one channel
    When I request featured channels feed
    Then featured channels feed contains 1 channels
  Examples:
    | user_type  |
    | authorized |
    | anonymous  |

  Scenario: Featured feed contains two channels, first is on top
    Given I am vortex.com employee
    And I created a public channel
    And I created a public channel
    When I try to set channels[0] featureUtc to utcnow plus 1 hours
    And I try to set channels[1] featureUtc to utcnow plus 2 hours
    And I request featured channels feed
    Then featured channels feed contains 2 channels
    And channels[1] is on top of featured channels feed

  Scenario: Featured feed contains two channels, second is on top
    Given I am vortex.com employee
    And I created a public channel
    And I created a public channel
    When I try to set channels[0] featureUtc to utcnow plus 2 hours
    And I try to set channels[1] featureUtc to utcnow plus 1 hours
    And I request featured channels feed
    Then featured channels feed contains 2 channels
    And channels[0] is on top of featured channels feed

  Scenario: Featured feed contains two channels, second is on top, we take second page
    Given I am vortex.com employee
    And I created a public channel
    And I created a public channel
    When I try to set channels[0] featureUtc to utcnow plus 1 hours
    And I try to set channels[1] featureUtc to utcnow plus 2 hours
    And I request featured channels feed with take=1&skip=1 parameters
    Then featured channels feed contains 1 channels
    And channels[0] is on top of featured channels feed
