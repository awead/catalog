Feature: Error messages
  In order to make the app more usable
  When any user enters false urls
  They should be redirected to the home page with appropriate error messages


  Scenario: User enters an id that doesn't exist (BL-178)
    Given I am on the bib record page for bogus_id
    Then I should see "Resource id bogus_id was not found or is unavailable"

  Scenario: User enters a bogus url (BL-178)
    Given I am on the bib record page for asd/asdflkj
    Then I should not see "Resource id asd/asdflkj was not found or is unavailable"
    And I should see "Welcome to the Library and Archives Catalog!"

