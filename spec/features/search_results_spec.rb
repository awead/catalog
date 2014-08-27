require 'spec_helper'

describe "Search results page", :type => :feature do

  before :each do
    execute_search "books"
  end

  it "should display the navbar" do
    expect(page).to have_css("nav.navbar-inverse")
    within(:css, "ul.navbar-right") do
      expect(page).to have_content("Start Over")
      expect(page).to have_content("Advanced Search")
      expect(page).to have_content("Account")
    end
  end

  it "should display pagination info" do
    within(:css, "#sortAndPerPage") do
      expect(page).to have_content("Previous")
      expect(page).to have_content("Next")
    end
    within(:css, "ul.pagination") do
      expect(page).to have_content("Previous")
      expect(page).to have_content("Next")
      expect(page).to have_content("1")
    end
  end

  it "should display my search terms" do
    within(:css, "#appliedParams") do
      expect(page).to have_content("You searched for:")
      expect(page).not_to have_content("Start over")
    end
  end

  it "should display menus for relevance sorting" do
    within(:css, "#sortAndPerPage") do
      expect(page).to have_content("Sort by relevance")
      expect(page).to have_content("per page")
    end
  end

  it "should not display the menu toggle buttons that are for show views" do
    expect(page).not_to have_css("span.glyphicon-info-sign")
    expect(page).not_to have_css("span.glyphicon-circle-arrow-right")
    expect(page).not_to have_css("span.glyphicon-circle-arrow-up")
    expect(page).not_to have_css("span.glyphicon-circle-arrow-left")
  end

  it "should display the status of an item" do
    expect(page).to have_content("checking status")
  end

  it "should have an icon for format" do
    expect(page).to have_xpath("//img[@alt='Book' and @src = '/assets/icons/book.png']")
  end

end
