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

  Scenario: Date expression in sub component level (BL-9)
    Given I am on the component page for ARC-0105:2:ref17
    Then I should see "Series I: Awards and Certificates"
    And I should see "Awards and certificates, 1976-1986"

  Scenario: Names (BL-7)
    Given I am on the ead page for ARC-0001
    When I follow "Controlled Access Headings"
    Then I should see "Collins, Nikki"