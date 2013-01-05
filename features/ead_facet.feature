@ead

Feature: Catalog Home Page
  In order to use the catalog
  As a patron or staff member
  I would like to limit my searches in the discovery interface using facets

  Scenario: Facets for limiting search (BL-14)
    Given I am on the home page
    Then I should see a facet for "Format"
    And I should see a facet for "Archival Material"
    And I should see a facet for "Collection Name"
    And I should see a facet for "Subject"
    And I should see a facet for "Name"
    And I should see a facet for "Event/Series"
    And I should see a facet for "Genre"
    And I should see a facet for "Collection Name"

  Scenario: Terms for "Format" facet (BL-15)
    Given I am on the home page
    Then I should see the facet term "Book"
    And I should see the facet term "Archival Collection"
    And I should see the facet term "Score"
    And I should see the facet term "Website"
    And I should see the facet term "Periodical"
    And I should see the facet term "Video"
    And I should see the facet term "Audio"

  Scenario: Collection name facet (BL-14)
    Given I am on the home page
    When I follow "Art Collins Papers"
    Then I should see a facet for "Format"
    And I should see the facet term "Book"

  Scenario: Series headings need to be linked (BL-100)
    Given I am on the bib record page for 34407310
    When I follow "Atlantic & Atco remasters series"
    Then I should see "I never loved a man the way I love you [sound recording] / Aretha Franklin"

  Scenario: Add the collection name to the collection_facet field for archival items (BL-182)
    Given I am on the home page
    When I follow "Jeff Gold Collection"
    Then I should see the facet term "Archival Collection"
