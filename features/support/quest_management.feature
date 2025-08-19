Feature: Quest Management
  As a user
  I want to manage my quests
  So that I can track my daily tasks and goals

  Background:
    Given I am on the quest management page

  Scenario: View empty quest list
    When I visit the quest page with no existing quests
    Then I should see "No quests yet!"
    And I should see "Add your first quest above to get started"
    And I should see the add quest form

  Scenario: Add a new quest
    When I fill in the quest title with "Learn Cucumber testing"
    And I click the add quest button
    Then I should see "Learn Cucumber testing" in the quest list
    And I should see "1 quest" in the quest count


  Scenario: View multiple quests in correct order
    Given I have the following quests:
      | title           | created_at      | done  |
      | Oldest quest    | 3 days ago      | false |
      | Middle quest    | 1 day ago       | true  |
      | Newest quest    | 1 hour ago      | false |
    When I visit the quest page
    Then I should see quests in the following order:
      | Newest quest  |
      | Middle quest  |
      | Oldest quest  |
    And I should see "3 quests" in the quest count
    And I should see "1 completed" in the quest count

  Scenario: Add quest with invalid data
    When I try to add a quest with empty title
    Then the quest should not be created
    And I should remain on the quest page

  Scenario: Navigate to brag document
    When I click on "My brag document" button
    Then I should be on the brag document page

  