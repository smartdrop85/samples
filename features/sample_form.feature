Feature: Complete the form
    As an sample user I want to be able to complete the form
    when the reporting is open

    Scenario: Create a new report
        Given I am logged in LK
        And Sample report tab is opened
        When I select a company Sample company in companies list
        And I create new report
        #TODO continue the scenario