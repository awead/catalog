require 'spec_helper'

describe "Call number features" do

  it "derive call numbers for display (BL-41)" do
    visit catalog_path("45008581")
    page.should have_content("ML420.L466 S54 2000")
    page.should_not have_content("ML420.L38 A5 2000")
  end

  it "displays call numbers (BL-296)" do
    visit catalog_path("785870275")
    within(:css, field_content_selector("lc_callnum")) { page.should have_content("ML421.B5338 B53P4 2013") }
    execute_search "Black Sabbath"
    within(:css, "div#785870275") do
      within(:css, field_content_selector("lc_callnum")) { page.should have_content("ML421.B5338 B53P4 2013") }
    end
  end

  it "displays Rockhall call numbers only (BL-307)" do
    execute_search "quincy jones"
    within(:css, "div#46240374") do
      within(:css, field_content_selector("lc_callnum")) { page.should have_content("ML429.J66 A3 2001") }
      within(:css, field_content_selector("lc_callnum")) { page.should_not have_content("ML419.J7A3 2001") }
    end
  end

  it "should gather mulitple $a subfields for call number (BL-336)" do
    execute_search "Early days"
    within(:css, "div#43733389") do
      within(:css, field_content_selector("lc_callnum")) { page.should have_content("CD LED EARL 2000") }
    end
  end

  it "displays call numbers from multiple 945 fields (BL-342)" do
    visit root_path
    within(:css, facet_selector("format")) do
      click_link "Book"
    end
    page.should have_content("ML418.K466 A3 1992")
    page.should_not have_content("ML418.K466 ML418.K466 A3 1992")
  end

  it "displays call numbers for juvenile titles (BL-341)" do
    visit catalog_path("489441388")
    within(:css, field_content_selector("lc_callnum")) { page.should have_content("ML3534 .G85 2011") }
  end

  it "displays call numbers for reference titles (BL-347)" do
    visit catalog_path("34241584")
    within(:css, field_content_selector("lc_callnum")) { page.should have_content("ML156.4.P6 M42 1995") }
  end

end
