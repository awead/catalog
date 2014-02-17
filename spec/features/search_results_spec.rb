require 'spec_helper'

describe "Search results page" do

  before :each do
    execute_search "books"
  end

  it "should display the navbar" do
    page.should have_css("nav.navbar-inverse")
    within(:css, "ul.navbar-right") do
      page.should have_content("Start Over")
      page.should have_content("More Options")
      page.should have_content("Account")
    end
  end

  it "should display pagination info" do
    within(:css, "#sortAndPerPage") do
      page.should have_content("Previous")
      page.should have_content("Next")
    end
    within(:css, "ul.pagination") do
      page.should have_content("Previous")
      page.should have_content("Next")
      page.should have_content("1")
    end
  end

  it "should display my search terms" do
    within(:css, "#appliedParams") do
      page.should have_content("You searched for:")
      page.should_not have_content("Start over")
    end
  end

  it "should display menus for relevance sorting" do
    within(:css, "#sortAndPerPage") do
      page.should have_content("Sort by relevance")
      page.should have_content("per page")
    end
  end

  it "should not display the menu toggle buttons that are for show views" do
    page.should_not have_css("span.glyphicon-info-sign")
    page.should_not have_css("span.glyphicon-circle-arrow-right")
    page.should_not have_css("span.glyphicon-circle-arrow-up")
    page.should_not have_css("span.glyphicon-circle-arrow-left")
  end

  it "should display the status of an item" do
    page.should have_content("checking status")
  end

  it "should have an icon for format" do
    page.should have_xpath("//img[@alt='Book' and @src = '/assets/icons/book.png']")
  end

end
