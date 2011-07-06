Feature: EAD display
  In order to view finding aids in Blacklight
  As a public user
  I should see properly formatted web page

  Scenario: Biographical Note and Administrative History (BL-5)
    Given I am on the ead page for ARC-0105
    When I follow "Biography/History"
    Then I should see "1911 May 18"
    And I should see "Born Joseph Vernon Turner, Jr. in Kansas City, Missouri"
    And I should see "1939"
    And I should see "Releases first single"
    And I should see "With Albert Ammons and Meade Lux Lewis, begins a five-year residency at New York's Cafe Society"
    And I should see "Big Joe Turner was among the first to mix R&B with boogie-woogie"
    And I should see "In the Sixties, after the first wave of rock and roll had died down"
    And I should see "Sources"
    And I should see "Big Joe Turner Biography"

  Scenario: Date Expression in first component level (BL-9)
    Given I am on the ead page for ARC-0105
    When I follow "Collection Inventory"
    Then I should see "Series II: Business Files, 1945-1946, 1983-1984, and undated"
    And I should see "Series VII: Printed Materials"
    And I should not see "Series VII: Printed Materials,"

  Scenario: Date expression in sub component level (BL-9) and accession numbers
    Given I am on the component page for ARC-0105:2:ref17
    Then I should see "Series I: Awards and Certificates"
    And I should see "Awards and certificates, 1976-1986"
    And I should not see "Museum Accession Numbers:"
    And I should not see "A1994.4.10-A1994.4.22"

  Scenario: Names (BL-7)
    Given I am on the ead page for ARC-0001
    When I follow "Controlled Access Headings"
    Then I should see "Collins, Nikki"

  Scenario: Don't show heading for fields that aren't there
    Given I am on the ead page for ARC-0065
    Then I should not see "Biographical Note"

  Scenario: Dimensions note (BL-8)
    Given I am on the component page for ARC-0065:2:ref43
    Then I should see "Limited Print Run"
    And I should see "Non-numbered edition of 200"
    And I should see "Dimensions:"
    And I should see "23"
    And I should see "29"
    And I should see "Location:"
    And I should see "Folder: 7, Object: 2, Drawer: FF.1.4"

  Scenario: I need to see all sub-components (BL-58)
    Given I am on the component page for ARC-0065:2:ref42
    Then I should see "Psycotic Pineapple, 1980 August 4-1980 September 15"
    And I should see "Ultras with Dale, Dick"

  Scenario: EAD that has no collection headings (BL-60)
    Given I am on the ead page for RG-0001
    Then I should not see "Controlled Access Headings"

  @wip
  Scenario: Hide accession numbers (BL-49)
    Given I am on the ead page for ARC-0058
    Then I should not see "A2005.31.15"