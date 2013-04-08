@marc

Feature:
  In order to find bibiographic information useful
  As a library patron
  I should see be able to search and see call numbers

  Scenario: Deriving call numbers for display (BL-41)
    Given I am on the bib record page for 45008581
    Then I should see "ML420.L466 S54 2000"
    And I should not see "ML420.L38 A5 2000"

  Scenario: Call number display (BL-296)
    Given I am on the bib record page for 785870275
    Then I should see the field content "blacklight-lc_callnum_display" contain "ML421.B5338 B53P4 2013"

  Scenario: Display Rockhall call numbers only (BL-307)
    Given I am on the home page
    And I fill in "q" with "quincy jones"
    When I press "search"
    Then I should see "Q : the autobiography of Quincy Jones / Quincy Jones"
    And I should see the field content "blacklight-lc_callnum_display" contain "ML429.J66 A3 2001"
    And I should see the field content "blacklight-lc_callnum_display" not contain "ML419.J7A3 2001"

  Scenario: Gather mulitple $a subfields for call number (BL-336) 
    Given I am on the home page
    And I fill in "q" with "Early days"
    When I press "search"
    Then I should see "Early days [sound recording] : the best of Led Zeppelin, volume two"
    And I should see the field content "blacklight-lc_callnum_display" contain "CD LED EARL 2000"   

  Scenario: Call number display (BL-296)
    Given I am on the home page
    And I fill in "q" with "Black Sabbath"
    When I press "search"
    Then I should see "Black Sabbath and philosophy : mastering reality / edited by William Irwin"
    And I should see the field content "blacklight-lc_callnum_display" contain "ML421.B5338 B53P4 2013"

  Scenario: Displaying call numbers from multiple 945 fields (BL-342)
    Given I am on the home page
    When I follow the format facet "Book"
    Then I should see "ML418.K466 A3 1992"
    And I should not see "ML418.K466 ML418.K466 A3 1992"

  Scenario: Call numbers for juvenile titles (BL-341)
    Given I am on the bib record page for 489441388
    Then I should see the field content "blacklight-lc_callnum_display" contain "ML3534 .G85 2011"

  Scenario: Call numbers for reference titles (BL-347)
    Given I am on the bib record page for 34241584
    Then I should see the field content "blacklight-lc_callnum_display" contain "ML156.4.P6 M42 1995"