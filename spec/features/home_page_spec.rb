require 'spec_helper'

describe "Home page", :type => :feature do

  before :each do
    visit root_path
  end

  it "should have a search banner" do
    within(:css, "#search_banner") do
      expect(page).to have_content("Search")
      expect(page).to have_content("Advanced Search")
      expect(page).to have_content("Account Login")
    end
  end

  it "should have a column for browsing facets" do
    within(:css, "#sidebar") do
      expect(page).not_to have_content("Browse")
    end
  end

  it "should have a modal display window" do
    expect(page).to have_css("div#ajax-modal")
    expect(page).to have_css("div.modal-dialog")
  end

  it "should not display the navbar" do
    expect(page).not_to have_css("nav.navbar-inverse")
  end

  it "should have links for discovering content" do
    within(:css, "#content") do
      expect(page).not_to have_content("Discover")
      expect(page).to have_content("Resources")
      expect(page).to have_content("User Guides")
    end
  end

end
