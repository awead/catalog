@marc

Feature:
  In order to find bib items
  As a library patron
  I should be able to search for items

  @wip
  Scenario: Searching for related works as titles (BL-64 and BL-65)
    Given I am on the home page
    And I fill in "q" with "in my life"
    And I select "Title" from "search_field"
    When I press "search"
    Then I should see "Rubber soul [sound recording] / the Beatles"