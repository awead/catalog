@javascript

Feature:
  In using the catalog
  As a library patron
  I need to be able to manage my bookmarks

  Scenario: Adding all the documents to my bookmarks
    Given I am on the search results page for Elvis
    When I check "toggle_all_bookmarks"
    And I wait for "3" seconds
    Then I should see "Remove all"
    And all bookmarks should be checked
    When I uncheck "toggle_all_bookmarks"
    And I wait for "3" seconds
    Then all bookmarks should be unchecked

