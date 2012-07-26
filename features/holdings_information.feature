@wip
@marc

Feature:
  In order to see if library items are available
  As a library patron
  I should see holdings information displayed in searches

  Scenario: Viewing item in CWRU opac (BL-99)
    Given I am on the bib record page for 45080162
    Then I should see "Holdings"
    And I should see "Rock Hall Reference"

  Scenario: Access to Serials Holdings via Bib Record (BL-181)
    Given I am on the bib record page for 1478478
    Then I should see "Click for Holdings"
    Given I am on the bib record page for 702358017
    Then I should not see "Click for Holdings"

  Scenario: Status display for bib searches (BL-103)
    Given I am on the home page
    And I fill in "q" with "Kennedy"
    When I press "search"
    Then I should see "Status:"

  Scenario: Search results should display an unknown status if III is down (DAM-233)
    Given I am on the home page
    And the opac is down
    When I follow "Book"
    Then I should see "How to analyze the music of Bob Dylan"
    And I should wait "7" seconds
    And I should see "Status: Unknown"