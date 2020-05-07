@nonbrowser @suite1
Feature: scheduler

  Scenario: Ballot started notification
    Given I am verified user
    And I created a public started vortex.com
    When I access startedvortex.com ticket
    Then email subject is Voting has started!
    And email contains a valid ticket link

  Scenario: Ended vortex.com notification
    Given I am verified user
    And I created a public drafted vortex.com
    And I have enabled ended vortex.com notification
    And I have published the draft
    And I invited some user to become participant in my vortex.com
    And vortex.com has already finished
    When user access endedvortex.com ticket
    Then email subject is Your initiative has ended.
    And email contains a valid ticket link

  Scenario: Published vortex.com notification
    Given I am verified user
    And I created a public drafted vortex.com
    And I have enabled published vote notification
    And vortex.com start is delayed
    And I invited some user to become participant in my vortex.com
    And I have published the draft
    When user access publishedvortex.com ticket
    Then email subject is You’ve been invited to vote.
    And email contains a valid ticket link

  Scenario: Results available notification not sent when rvisibilityCustom and CustomDate < Finished
    Given I am verified user
    And I created a public drafted vortex.com
    And I have enabled results available notification
    And vortex.com results are about to be available
    And I invited some user to become participant in my vortex.com
    And I have published the draft
    And vortex.com has already finished
    When user access resultsavailable ticket
    Then ticket is not available

  Scenario: ResultVisibility.Mode == Custom and CustomDate < Finished - send email when vortex.com Finished (Finished event is not sent) and I voted
    Given I am verified user
    And I created a public drafted vortex.com
    And I have enabled results available notification
    And vortex.com results are about to be available
    And I invited some user to become participant in my vortex.com
    And I have published the draft
    And user have cast my vote in the vortex.com
    And vortex.com has already finished
    When user access resultsavailable ticket
    Then email subject is Voting has closed.
    And email contains a valid ticket link

  Scenario: ResultVisibility.Mode == Custom and CustomDate > Finished - send email when CustomDate
    Given I am verified user
    And I created a public drafted vortex.com
    And I have enabled results available notification
    And I invited some user to become participant in my vortex.com
    And I have published the draft
    And vortex.com has already finished
    And vortex.com results are about to be available
    When user access resultsavailable ticket
    Then ticket is not available

  Scenario: ResultVisibility.Mode == Custom and CustomDate > Finished - send email when CustomDate and I voted
    Given I am verified user
    And I created a public drafted vortex.com
    And I have enabled results available notification
    And I invited some user to become participant in my vortex.com
    And I have published the draft
    And user have cast my vote in the vortex.com
    And vortex.com has already finished
    And vortex.com results are about to be available
    When user access resultsavailable ticket
    Then email subject is Voting has closed.
    And email contains a valid ticket link

  Scenario: ResultsVisibility = Finished and I voted
    Given I am verified user
    And I created a public drafted vortex.com
    And I set vortex.com results visibility to finished
    And I have enabled results available notification
    And I invited some user to become participant in my vortex.com
    And I have published the draft
    And user have cast my vote in the vortex.com
    And vortex.com has already finished
    When user access resultsavailable ticket
    Then email subject is Voting has closed.
    And email contains a valid ticket link
    When I access endedvortex.com ticket
    Then ticket is not available

  Scenario: started vortex.com sent to members added to draft when draft is published
    Given I am verified user
    And I created a private drafted vortex.com
    And I invited some user to become participant in my vortex.com
    And I have published the draft
    When user access startedvortex.com ticket
    Then email subject is You’ve been invited to vote.
    And email contains a valid ticket link

  Scenario: started vortex.com sent to orphaned members added to draft when draft is published
    Given I am verified user
    And I created a private drafted vortex.com
    And I invited orphaned user to become participant in my vortex.com
    And I have published the draft
    When user access startedvortex.com ticket
    Then email subject is You’ve been invited to vote.
    And email contains a valid ticket link
