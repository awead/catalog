@marc

Feature:
  In order to find bibiographic information useful
  As a library patron
  I should see records displayed correctly

  Scenario: Bib record display (BL-10)
    Given I am on the bib record page for 5774581
    Then I should see "Title:"
    And I should not see "Music United States Bibliography, Music United States Indexes, Songs United States Bibliography"

  Scenario: Subject field links (BL-10)
    Given I am on the bib record page for 5774581
    When I follow "Music United States Bibliography"
    Then I should see "The all music book of hit albums / compiled by Dave McAleer"

  Scenario: Contributors field links (BL-10)
    Given I am on the bib record page for 5774581
    When I follow "Gabler, Lee, donor"
    Then I should see "ASCAP index of performed compositions"

  Scenario: Related works field links (BL-10)
    Given I am on the bib record page for 74495434
    When I follow "Inside the Beatles vaults"
    Then I should see "Lifting latches / John C. Winn"

  Scenario: Donor information and collection linkage (BL-39)
    Given I am on the bib record page for 45008581
    Then I should see "Donor:"
    And I should see "Gift: Nikki Collins; LA.2007.01.001"
    And I should see "Archival Collection:"
    And I should be able to follow "Art Collins Papers"

  Scenario: rhlocal link (BL-40)
    Given I am on the bib record page for 477045389
    Then I should not see "rhlocal"

  Scenario: searching for rhlocal via index (BL-40)
    Given I am on the home page
    And I fill in "q" with "rhlocal"
    When I press "search"
    Then I should see "The Beatles quiz book / compiled by Jack House"

  # TODO: depsite not using removeTralingPunct, it still seems to do it anyway
  Scenario: Displaying uniform title from 240 field (BL-48)
    Given I am on the bib record page for 3536869
    Then I should see "Songs. Selections"

  Scenario: Display resource links and urls (BL-48/42)
    Given I am on the bib record page for 33827620
    Then I should see the field title "blacklight-resource_link_display" contain "Resource Link:"
    And I should see the field content "blacklight-resource_link_display" contain "Rock and Roll Hall of Fame and Museum"
    And I should be able to follow "Rock and Roll Hall of Fame and Museum"

  Scenario: Deriving call numbers for display (BL-41)
    Given I am on the bib record page for 45008581
    Then I should see "ML420.L466 S54 2000"
    And I should not see "ML420.L38 A5 2000"

  Scenario: Multiple collection headings in 541$3 (BL-59)
    Given I am on the bib record page for 663101343
    Then I should see "Archival Collection"
    And I should see "Terry Stewart Collection"
    And I should see "Northeast Ohio Popular Music Archives"
    And I should be able to follow "Terry Stewart Collection"
    And I should be able to follow "Northeast Ohio Popular Music Archives"
