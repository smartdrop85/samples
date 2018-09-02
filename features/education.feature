Feature: Education
  As a user I want to view courses and articles

  Background:
    Given Some portal Main page is opened and start popup is skipped
    Then I should see 'Sample' page
    Given The course Course 1 exists
    When I click 'Education' button in top menu

  @sanity
  Scenario: Open course from index page
    When I open Course 1 course from courses index page
    Then I should see Course 1 course view page

  @sanity
  Scenario: Start course from view page
    When I open Course 1 course from courses index page
    And I click on Start Course button
    Then I should see Introduction page of Course 1 course

  @sanity
  Scenario: Open material from course page
    When I open Course 1 course from courses index page
    And I click on Some lecture material
    Then I should see Some lecture page of Course 1 course

  @sanity
  Scenario: Check write to us link
    When I open Course 1 course from courses index page
    Then I check Write to us link