Feature:
  In order to find bibiographic information useful
  As a library patron
  I should see records displayed correctly

  Scenario: Bib record display (BL-10)
    Given I am on the bib record page for 5774581
    Then I should see "Title:"
    And I should not see "Music United States Bibliography, Music United States Indexes, Songs United States Bibliography"

  Scenario: Subject field links (BL-10)
    Given I am on the bib record page for 5774581
    When I follow "Music United States Bibliography"
    Then I should see "The all music book of hit albums / compiled by Dave McAleer"

  Scenario: Contributors field links (BL-10)
    Given I am on the bib record page for 5774581
    When I follow "Gabler, Lee, donor"
    Then I should see "ASCAP index of performed compositions"

  Scenario: Related works field links (BL-10)
    Given I am on the bib record page for 74495434
    When I follow "Inside the Beatles vaults"
    Then I should see "Lifting latches / John C. Winn"