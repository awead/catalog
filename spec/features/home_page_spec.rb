require 'spec_helper'

describe "Home page" do

  before :each do
    visit root_path
  end

  it "should display facets" do
    page.should have_content("Limit your search")
  end

  it "should have a search window" do
    page.should have_content("Search")
  end

  it "should have a browse window" do
    page.should have_content("Browse")
  end

  it "should have a modal display window" do
    page.should have_css("div#ajax-modal")
    page.should have_css("div.modal-dialog")
  end

  it "should not display the navbar" do
    page.should_not have_css("nav.navbar-inverse")
  end

end
