###GIVEN###
Given /^The test page is opened$/ do
  page.current_window.maximize
  visit "http://#{$config['server']}/"
end

###WHEN###
When /^I press Spin button under the slot machine$/ do
  $total_spins_count = find(TOTAL_SPINS_COUNT).text.to_i
  find(SPIN_BUTTON).click
end

When /^I store the initial win chart numbers$/ do
  $win_chart = []
  all(PAYOUT_NUM).each do |el|
    curr_win = el.text.to_i
    $win_chart.push(curr_win)
  end
end

When /^I (increase|decrease) the bet on (.*?)$/ do |direction,quantity|
  #increase or deacrease the bet
  if direction == 'increase'
    arrow = INCREASE_BET
  else
    arrow = DECREASE_BET
  end
  quantity = quantity.to_i
  quantity.times do
    find(arrow).click
  end
end

When /^I click the change (background|machine|icons) button (.*?) times$/ do |button, quantity|
  if button == 'background'
    el = CHANGE_BACKGROUND_BUTTON
  elsif button == 'machine'
    el = CHANGE_MACHINE_BUTTON
  else
    el = CHANGE_ICONS_BUTTON
  end
  quantity = quantity.to_i
  quantity.times do
    find(el).click
  end
end

When /^I click the example (.*?)$/ do |example|
  find("div.examples [data-example='#{example}']").click
end

When /^I click the first expand-collapse button in the FAQ section$/ do
  all(EXPAND_COLLAPSE_BUTTON)[0].click
end

When /^I click Send a message button$/ do
  switch_to_frame find(CHAT_FRAME)
  find(CHAT_BUTTON).click
  switch_to_frame(:parent)
end

When /^I send a (.*?) message in the chat$/ do |message|
  switch_to_frame find(CHAT_FRAME)
  find(CHAT_TEXT_FIELD).send_keys(message)
  find(CHAT_SEND_BUTTON).click
  switch_to_frame(:parent)
end

###THEN###
Then /^I should see the result of the spinning$/ do
  expect(find(SPIN_BUTTON_DISABLED)).to be_truthy
  curr_spin_count = find(TOTAL_SPINS_COUNT).text.to_i
  expect($total_spins_count - curr_spin_count).to eq(1)
end

Then /^All win chart numbers should increase by (.*?)$/ do |times|
  #store the current win chart numbers for comparison
  curr_wins = []
  all(PAYOUT_NUM).each do |el|
    curr_win = el.text.to_i
    curr_wins.push(curr_win)
  end

  #check each number in array has increased by required number of times
  comparison_results = $win_chart.zip(curr_wins).map { |x, y| y == x*times.to_i }
  comparison_results.each do |el|
    expect(el).to be true
  end
end

Then /^The current slot machine background is set to (.*?)$/ do |background_num|
  el = CHANGEABLE_BACKGROUND + background_num
  expect(find(el, visible: true)).to be_truthy
end

Then /^The current slot machine skin is set to (.*?)$/ do |skin_num|
  skin = find(SLOTMACHINE_WRAPPER)['class']
  expect(skin).to include("slotMachine#{skin_num}")
end

Then /^The current slot machine icons set is (.*?)$/ do |icons_num|
  icons = find(SLOTMACHINE_WRAPPER)['class']
  expect(icons).to include("reelSet#{icons_num}")
end

Then /^I (should|should not) see the (.*?) answer$/ do |expectation, answer_text|
  if expectation == 'should'
    expect(find(FAQ_ANSWER).text).to eq(answer_text)
  else
    expect(page).to have_no_css(FAQ_ANSWER)
  end
end

Then /^I should see the (.*?) in the footer$/ do |link|
  link = link.upcase.gsub(' ', '_')
  link = Object.const_get(link)
  expect(find(link)).to be_truthy
end

Then /^I should see the chat window opened$/ do
  switch_to_frame find(CHAT_FRAME)
  expect(find(CHAT_HEADER).text).to eq('How can we help you?')
  switch_to_frame(:parent)
end

Then /^My (.*?) message should be sent$/ do |message|
  switch_to_frame find(CHAT_FRAME)
  expect(find(CHAT_SENT_MESSAGE).text).to eq(message)
  switch_to_frame(:parent)
end

Then /^Contact form should appear in chat$/ do
  switch_to_frame find(CHAT_FRAME)
  expect(find(CHAT_CONTACT_FORM)).to be_truthy
  expect(find(CHAT_CONTACT_FORM_GREETING).text).to eq('Add your name and email to make sure you see our reply:')
  switch_to_frame(:parent)
end