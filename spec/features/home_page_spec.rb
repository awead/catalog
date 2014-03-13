require 'spec_helper'

describe "Home page" do

  before :each do
    visit root_path
  end

  it "should have a search banner" do
    within(:css, "#search_banner") do
      page.should have_content("Search")
      page.should have_content("Advanced Search")
      page.should have_content("Account Login")
    end
  end

  it "should have a column for browsing facets" do
    within(:css, "#sidebar") do
      page.should_not have_content("Browse")
    end
  end

  it "should have a modal display window" do
    page.should have_css("div#ajax-modal")
    page.should have_css("div.modal-dialog")
  end

  it "should not display the navbar" do
    page.should_not have_css("nav.navbar-inverse")
  end

  it "should have links for discovering content" do
    within(:css, "#content") do
      page.should_not have_content("Discover")
      page.should have_content("Resources")
      page.should have_content("User Guides")
    end
  end

end
