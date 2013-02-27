@marc

Feature:
  In order to properly cite sources in the catalog
  As a public user
  I should see correctly formatter APA and MLA citations

  Scenario: Authors from all 1XX fields
    Given I am on the citation page for 8168726
    Then I should see "Palmer, Robert. Deep Blues. Harmondsworth, Middlesex, England: Penguin Books, 1982."
    And I should see "Palmer, R. (1982). Deep blues. Harmondsworth, Middlesex, England: Penguin Books."
    And I should not see "Palmer, Robert, Manny Gerard, and Jane Scott."