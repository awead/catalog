@marc

Feature: Catalog Home Page
  In order to use the catalog
  As a patron or staff member
  I would like to limit my searches in the discovery interface using facets

  Scenario: Facets for limiting search (BL-14)
    Given I am on the home page
    Then I should see a facet for "Format"
    And I should see a facet for "Collection Name"
    And I should see a facet for "Topic"
    And I should see a facet for "Name"
    And I should see a facet for "Event/Series"
    And I should see a facet for "Genre"
    And I should see a facet for "Collection Name"

  Scenario: Terms for "Format" facet (BL-15)
    Given I am on the home page
    Then I should see the facet term "Book"
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

  Scenario: Collection Headings in Name Facet (BL-63)
    Given I am on the home page
    Then I should not see "Jeff Gold Collection (Rock and Roll Hall of Fame and Museum. Library and Archives)"

  Scenario: Subject headings for library materials are under the Topic facet
    Given I am on the home page
    When I follow "Rock music"
    Then I should see "1950s radio in color"
    And I should see "Classic rock"