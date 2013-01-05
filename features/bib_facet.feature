@marc

Feature: Catalog Home Page
  In order to use the catalog
  As a patron or staff member
  I would like to limit my searches in the discovery interface using facets

  Scenario: Facets for limiting search (BL-14, BL-137)
    Given I am on the home page
    Then I should see a facet for "Format"
    And I should see a facet for "Collection Name"
    And I should see a facet for "Subject"
    And I should see a facet for "Name"
    And I should see a facet for "Event/Series"
    And I should see a facet for "Genre"
    And I should see a facet for "Collection Name"
    And I should not see a facet for "Call Number"

  Scenario: Terms for "Format" facet (BL-15)
    Given I am on the home page
    Then I should see the facet term "Book"
    And I should see the facet term "Score"
    And I should see the facet term "Website"
    And I should see the facet term "Periodical"
    And I should see the facet term "Video"
    And I should see the facet term "Audio"
    And I should see the facet term "CD/DVD-ROM"

  Scenario: Verifying quantities of each format (BL-268)
    Given I am on the home page
    And I should see "Book (46)"
    And I should see "Theses/Dissertations (9)"
    And I should see "Audio (9)"
    And I should see "Score (7)"
    And I should see "Website (4)"
    And I should see "CD/DVD-ROM (1)"
    And I should see "Periodical (2)"
    And I should see "Video (2)"

  Scenario: Facet for CD/DVD-ROM (BL-250)
    Given I am on the home page
    When I follow "CD/DVD-ROM"
    Then I should see "77 million paintings [electronic resource] / by Brian Eno"

  Scenario: Collection name facet (BL-14)
    Given I am on the home page
    When I follow "Art Collins Papers"
    Then I should see a facet for "Format"
    And I should see the facet term "Book"

  Scenario: Collection Headings in Name Facet (BL-63)
    Given I am on the home page
    Then I should not see "Jeff Gold Collection (Rock and Roll Hall of Fame and Museum. Library and Archives)"

  Scenario: Subject headings for library materials are under the Topic facet
    Given I am on the home page
    When I follow "Rock music--History and criticism"
    Then I should see "Classic rock / edited by Chris Woodstra, John Bush, Stephen Thomas"

  Scenario: Add facet for theses and dissertations (BL-153,BL-154)
    Given I am on the home page
    Then I should see a facet for "Format"
    And I should see the facet term "Theses/Dissertations"

  Scenario: CD/DVD-ROM facet pulling in Enchanged music CDs (BL-268)
    Given I am on the home page
    When I follow the facet term "CD/DVD-ROM" 
    Then I should see "77 million paintings [electronic resource] / by Brian Eno"
    And I should not see "Viva Elvis [sound recording] : the album"

  Scenario: Audio facet for Enchanged music CDs (BL-268)
    Given I am on the home page
    When I follow the facet term "Audio"
    Then I should see "Viva Elvis [sound recording] : the album"
    And I should not see "The Pink Floyd encyclopedia / written & compiled by Vernon Fitch"

