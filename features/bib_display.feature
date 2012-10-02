@marc

Feature:
  In order to find bibiographic information useful
  As a library patron
  I should see records displayed correctly

  Scenario: Bib record display (BL-10)
    Given I am on the bib record page for 5774581
    Then I should see the field title "blacklight-title_display" contain "Title:"
    And I should see the field content "blacklight-title_display" contain "ASCAP supplementary index of performed compositions"
    And I should not see "Music United States Bibliography, Music United States Indexes, Songs United States Bibliography"

  Scenario: Subject field links (BL-10)
    Given I am on the bib record page for 5774581
    When I follow "Music--United States--Bibliography"
    Then I should see "ASCAP supplementary index of performed compositions"

  Scenario: Contributors field links (BL-10, BL-76)
    Given I am on the bib record page for 5774581
    When I follow "Gabler, Lee, donor"
    Then I should see "ASCAP index of performed compositions"
    And I should see "ASCAP index of performed compositions"

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
    Then I should see "Diamond dogs / Bowie"

  # TODO: depsite not using removeTralingPunct, it still seems to do it anyway
  Scenario: Displaying uniform title from 240 field (BL-48)
    Given I am on the bib record page for 3536869
    Then I should see "Songs. Selections"

  Scenario: Display resource links and urls (BL-48/42)
    Given I am on the bib record page for 33827620
    Then I should see the field title "blacklight-resource_link_display" contain "Online Resource:"
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

  Scenario: Series Index should include MARC field 811 (BL-104)
    Given I am on the bib record page for 754843822
    Then I should see the field content "blacklight-series_display" contain "Annual induction ceremony (Rock and Roll Hall of Fame Foundation). ; 2003"

  Scenario: Standard links in the bib record display (BL-136)
    Given I am on the bib record page for 663101343
    Then I should not see "Email This"
    And I should not see "SMS This"
    And I should see "Check nearby libraries"

  Scenario: Displaying Contents Coded as Enhanced 505s (BL-106)
    Given I am on the bib record page for 37138367
    Then I should see the field content "blacklight-contents_display" contain "I looked away"
    Then I should see the field title "blacklight-contents_display" contain "Contents:"

  Scenario: Display OCLC bib record numbers (BL-144)
    Given I am on the bib record page for 458698760
    Then I should see the field title "blacklight-id" contain "OCLC No.:"
    And I should see the field content "blacklight-id" contain "458698760"

  Scenario: Display Thesis Notes (BL-157, BL-158)
    Given I am on the bib record page for 35618845
    Then I should see the field content "blacklight-notes_display" contain "Thesis (Ph.D.)--Tulane University, 1995"
    And I should see the field content "blacklight-notes_display" contain "Photocopy. Ann Arbor, Mich. : UMI Dissertation Services, 2012. iv, 695 p. ; 23 cm"

  Scenario: Proper display of subjec headings (BL-TBA)
    Given I am on the bib record page for 10483424
    Then I should see "Dylan, Bob, 1941-"
    And I should see "Singers--United States--Biography"
    And I should not see "Dylan,Bob,--1941-"

  Scenario: Displaying Eras in Genre Headings (BL-176)
    Given I am on the bib record page for 668192442
    Then I should see the field content "blacklight-genre_display" contain "Biography--Juvenile literature"
    And I should see the field content "blacklight-genre_display" not contain "Biography Juvenile literature"

  Scenario: I should see the image of the format type when looking at an item (BL-111_
    Given I am on the bib record page for "228365502"
    Then I should see an image for "book"

  Scenario: Names entered as main entries and subjects are displaying under Contributors in bibs (BL-199)
    Given I am on the bib record page for 773370191
    Then I should see the field content "blacklight-contributors_display" contain "Moonalice (Musical group)"
    And I should see the field content "blacklight-contributors_display" not contain "Moonalice (Musical group)Posters"

  Scenario: OhlinLink urls (BL-257, BL-259)
    Given I am on the bib record page for 40393214
    Then I should see the field content "blacklight-ohlink_url_display" contain "Connect to Database Online"
    And I should see the field title "blacklight-ohlink_url_display" contain "OhioLink Resource:"
    And I should be able to follow "Connect to Database Online"
  
  Scenario: Bib record link display text (BL-258, BL-260)
    Given I am on the bib record page for 811563836
    Then I should see the field content "blacklight-resource_url_display" contain "Connect to resource"
    And I should see the field title "blacklight-resource_url_display" contain "Online Resource"
    And I should be able to follow "Connect to resource"


