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