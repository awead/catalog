Feature:
  Given I am accessing the catalog from outside the library
  As a public user
  I should only see records for restricted videos

  Scenario: Accessing a publicly available video (BL-373)
    Given I am on the bib record page for rrhof:2392
    Then I should see "Oral history project. Al Bell."
    And I should not see the video player

  Scenario: Accessing a restricted video (BL-373)
    Given I am on the bib record page for rrhof:525
    Then I should see "Evening with series. Ian Hunter. Part 1."
    And I should see "Video available in the library only."
    And I should not see the video player