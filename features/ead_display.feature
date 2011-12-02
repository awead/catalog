@ead

Feature: EAD display
  In order to view finding aids in Blacklight
  As a public user
  I should see properly formatted web page

  Scenario: Biographical Note and Administrative History (BL-5)
    Given I am on the ead page for ARC-0105
    When I follow "Biographical Note"
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
    Given I am on the ead page for ARC-0105:2:ref42
    Then I should see "Series I: Awards and Certificates"
    And I should see "Awards and certificates, 1976-1986"
    And I should not see "Museum Accession Numbers:"
    And I should not see "A1994.4.10-A1994.4.22"

  Scenario: Names (BL-7)
    Given I am on the ead page for ARC-0058
    When I follow "Controlled Access Headings"
    Then I should see "Auf der Maur, Melissa"

  Scenario: Dimensions note (BL-8); Dimensions replaced with Physical Description (BL-119)
    Given I am on the ead page for ARC-0065:2:ref10
    Then I should see "Limited Print Run"
    And I should see "Non-numbered edition of 200"
    And I should not see "Dimensions:"
    And I should see "23"
    And I should see "29"
    And I should see "Location:"
    And I should see "Drawer: FF.1.4, Folder: 7, Object: 1"

  Scenario: I need to see all sub-components (BL-58)
    Given I am on the ead page for ARC-0065:2:ref62
    Then I should see "Psycotic Pineapple, 1980 August 4-1980 September 15"
    And I should see "Ultras with Dale, Dick"

  @future-work
  Scenario: EAD that has no collection headings (BL-60)
    Given I am on the ead page for RG-0001
    Then I should not see "Controlled Access Headings"

  Scenario: Show accession numbers (BL-118) Note: this is revoked from BL-49
    Given I am on the ead page for ARC-0058
    Then I should see "A2005.31.15"

  Scenario: HTTP calls for components should still work (BL-55)
    Given I am on the component page for ARC-0065:2:ref42
    Then I should see "Psycotic Pineapple, 1980 August 4-1980 September 15"

  Scenario: Displaying italics (BL-33)
    Given I am on the ead page for ARC-0058
    Then I should see "New Musical Express" in italics
    And I should see "Love" in italics
    Given I am on the ead page for ARC-0105
    Then I should see "Blues Train" in italics

  Scenario: Separated materials notes (BL-43)
    Given I am on the ead page for ARC-0105
    Then I should see "Separated Materials"
    And I should see "Biographical Note"

  Scenario: Related materials and accruals (BL-115)
    Given I am on the ead page for ARC-0006
    Then I should see "Related materials providing content on Alan Freed may be found in the following collections in this repository: Terry Stewart Collection."
    And I should see "Where possible, accruals were interfiled with preexisting collection materials; otherwise, accruals can be found at the end of Series V: Personal Papers."

  Scenario: Separated materials and access restrictions (BL-116)
    Given I am on the ead page for ARC-0003
    Then I should see "Ten-inch LPs, 78s, 78 sets, 45s, 45 RPM EPs, and LPs have been transferred to the library collection."
    And I should see "The 1/4-inch audiotapes in this series are on defunct media and, therefore, are RESTRICTED. Access copies of these materials will have to be created prior to use. Consult the Library and Archives staff in advance of your visit to ensure access to these materials is available."

  Scenario: Existence and Location of Originals (BL-117)
    Given I am on the ead page for ARC-0006:3:ref641
    Then I should see "original plaque"

  Scenario: Physical description (BL-119)
    Given I am on the ead page for ARC-0006:3:ref876
    Then I should see "Linen-backed. Unframed at the L&A."

  Scenario: Language of Materials, Museum Acc. #, Separated Materials (BL-118)
    Given I am on the ead page for ARC-0006:3:ref690
    Then I should see "Material is in French."
    And I should see "A2010.1.18"
    And I should see "Item on exhibit. Consult the Library and Archives staff in advance of your visit for additional information."

  Scenario: Provenance (BL-120)
    Given I am on the ead page for ARC-0037
    Then I should see "Jeff Gold purchased these files from Toby Gleason."
    And I should not see "Provenance"
    And I should see "Custodial History"