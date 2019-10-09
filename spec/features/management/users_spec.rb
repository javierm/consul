require 'rails_helper'

feature 'Users' do

  background do
    login_as_manager
  end

  scenario 'Create a level 3 user with email from scratch', :broken do
    visit management_document_verifications_path
    fill_in 'document_verification_document_number', with: '12345678Z'

    click_button 'Check document'

    expect(page).to have_content "Please introduce the email used on the account"

    click_link 'Create a new account'

    fill_in 'user_username', with: 'pepe'
    fill_in 'user_email', with: 'pepe@gmail.com'
    select_date '31-December-1980', from: 'user_date_of_birth'

    click_button 'Create user'

    expect(page).to have_content "We have sent an email"
    expect(page).not_to have_content "Autogenerated password is"

    user = User.find_by(email: 'pepe@gmail.com')

    expect(user).to be_level_three_verified
    expect(user).to be_residence_verified
    expect(user).not_to be_confirmed
    expect(user.date_of_birth).to have_content Date.new(1980, 12, 31)

    sent_token = /.*confirmation_token=(.*)".*/.match(ActionMailer::Base.deliveries.last.body.to_s)[1]
    visit user_confirmation_path(confirmation_token: sent_token)

    expect(page).to have_content "Confirming the account with email"

    fill_in 'user_password', with: '12345678'
    fill_in 'user_password_confirmation', with: '12345678'

    click_button 'Confirm'

    expect(user.reload).to be_confirmed

    expect(page).to have_content "Your account has been confirmed."
  end

  scenario 'Create a level 3 user without email from scratch', :broken do
    visit management_document_verifications_path
    fill_in 'document_verification_document_number', with: '12345678Z'
    click_button 'Check document'

    expect(page).to have_content "Please introduce the email used on the account"

    click_link 'Create a new account'

    fill_in 'user_username', with: 'Kelly Sue'
    fill_in 'user_email', with: ''
    select_date '31-December-1980', from: 'user_date_of_birth'

    click_button 'Create user'

    expect(page).not_to have_content "We have sent an email"
    expect(page).to have_content "Autogenerated password is"

    user = User.find_by(username: 'Kelly Sue')

    expect(user).to be_level_three_verified
    expect(user).to be_residence_verified
    expect(user).to be_confirmed
    expect(user.date_of_birth).to have_content Date.new(1980, 12, 31)
  end

  scenario 'Delete a level 2 user account from document verification page', :js, :broken do
    level_2_user = create(:user, :level_two, document_number: "12345678Z")

    visit management_document_verifications_path
    fill_in 'document_verification_document_number', with: '12345678Z'
    click_button 'Check document'

    expect(page).not_to have_content "This user account is already verified."
    expect(page).to have_content "This user can participate in the website with the following permissions"

    click_link "Delete user"
    accept_confirm { click_link "Delete account" }

    expect(page).to have_content "User account deleted."

    expect(level_2_user.reload.erase_reason).to eq "Deleted by manager: manager_user_#{Manager.last.user_id}"

    visit management_document_verifications_path
    fill_in 'document_verification_document_number', with: '12345678Z'
    click_button 'Check document'

    expect(page).to have_content "no user account associated to it"
  end

end