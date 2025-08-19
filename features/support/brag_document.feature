Feature: Brag Document
  As a user
  I want to view my brag document  
  So that I can see my achievements and accomplishments

  Scenario: Navigate to brag document from quest page
    Given I am on the quest management page
    When I click on "My brag document" button
    Then I should be on the brag document page
    And I should see "Aoom Development Goals" in the page title
    And I should see "Back to Quests" button

  Scenario: Navigate back to quest page from brag document
    Given I am on the brag document page
    When I click on the Back to Quests button
    Then I should be on the quest management page
    And I should see the add quest form

  Scenario: View brag document content
    Given I am on the brag document page
    Then I should see the brag document header
    And I should see "Aoom Development Goals" as the main heading
