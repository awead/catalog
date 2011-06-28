@marc

Feature:
  In order to see both library and archival materials
  As a user
  I should be able to facet on books that are a part of archival collections

  Scenario: Custom facet for collection name (BL-51)
    Given I am on the bib record page for 45008581
    Then I should see the field title "blacklight-collection_display" contain "Archival Collection:"
    And I should see the field content "blacklight-collection_display" contain "Art Collins Papers"
    And I should see the field title "blacklight-contributors_display" contain "Contributors:"
    And I should see the field content "blacklight-contributors_display" not contain "Art Collins Papers (Rock and Roll Hall of Fame and Museum. Library and Archives)"
    And I should see the field content "blacklight-contributors_display" contain "Art Collins Papers"
    And I should be able to follow "Art Collins Papers"