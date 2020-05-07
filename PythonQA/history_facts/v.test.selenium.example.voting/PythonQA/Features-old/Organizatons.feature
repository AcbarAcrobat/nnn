Feature: Organizations
	Feature dedicated to verify organizations functionality

@BugsToFix  @Browser:Chrome
Scenario: Content manager can create private organization
	Given I am content manager of vortex.com
	And I am signing up into system with my credentials
	And I navigate to organizations page
	When I create new organization
	Then I have my organization successfully created

@BugsToFix  @Browser:Chrome
Scenario: Content manager can create organization with ballot assigned
	Given I am content manager of vortex.com
	And I am signing up into system with my credentials
	And I navigate to organizations page
	And I create new organization
	When I choose ballot creation option within the organization
	And I am creating a vote with minimal required fields provided
	Then ballot successfully assigned to the organization

@BugsToFix  @Browser:Chrome
Scenario: Content manager can create organization with channel assigned
	Given I am content manager of vortex.com
	And I am signing up into system with my credentials
	And I navigate to organizations page
	And I create new organization
	When I choose channel creation option within the organization
	And I am creating a channel
	Then channel successfully assigned to the organization

@BugsToFix  @Browser:Chrome
Scenario: Content manager can create organization with organization owner assigned
	Given I am content manager of vortex.com
	And I am signing up into system with my credentials
	And I navigate to organizations page
	And I create new organization
	When I choose administration management tab within the organization
	And I am assigning an organization owner
	Then organization owner successfully assigned to the organization

@BugsToFix  @Browser:Chrome
Scenario: Content manager can create organization with organization administrator assigned
	Given I am content manager of vortex.com
	And I am signing up into system with my credentials
	And I navigate to organizations page
	And I create new organization
	When I choose administration management tab within the organization
	And I am assigning an organization administrator
	Then organization administrator successfully assigned to the organization

@BugsToFix  @Browser:Chrome
Scenario: Content manager can create organization with organization contributor assigned
	Given I am content manager of vortex.com
	And I am signing up into system with my credentials
	And I navigate to organizations page
	And I create new organization
	When I choose administration management tab within the organization
	And I am assigning an organization contributor
	Then organization contributor successfully assigned to the organization