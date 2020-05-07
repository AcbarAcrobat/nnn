Feature: profile page

  Scenario Outline: User can save changes in profile page
    Given I am verified user
    And I am on the profile page
    When I edit the <field> field in my profile settings
    And I save changes
    And I go back to edit profile page
    Then updated value of profile field <field> is shown
    Examples:
      | field         |
      | name          |
      | bio           |
      | date of birth |
      | gender        |

  @bugstofix @profilephoto
  Scenario: User can change profile picture
    Given I am verified user
    And I am on the profile page
    When I click edit profile button
    And I save profile logo as image1
    And I upload image2 as profile logo
    And I save changes
    Then profile logo is updated

# todo: upload logo, delete logo, upload background, delete background
  @suite2
  Scenario Outline: User can set channel background image
    Given I am verified user
    And I am on the profile page
    When I click edit profile button
    And I upload profile <img_type> image
    And I save changes
    Then profile <img_type> is set
    Examples:
      | img_type   |
      | logo       |
      | background |