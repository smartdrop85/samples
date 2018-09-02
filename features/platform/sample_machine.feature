Feature: Sample feature
  As a system user I would like to use a sample feature

  Background:
    Given The test page is opened

  Scenario: Spin the machine
    When I press Spin button under the slot machine
    Then I should see the result of the spinning

  Scenario: Increase the bet
    When I store the initial win chart numbers
    And I increase the bet on 1
    Then All win chart numbers should increase by 2

  Scenario: Decrease the bet
    When I store the initial win chart numbers
    And I increase the bet on 2
    Then All win chart numbers should increase by 3
    And I decrease the bet on 2
    Then All win chart numbers should increase by 1

  Scenario: Change the slot machine background
    Given The current slot machine background is set to 1
    When I click the change background button 2 times
    Then The current slot machine background is set to 3

  Scenario: Change the slot machine skin
    Given The current slot machine skin is set to 1
    When I click the change machine button 2 times
    Then The current slot machine skin is set to 3

  Scenario: Change the slot machine icons
    Given The current slot machine icons set is 1
    When I click the change icons button 2 times
    Then The current slot machine icons set is 3

  Scenario: Try the examples of slot machines
    Given The current slot machine background is set to 1
    And The current slot machine skin is set to 1
    And The current slot machine icons set is 1
    When I click the example 2
    Then The current slot machine background is set to 2
    Then The current slot machine skin is set to 1
    Then The current slot machine icons set is 2

  Scenario: Expand and collapse the questions in FAQ section
    When I click the first expand-collapse button in the FAQ section
    Then I should see the Yes, all the images you see can be directly replaced for anything you would like, by simply changing the files provided. answer
    And I click the first expand-collapse button in the FAQ section
    Then I should not see the Yes, all the images you see can be directly replaced for anything you would like, by simply changing the files provided. answer

  Scenario: Check the links in footer
    Then I should see the Slotmachine link in the footer
    Then I should see the Blackjack link in the footer
    Then I should see the Scratchcards link in the footer
    Then I should see the Wheel of fortune link in the footer

  Scenario: Write a message in chat
    When I click Send a message button
    Then I should see the chat window opened
    When I send a Hello message in the chat
    Then My Hello message should be sent
    And Contact form should appear in chat