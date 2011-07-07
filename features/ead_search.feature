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
    Then I should see "Curtis Mayfield Collection (ARC.0067)"
    And I should see "Oversize Materials"

  Scenario: Searching by accession number (BL-49)
    Given I am on the home page
    And I fill in "q" with "A1994.34.15"
    When I press "search"
    And I should see "Photographs"