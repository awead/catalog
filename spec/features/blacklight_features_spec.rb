require 'spec_helper'

describe "Blacklight features", :type => :feature do

  it "should show search history page" do
    visit search_history_path
    expect(page).to have_content("You have no search history")
  end

  it "should show us our saved searches" do
    visit saved_searches_path
    expect(page).to have_content("Please log in to manage and view your saved searches")
  end

  it "should show us the advanced search page" do
    visit advanced_search_path
    expect(page).to have_content("More Search Options")
  end

end
