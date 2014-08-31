require 'spec_helper'

describe "Blacklight customizations", :type => :feature do

  it "include customized language for the login page (BL-179)" do
    skip "need to correct routing error"
    visit user_session_path
    expect(page).to have_content("Sign in")
    expect(page).to have_content("Create an account to save and export your searches.")
  end

  it "include customized language for the signup page (BL-179)" do
    skip "need to correct routing error"
    visit user_session_path
    expect(page).to have_content("Sign up")
    expect(page).to have_content("By signing up, you can save your searches and export them later if needed.")
  end

end
