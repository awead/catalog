@marc

Feature:
  In order to find bib items
  As a library patron
  I should be able to search for items

  Scenario: Searching for related works as titles (BL-64 and BL-65)
    Given I am on the home page
    And I fill in "q" with "in my life"
    And I select "Title" from "search_field"
    When I press "search"
    Then I should see "Rubber soul [sound recording] / the Beatles"

  Scenario: Stop words in searches (BL-82)
    Given I am on the home page
    And I fill in "q" with "legalize it"
    When I press "search"
    Then I should see "Legalize it [sound recording] / Peter Tosh"

  Scenario: Recently created bib records in Millennium are not appearing in Blacklight (BL-151)
    Given I am on the home page
    And I fill in "q" with "Père Ubu"
    When I press "search"
    Then I should see "The modern dance [sound recording] / Père Ubu"

  Scenario: Make OCLC Bib Record Numbers Searchable (BL-145)
    Given I am on the home page
    And I fill in "q" with "458698760"
    And I select "Oclc No." from "search_field"
    When I press "search"
    Then I should see "John Coltrane : his life and music / Lewis Porter"

  Scenario: Make contributor fields searchable (no ticket)
    Given I am on the home page
    And I fill in "q" with "Elvis Presley"
    And I select "Contributor" from "search_field"
    When I press "search"
    Then I should see "Shake, rattle & turn that noise down!"

  Scenario: Null ids in marc recrods (BL-169)
    Given I am on the bib record page for 35618845
    Given I am on the bib record page for 706740
    Given I am on the bib record page for b3416516
