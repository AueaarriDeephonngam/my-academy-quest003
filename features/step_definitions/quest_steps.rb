Given('I am on the quest management page') do
  visit quests_path
end

Given('I visit the quest page with no existing quests') do
  Quest.delete_all
  visit quests_path
end

When('I visit the quest page') do
  visit quests_path
end

When('I refresh the page') do
  visit current_path
end


Then('I should see {string}') do |text|
  expect(page).to have_content(text)
end

Then('I should not see {string} in the quest list') do |text|
  within('#quest-list') do
    expect(page).not_to have_content(text)
  end
end

Then('I should see {string} in the quest list') do |text|
  within('#quest-list') do
    expect(page).to have_content(text)
  end
end

Then('I should see {string} in the quest count') do |text|
  within('#quest-count') do
    expect(page).to have_content(text)
  end
end

Then('I should see the add quest form') do
  expect(page).to have_selector('.add-quest-form')
  expect(page).to have_selector('input[name="quest[title]"]')
  expect(page).to have_selector('button[type="submit"]')
end


When('I fill in the quest title with {string}') do |title|
  fill_in 'quest[title]', with: title
end

When('I click the add quest button') do
  find('button.add-btn').click
end

When('I try to add a quest with empty title') do
  fill_in 'quest[title]', with: ''
  find('button.add-btn').click
end

Then('the quest should not be created') do
  expect(Quest.count).to eq(0)
end

Then('I should remain on the quest page') do
  expect(current_path).to eq(quests_path)
end


Given('I have a quest titled {string}') do |title|
  Quest.create!(title: title, done: false)
  visit current_path if current_path == quests_path
end

Given('I have a completed quest titled {string}') do |title|
  Quest.create!(title: title, done: true)
  visit current_path if current_path == quests_path
end

Given('I have added a quest titled {string}') do |title|
  visit quests_path
  fill_in 'quest[title]', with: title
  click_button 'Add Quest'
end

Given('I have the following quests:') do |table|
  Quest.delete_all
  table.hashes.each do |quest_data|
    created_at = case quest_data['created_at']
    when '3 days ago'
                   3.days.ago
    when '1 day ago'
                   1.day.ago
    when '1 hour ago'
                   1.hour.ago
    else
                   Time.current
    end

    Quest.create!(
      title: quest_data['title'],
      done: quest_data['done'] == 'true',
      created_at: created_at
    )
  end
end


When('I check the checkbox for {string}') do |quest_title|
  quest_item = find('.quest-item', text: quest_title)
  within(quest_item) do
    checkbox_label = find('.quest-checkbox')
    checkbox_label.click

    sleep 1
  end
end

When('I uncheck the checkbox for {string}') do |quest_title|
  quest_item = find('.quest-item', text: quest_title)
  within(quest_item) do
    checkbox_label = find('.quest-checkbox')
    checkbox_label.click

    sleep 1
  end
end

When('I click the delete button for {string}') do |quest_title|
  quest_item = find('.quest-item', text: quest_title)
  within(quest_item) do
    find('.delete-btn', visible: false).click
  end
end


Then('the quest {string} should be marked as completed') do |quest_title|
  sleep 1
  quest_item = find('.quest-item', text: quest_title)
  within(quest_item) do
    expect(find('input[type="checkbox"]', visible: false)).to be_checked
  end

  quest = Quest.find_by(title: quest_title)
  expect(quest.done).to be true
end

Then('the quest {string} should be marked as not completed') do |quest_title|
  quest_item = find('.quest-item', text: quest_title)
  within(quest_item) do
    expect(find('input[type="checkbox"]')).not_to be_checked
    expect(quest_item).not_to have_css('.completed')
  end
end

Then('the quest {string} should be marked as incomplete') do |quest_title|
  quest_item = find('.quest-item', text: quest_title)
  within(quest_item) do
    expect(find('input[type="checkbox"]', visible: false)).not_to be_checked
    expect(quest_item).not_to have_css('.completed')
  end
end

Then('I should not see the quest {string}') do |quest_title|
  expect(page).not_to have_css('.quest-item', text: quest_title)
end


Then('I should see quests in the following order:') do |table|
  quest_titles = table.raw.flatten
  quest_items = all('.quest-item .quest-title')

  quest_titles.each_with_index do |expected_title, index|
    expect(quest_items[index]).to have_content(expected_title)
  end
end


When('I click on {string} button') do |button_text|
  click_link button_text
end

Then('I should be on the brag document page') do
  expect(current_path).to eq('/brag_document')
end


Then('I should see {string} in the quest list immediately') do |text|
  within('#quest-list') do
    expect(page).to have_content(text)
  end
end

Then('the quest form should be cleared') do
  expect(find('input[name="quest[title]"]').value).to be_empty
end

Then('the page should not have refreshed') do
  expect(page).to have_current_path(quests_path, ignore_query: true)
end

Then('the quest {string} should be visually marked as completed immediately') do |quest_title|
  sleep 1
  quest_item = find('.quest-item', text: quest_title)

  within(quest_item) do
    expect(find('input[type="checkbox"]', visible: false)).to be_checked
  end

  quest = Quest.find_by(title: quest_title)
  expect(quest.done).to be true
end

Then('the quest {string} should disappear immediately') do |quest_title|
  expect(page).not_to have_content(quest_title)
end

Then('the quest count should update immediately') do
  expect(page).to have_selector('#quest-count')
end

Then('I should still see {string} in the quest list') do |text|
  within('#quest-list') do
    expect(page).to have_content(text)
  end
end

Then('the quest count should remain accurate') do
  total_quests = Quest.count
  completed_quests = Quest.where(done: true).count

  within('#quest-count') do
    if total_quests == 1
      expect(page).to have_content("1 quest")
    else
      expect(page).to have_content("#{total_quests} quests")
    end
    expect(page).to have_content("#{completed_quests} completed")
  end
end
