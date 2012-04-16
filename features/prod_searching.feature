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