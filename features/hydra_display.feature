Feature:
  Given I am using the catalog
  As a public user
  I should see items from Hydra displayed

  Scenario: Displaying subjects (BL-374)
    Given I am on the bib record page for rrhof:525
    Then I should see the field content "blacklight-subject_facet" contain "Hunter, Ian, 1939-"
    And I should see the field content "blacklight-subject_facet" contain "Rock musicians--England"
    And I should see the field content "blacklight-subject_facet" contain "Rock music--History and criticism"