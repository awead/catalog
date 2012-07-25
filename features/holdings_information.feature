@marc

Feature:
  In order to see if library items are available
  As a library patron
  I should see holdings information displayed in searches

  @wip
  Scenario: Search results should display an unknown status if III is down (DAM-233)
    Given I am on the home page
    And the opac is down
    When I follow "Book"
    Then I should see "How to analyze the music of Bob Dylan"
    And I should wait "7" seconds
    And I should see "Status: Unknown"