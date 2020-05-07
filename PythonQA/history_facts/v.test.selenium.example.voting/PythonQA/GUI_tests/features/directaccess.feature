Feature: direct access
  @suite1
  Scenario: Anonymous user can access backend api page directly
    Given I am anonymous user
    When I access the backend api page
    Then I receive data from backend
