Feature: Catalog Home Page
  In order to make sure the site is working
  As any user
  I want to be able to view the home page

  Scenario:
    Given I am on the home page
    Then I should see "Rock and Roll Hall of Fame Library and Archives"
    And I should see a facet for "Format"
    And I should see a facet for "Archival Material"
    And I should see a facet for "Archival Collection"
    And I should see a facet for "Topic"

  Scenario: Terms for "Format" facet (BL-15)
    Given I am on the home page
    Then I should see the facet term "Book"
    And I should see the facet term "Archival Collection"
    And I should see the facet term "Score"