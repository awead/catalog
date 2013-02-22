@ead
@javascript

Feature: Navigating ead finding aids
  As a public user
  When I am viewing a finding aid
  I need to navigate series and subseries elements

  Scenario: Opening elements within a series
    Given I am on the ead page for ARC-0006
    When I follow "ref1-open"
    Then I should see "Subseries 1: Action Records, 1959"
    When I follow "ref7-open"
    Then I should see "Cancelled checks"
    When I follow "ref1062-open"
    And I wait for "2" seconds
    Then I should see "Check Register, 1959 November 6"
    When I click the close button "ref1-close"
    Then I should not see "Check Register, 1959 November 6"
    And I should not see "Subseries 1: Action Records, 1959"

  Scenario: Opening a finding aid to a particular component
    Given I am on the ead page for ARC-0006ref817
    And I wait for "3" seconds
    Then I should see "Series II: People v. Alan Freed, 1958-1962"
    And I should see "Admissions as to defendant’s dealings, circa 1962"
    And I should see "Bernard Friedlander" in a highlighted component
