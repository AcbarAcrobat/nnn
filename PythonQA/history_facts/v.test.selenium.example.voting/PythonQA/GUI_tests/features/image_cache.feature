Feature: image caching
    @suite2 @nonbrowser
Scenario: Image headers cache-control is set
    Given I am any user
    When I request a hedgehog user 2147552113 directly
    And I request user photo
    Then I receive code 200 as response
    And image response header is not set to no-cache
