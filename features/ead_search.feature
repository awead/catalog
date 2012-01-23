@ead

Feature: EAD display
  In order to view finding aids in Blacklight
  As a public user
  I should be able to search for finding aids using specific terms


  Scenario: Searching by accession number (BL-49)
    Given I am on the home page
    And I fill in "q" with "A2005.31.15"
    When I press "search"
    Then I should see "Jermaine Rogers Collection (ARC.0058)"

  Scenario: Searching by accession number (BL-49)
    Given I am on the home page
    And I fill in "q" with "A1994.34.7"
    When I press "search"
    Then I should see "Guide to the Curtis Mayfield Collection (ARC.0067)"
    And I should see "Photographs"

  Scenario: Searching by accession number (BL-49)
    Given I am on the home page
    And I fill in "q" with "A1994.34.15"
    When I press "search"
    And I should see "Photographs"

  Scenario: Searching for component archival materials (BL-55, BL-67)
    Given I am on the home page
    And I fill in "q" with "Negatives"
    When I press "search"
    Then I should see "Negatives"
    And I should see "Curtis Mayfield Collection (ARC.0067)"
    And I should not see "Book: Poetic License: In Poem and Song"

  Scenario: Series components suppressed from search results (BL-55, BL-67)
    Given I am on the home page
    And I fill in "q" with "Correspondence"
    When I press "search"
    Then I should see "Big Joe Turner Papers (ARC.0105)" within "dd"
    And I should not see "Awards and certificates"
    And I should not see "Series I: Awards and Certificates" within "h3"

  Scenario: Display of archival component titles (BL-68)
    Given I am on the home page
    And I fill in "q" with "Negatives"
    When I press "search"
    Then I should not see "Finding Aid"
    And I should see "Guide to the Curtis Mayfield Collection"
    And I should see "Negatives and transparencies"

  Scenario: Suppress status display from ead-related items (BL-103)
    Given I am on the home page
    And I fill in "q" with "Negatives"
    When I press "search"
    Then I should not see "Status:"

  Scenario: Searchability of EAD (BL-140)
    Given I am on the home page
    And I fill in "q" with "rolling stones tour documents 1981"
    When I press "search"
    Then I should see "1981 tour documents"
