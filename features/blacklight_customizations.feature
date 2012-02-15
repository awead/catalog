Feature:
  So that our blacklight installation is super-special
  The public
  Should be able to see all our cusomtizations

  Scenario: Customized language for the login page (BL-179)
    Given I am on the login page
    Then I should see "Sign in"
    And I should see "Create an account to save and export your searches."

  Scenario: Customized language for the signup page (BL-179)
    Given I am on the signup page
    Then I should see "Sign up"
    And I should see "By signing up, you can save your searches and export them later if needed."

  Scenario: Highlighting search terms (BL-179)
    Given I am on the home page
    When I fill in "q" with "Elvis"
    And I press "search"
    Then I should see the word "Elvis" highlighted