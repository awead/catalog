Feature: Catalog Home Page
  In order to use the catalog
  As a patron or staff member
  I would like to limit my searches in the discovery interface using facets

  Scenario: Facets for limiting search (BL-14)
    Given I am on the home page
    Then I should see "Rock and Roll Hall of Fame Library and Archives"
    And I should see a facet for "Format"
    And I should see a facet for "Archival Material"
    And I should see a facet for "Collection Name"
    And I should see a facet for "Topic"
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

  Scenario: Collection name facet (BL-14)
    Given I am on the home page
    When I follow "Art Collins Papers"
    Then I should see a facet for "Format"
    And I should see the facet term "Book"
