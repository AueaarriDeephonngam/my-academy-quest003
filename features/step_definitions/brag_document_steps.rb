Given('I am on the brag document page') do
  visit brag_document_path
end

When('I click on the Back to Quests button') do
  click_link 'Back to Quests'
end


Then('I should be on the quest management page') do
  expect(current_path).to eq(quests_path)
end

Then('I should see {string} in the page title') do |text|
  within('h1') do
    expect(page).to have_content(text)
  end
end

Then('I should see {string} button') do |button_text|
  expect(page).to have_link(button_text)
end

Then('I should see the brag document header') do
  expect(page).to have_selector('.brag-header')
end

Then('I should see {string} as the main heading') do |text|
  expect(page).to have_selector('h1', text: text)
end
