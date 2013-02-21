@prod

Feature:
  Given I'm running in production
  These tests should only be run in production


  Scenario: Relevancy ranking should put archival items last (BL-207)
    Given I am on the home page
    And I fill in q with "Freed"
    When I press search
    Then I should see "Guide to the Alan Freed Collection (ARC.0006)"
    And I should see "Big beat heat : Alan Freed and the early years of rock & roll / John A."
    And I should see "Guide to the Collection on Alan Freed (Rock and Roll Hall of Fame and Museum Collection) (ARC.0296)"

  Scenario: Subject headings for Hydra items (SYS-137)
    Given I am on the bib record page for "rrhof:3514"
    Then I should see the field content "subject-facet" contain "Belkin, Jules, 1930-"
    And I should see the field content "subject-facet" contain "Belkin, Mike (Myron), 1935-"
    And I should see the field content "subject-facet" contain "Promoters-Ohio-Cleveland"
    And I should see the field content "subject-facet" contain "Concert agents-Ohio-Cleveland"
    And I should see the field content "subject-facet" contain "Rock music-Ohio-Cleveland"
    And I should see the field content "subject-facet" contain "Rock music--History and criticism"

  Scenario: Contributor names in Hydra items (DAM-265)
    Given I am on the bib record page for "rrhof:3533"
    Then I should see the field content "contributors_display" contain "Gaudio, Bob"
    And I should see the field content "contributors_display" contain "DeCurtis, Anthony"
    And I should see the field content "contributors_display" contain "Rock and Roll Hall of Fame Foundation"