require 'rails_helper'

RSpec.feature 'Import Gmail messages', js: true, type: :feature do
  let(:credentials) { { email: ENV.fetch('GMAIL_EMAIL'), pass: ENV.fetch('GMAIL_PASSWORD'), limit: 3 } }

  before do
    # NOTICE: can use database cleaner gems instead
    ImportLock.destroy_all
  end

  scenario 'User imports Gmail messages' do
    visit root_path
    fill_in 'Email', with: credentials[:email]
    fill_in 'Password', with: credentials[:pass]
    fill_in 'Limit', with: 3
    click_button 'Import'
    expect(page).to have_content('Import Gmail messages')
    expect(page).to have_content('Imported: 4 of 4 messages', wait: 10)
  end

  scenario 'User imports Gmail messages with invalid credentials' do
    visit root_path
    fill_in 'Email', with: ''
    fill_in 'Password', with: ''
    fill_in 'Limit', with: 3
    click_button 'Import'
    expect(page).to have_content('Empty username or password')
    expect(page).to have_field('Email', with: '')
    expect(page).to have_field('Password', with: '')
  end

  scenario 'User want to run more than one import job' do
    2.times do
      visit root_path
      fill_in 'Email', with: credentials[:email]
      fill_in 'Password', with: credentials[:pass]
      fill_in 'Limit', with: 100
      click_button 'Import'
    end
    expect(page).to have_content('Import in progress. Please wait...')
  end
end
