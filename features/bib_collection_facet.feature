@wip, @marc

Feature:
  In order to see both library and archival materials
  As a user
  I should be able to facet on books that are a part of archival collections

  Scenario: Book that is not in an archival collection
    Given I am on the bib record page for 25369444
    Then I should not see "Archival Collection:"

  Scenario: Book that is in an archival collection
    Given I am on the bib record page for 38964189
    Then I should see "Archival Collection:"
    And I should be able to follow "Rock Hall Library only"
    And I should be able to follow "Jeff Gold Collection (Rock and Roll Hall of Fame and Museum. Library and Archives)"

  Scenario: Facet on a book with multiple 710$a field
    Given I am on the home page
    And I fill in "q" with "Blackmore"
    When I press "search"
    Then I should see a facet for "Collection Name"
    Then I should see a facet for "Name"
    And I should be able to follow "Rainbow : rising / Ritchie Blackmore"
    And I should be able to follow "Art Collins Papers"
    And I should be able to follow "Art Collins Papers (Rock and Roll Hall of Fame and Museum. Library and Archives)"

