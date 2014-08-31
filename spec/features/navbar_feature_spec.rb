require 'spec_helper'

describe "the navigation bar", :type => :feature do

  it "should show the facet toggle in search results" do
    execute_search "books"
    expect(page).to have_css("span.glyphicon-list")
  end

  it "should not show the facet toggle in the show view" do
    visit catalog_path("5774581")
    expect(page).not_to have_css("span.glyphicon-list")
  end

  it "should not show the facet toggle in bookmarks" do
    visit bookmarks_path
    expect(page).not_to have_css("span.glyphicon-list")
  end

end
