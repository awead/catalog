require 'spec_helper'

describe "Blacklight customizations" do

  it "include customized language for the login page (BL-179)" do
    pending "need to correct routing error"
    visit user_session_path
    page.should have_content("Sign in")
    page.should have_content("Create an account to save and export your searches.")
  end

  it "include customized language for the signup page (BL-179)" do
    pending "need to correct routing error"
    visit user_session_path
    page.should have_content("Sign up")
    page.should have_content("By signing up, you can save your searches and export them later if needed.")
  end

end
