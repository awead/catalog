require 'spec_helper'

describe "the navigation bar" do

  it "should show the facet toggle in search results" do
    execute_search "books"
    page.should have_css("span.glyphicon-list")
  end

  it "should not show the facet toggle in the show view" do
    visit catalog_path("5774581")
    page.should_not have_css("span.glyphicon-list")
  end

  it "should not show the facet toggle in bookmarks" do
    visit bookmarks_path
    page.should_not have_css("span.glyphicon-list")
  end

end
