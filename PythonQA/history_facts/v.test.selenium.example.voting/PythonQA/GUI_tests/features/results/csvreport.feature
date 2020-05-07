Feature: csv reports
    @suite1 @nonbrowser # case 1
Scenario Outline: Public channel, isPrivate=False, isPublic=True
    Given I am any user
    And I created a public channel
    And I created a public started vortex.com
    And I invited another user to become <role> in my channel
    When that user downloads csv report
    Then csv report is <report_status>
Examples:
|role|report_status|
|owner|shared|
|administrator|shared|
|contributor  |shared|
|participant  |shared|

    @suite1 @nonbrowser # case 1-2
Scenario Outline: Public channel, isPrivate=False, isPublic=True
    Given I am any user
    And I created a public channel
    And I created a public started vortex.com
    When <user> downloads csv report
    Then csv report is <report_status>
Examples:
|user|report_status|
|super user|shared|
|regular user|shared|
|anonymous|shared|
# 1.3 is a bug

    @suite1 @nonbrowser #case 2
Scenario Outline: Public channel, isPrivate=False, isPublic=True author
    Given I am any user
    And I created a public channel
    And I created a public started vortex.com
    And my role in channel has changed to <role>
    When I downloads csv report
    Then csv report is <report_status>
Examples:
|role|report_status|
|owner|shared      |
|administrator|shared|
|contributor  |shared|
|participant  |shared|
|nonmember|shared|

  @suite2 @nonbrowser # case 3
Scenario Outline: Public channel, isPrivate=False, isPublic=False
    Given I am any user
    And I created a public channel
    And I created a public drafted vortex.com
    And vortex.com has property isPublic set to False
    And I have published the draft
    And I invited another user to become <role> in my channel
    When that user downloads csv report
    Then csv report is <report_status>
    And I receive code 403 as response
    And response text is Vote results are secret, you can't see them.
Examples:
|role|report_status|
|owner|not shared|
|administrator|not shared|
|contributor  |not shared|
|participant  |not shared|

    @suite1 @nonbrowser # case 3-2, nothing is working (correctly)
Scenario Outline: Public channel, isPrivate=False, isPublic=False
    Given I am any user
    And I created a public channel
    And I created a public drafted vortex.com
    And vortex.com has property isPublic set to False
    And I have published the draft
    When <user> downloads csv report
    Then csv report is <report_status>
    And I receive code 403 as response
    And response text is Vote results are secret, you can't see them.
Examples:
|user|report_status|
|super user|not shared|
|regular user|not shared|
|anonymous|not shared|

    @suite2 @nonbrowser # case 4
Scenario Outline: Public channel, isPrivate=False, isPublic=False
    Given I am any user
    And I created a public channel
    And I created a public drafted vortex.com
    And vortex.com has property isPublic set to False
    And I have published the draft
    And my role in channel has changed to <role>
    When I downloads csv report
    Then csv report is <report_status>
    And I receive code 403 as response
    And response text is Vote results are secret, you can't see them.
Examples:
|role|report_status|
|owner|not shared  |
|administrator|not shared|
|contributor  |not shared|
|participant  |not shared|
|nonmember|not shared|

    @suite1 @nonbrowser # case 8
Scenario Outline: Private Channel, isPrivate=False, isPublic=True
    Given I am any user
    And I created a private channel
    And I created a public started vortex.com
    And I invited another user to become <role> in my channel
    When that user downloads csv report
    Then csv report is <report_status>
Examples:
|role|report_status|
|owner|shared|
|administrator|shared|
|contributor  |shared|
|participant  |shared|

    @suite1 @nonbrowser # case 8-2
Scenario Outline: Private Channel, isPrivate=False, isPublic=True
    Given I am any user
    And I created a private channel
    And I created a public started vortex.com
    When <user> downloads csv report
    Then csv report is <report_status>
    And I receive code <code> as response
Examples:
|user|report_status|code|
|super user|shared|200  |
|regular user|not shared|401|
|anonymous|not shared|401   |

    @suite2 @nonbrowser # case 9
Scenario Outline: Private Channel,isPrivate=False, isPublic=False
    Given I am any user
    And I created a private channel
    And I created a public drafted vortex.com
    And vortex.com has property isPublic set to False
    And I have published the draft
    And I invited another user to become <role> in my channel
    When that user downloads csv report
    Then csv report is <report_status>
Examples:
|role|report_status|
|owner|not shared  |
|administrator|not shared|
|contributor  |not shared|
|participant  |not shared|

    @suite2 @nonbrowser # case 9-2
Scenario Outline: Private Channel,isPrivate=False, isPublic=False
    Given I am any user
    And I created a private channel
    And I created a public drafted vortex.com
    And vortex.com has property isPublic set to False
    And I have published the draft
    When <user> downloads csv report
    Then csv report is <report_status>
Examples:
|user|report_status|
|super user|not shared|
|regular user|not shared|
|anonymous|not shared|

    @suite2 @nonbrowser # case 10
Scenario Outline: Private Channel,isPrivate=False, isPublic=False channel membership
    Given I am any user
    And I created a private channel
    And I created a private started vortex.com
    And vortex.com has property isPublic set to False
    And my role in channel has changed to <role>
    When I downloads csv report
    Then csv report is <report_status>
    And I receive code 403 as response
    And response text is Vote results are secret, you can't see them.
Examples:
|role|report_status|
|owner|not shared  |
|administrator|not shared|
|contributor  |not shared|
|participant  |not shared|
|nonmember|not shared|

    @suite2 @nonbrowser # case 5
Scenario Outline: Initiative in Public Channel, isPrivate=True, isPublic=True viewanalytics
    Given I am any user
    And I created a public channel
    And I created a private started vortex.com
    And I invited another user to become <role> in my vortex.com
    When I <action> viewAnalytics right <preposition> user
    And that user downloads csv report
    Then csv report is <report_status>
Examples:
|role|action|preposition|report_status|
|participant|add|to     |shared       |
|observer   |remove|from|not shared   |

    @suite2 @nonbrowser # case 5-2
Scenario: Initiative in Public Channel, isPrivate=True, isPublic=True viewanalytics
    Given I am any user
    And I created a public channel
    And I created a private started vortex.com
    When super user downloads csv report
    Then csv report is shared

    @suite2 @nonbrowser # case 6
Scenario Outline: Initiative in Public Channel, isPrivate=True, isPublic=False viewanalytics
    Given I am any user
    And I created a public channel
    And I created a private started vortex.com
    And I invited another user to become <role> in my vortex.com
    And vortex.com has property isPublic set to False
    When I <action> viewAnalytics right <preposition> user
    And that user downloads csv report
    Then csv report is <report_status>
Examples:
|role|action|preposition|report_status|
|participant|add|to     |not shared   |
|observer   |remove|from|not shared   |

    @suite2 @nonbrowser # case 6-2
Scenario: Initiative in Public Channel, isPrivate=True, isPublic=False viewanalytics
    Given I am any user
    And I created a public channel
    And I created a private started vortex.com
    And vortex.com has property isPublic set to False
    When super user downloads csv report
    Then csv report is not shared

    @suite1 @nonbrowser # case 7
Scenario Outline: Initiative in Private Channel, isPrivate=False, isPublic=True
    Given I am any user
    And I created a private channel
    And I created a public started vortex.com
    And I invited another user to become <role> in my channel
    When that user downloads csv report
    Then csv report is <report_status>
Examples:
|role|report_status|
|owner|shared|
|administrator|shared|
|contributor  |shared|
|participant  |shared|

    @suite1 @nonbrowser # case 7-2
Scenario Outline: Initiative in Private Channel, isPrivate=False, isPublic=True
    Given I am any user
    And I created a private channel
    And I created a public started vortex.com
    When <user> downloads csv report
    Then csv report is <report_status>
Examples:
|user|report_status|
|super user|shared |
|regular user|not shared|
|anonymous|not shared|
