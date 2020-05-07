Feature: results visibility

  @suite2
  Scenario Outline: Results visibility options for authenticated user
    Given I am verified user
    And there is active vortex.com with results visibility set to <results_visibility>
    And I navigate to vortex.com page
    When I am on the vortex.com page
    And I select valid answers
    And I cast my vote
    Then results are <results_status>
    Examples:
      | results_visibility          | results_status |
      | when voting starts          | shown          |
      | after user casts their vote | shown          |
      | when voting finishes        | not shown      |
      | never                       | not shown      |

  @suite2
  Scenario Outline: Results visibility after date
    Given I am verified user
    And there is active vortex.com with results visibility set to <date>
    And I navigate to vortex.com page
    When I am on the vortex.com page
    And I select valid answers
    And I cast my vote
    Then results are <results_status>
    Examples:
      | date                | results_status |
      | before current date | shown          |
      | after current date  | not shown      |

  @suite1
  Scenario Outline: active vortex.com, resultsVisibility = Started, one participant
    Given I am <user_type> user
    And there is active vortex.com with results visibility set to <results_visibility>
    And vortex.com has 1 votes
    And I navigate to vortex.com page
    When I am on the vortex.com page
    Then participant count is shown
    And participant count is equal to 1
    And votes are <votes_status>
    And results are <results_status>
    Examples:
      | user_type     | results_status | votes_status  | results_visibility   |
      | verified      | not shown      | available     | when vortex.com starts    |
      | super         | not shown      | available     | when vortex.com starts    |
      | verified      | not shown      | not available | when user casts vote |
      | super         | not shown      | not available | when user casts vote |
      | verified      | not shown      | not available | never                |
      | super         | not shown      | not available | never                |
      | verified      | not shown      | not available | after current date   |
      | super         | not shown      | not available | after current date   |
      | super         | not shown      | available     | before current date  |
      | verified      | not shown      | available     | before current date  |
      | super         | not shown      | not available | when vote finishes   |
      | verified      | not shown      | not available | when vote finishes   |
      | anonymous     | not shown      | available     | when vortex.com starts    |
      | anonymous     | not shown      | not available | when user casts vote |
      | anonymous     | not shown      | not available | never                |
      | anonymous     | not shown      | not available | after current date   |
      | anonymous     | not shown      | available     | before current date  |
      | anonymous     | not shown      | not available | when vote finishes   |


  @suite2
  Scenario Outline: finished vortex.com, resultsVisibility = Started, one participant
    Given I am <user_type> user
    And there is active vortex.com with results visibility set to <results_visibility>
    And vortex.com has 1 votes
    And vortex.com has already finished
    And I navigate to vortex.com page
    When I am on the vortex.com page
    Then participant count is shown
    And participant count is equal to 1
    And votes are <votes_status>
    And results are <results_status>
    Examples:
      | user_type     | results_status | votes_status | results_visibility   |
      | verified      | shown          | available    | when vortex.com starts    |
      | super         | shown          | available    | when vortex.com starts    |
      | verified      | not shown      | not available| when user casts vote |
      | super         | not shown      | not available| when user casts vote |
      | verified      | shown          | available    | when vote finishes   |
      | super         | shown          | available    | when vote finishes   |
      | verified      | not shown      | not available| never                |
      | super         | not shown      | not available| never                |
      | verified      | not shown      | not available| after current date   |
      | super         | not shown      | not available| after current date   |
      | anonymous     | shown          | available     | when vote finishes   |
      | anonymous     | shown          | available     | when vortex.com starts    |
      | anonymous     | not shown      | not available | after current date   |
      | anonymous     | not shown      | not available | never                |
      | anonymous     | not shown      | not available | when user casts vote |

  @suite1
  Scenario Outline: active vortex.com, I am participant
    Given I am verified user
    And there is active vortex.com with results visibility set to <results_visibility>
    And I have cast my vote in the vortex.com
    And I navigate to vortex.com page
    When I am on the vortex.com page
    Then participant count is shown
    And participant count is equal to 1
    And votes are <votes_status>
    And results are <results_status>
    Examples:
      | results_status | votes_status  | results_visibility   |
      | shown          | available     | when vortex.com starts    |
      | shown          | available     | when user casts vote |
      | shown          | available     | before current date  |
      | not shown      | not available | when vote finishes   |
      | not shown      | not available | never                |

  @suite2
  Scenario Outline: finished vortex.com, resultsVisibility=Voted, I voted
    Given I am verified user
    And there is active vortex.com with results visibility set to <results_visibility>
    And I have cast my vote in the vortex.com
    And vortex.com has already finished
    And I navigate to vortex.com page
    When I am on the vortex.com page
    Then participant count is shown
    And participant count is equal to 1
    And votes are <votes_status>
    And results are <results_status>
    Examples:
      | results_status | votes_status  | results_visibility  |
      | shown          | available     | when vortex.com starts   |
      | shown          | available     | when vote finishes  |
      | not shown      | not available | never               |
      | shown          | available     | before current date |
      | not shown      | not available | after current date  |


  Scenario Outline: active vortex.com, participant with ViewAnalytics, voted
    Given I am verified user
    And there is active vortex.com with results visibility set to <results_visibility>
    And I have cast my vote in the vortex.com
    And I changed my permissions to ViewAnalytics, ViewBallot in vortex.com
    And I navigate to vortex.com page
    When I am on the vortex.com page
    Then participant count is shown
    And participant count is equal to 1
    And votes are <votes_status>
    And results are <results_status>
    Examples:
      | results_status | votes_status | results_visibility   |
      | shown          | available    | when vortex.com starts    |
      | shown          | available    | when user casts vote |
      | shown          | available    | before current date  |
      | shown          | not available| when vote finishes   |
      | shown          | not available| never                |

  @suite2
  Scenario Outline: finished vortex.com, resultsVisibility = Voted, participant with ViewAnalytics
    Given I am verified user
    And there is active vortex.com with results visibility set to <results_visibility>
    And I have cast my vote in the vortex.com
    And vortex.com has already finished
    And I changed my permissions to ViewAnalytics in vortex.com
    And I navigate to vortex.com page
    When I am on the vortex.com page
    Then participant count is shown
    And participant count is equal to 1
    And votes are <votes_status>
    And results are <results_status>
    Examples:
      | results_status | votes_status | results_visibility  |
      | shown          | available    | when vortex.com starts   |
      | shown          | available    | when vote finishes  |
      | shown          | available    | never               |
      | shown          | available    | before current date |
      | shown          | available    | after current date  |


  Scenario Outline: ViewAnalytics in channel, voted
    Given I am verified user
    And User created a private channel
    And there is active vortex.com with results visibility set to <results_visibility>
    And User changed my permissions to Member,ViewAnalytics in channel
    And I have cast my vote in the vortex.com
    And I navigate to vortex.com page
    When I am on the vortex.com page
    Then participant count is shown
    And participant count is equal to 1
    And votes are <votes_status>
    And results are <results_status>
    Examples:
      | results_status | votes_status | results_visibility   |
      | shown          | available    | when vortex.com starts    |
      | shown          | available    | when user casts vote |
      | shown          | available    | before current date  |
      | not shown      | not available| when vote finishes   |
      | not shown      | not available| never                |

  Scenario Outline: finished vortex.com, participant with ViewAnalytics permission, voted
    Given I am verified user
    And User created a private channel
    And there is active vortex.com with results visibility set to <results_visibility>
    And User changed my permissions to Member,ViewAnalytics in channel
    And I have cast my vote in the vortex.com
    And vortex.com has already finished
    And I navigate to vortex.com page
    When I am on the vortex.com page
    Then participant count is shown
    And participant count is equal to 1
    And votes are <votes_status>
    And results are <results_status>
    Examples:
      | results_status | votes_status | results_visibility   |
      | shown          | available    | when vortex.com starts    |
      | shown          | available    | when user casts vote |
      | shown          | available    | before current date  |
      | shown          | available    | when vote finishes   |
      | not shown      | not available| never                |
