require 'spec_helper'

describe "EAD searching" do

  it "uses the collection facet field (BL-182)" do
    visit root_path
    click_link "Jeff Gold Collection"
    within(:css, facet_selector("format")) do
      page.should have_content("Archival Collection")
    end
  end

  it "should search by accession number (BL-49)" do
    execute_search "A2005.31.15"
    page.should have_content("Jermaine Rogers Posters")
    execute_search "A1994.34.7"
    page.should have_content("Curtis Mayfield Collection")
    page.should have_content("Photographs")
    execute_search "A1994.34.15"
    page.should have_content("Curtis Mayfield Collection")
    page.should have_content("Photographs")
  end

  it "should search accession number ranges (BL-302)" do
    execute_search "A2004.54.44"
    page.should have_content("Photographs")
  end

  it "should search for component archival materials (BL-55, BL-67)" do
    execute_search "Negatives"
    page.should have_content("Negatives")
    page.should have_content("Curtis Mayfield Collection")
    page.should_not have_content("Book: Poetic License: In Poem and Song")
  end

  it "should not return series components in results (BL-55, BL-67)" do
    execute_search "Correspondence"
    page.should have_content("Big Joe Turner Papers (Ahmet Ertegun Collection)")
  end

  it "should display archival component titles (BL-68)" do
    execute_search "Negatives"
    page.should_not have_content("Finding Aid")
    page.should have_content("Curtis Mayfield Collection")
    page.should have_content("Negatives and transparencies")
  end

  it "should suppress status display from ead-related items (BL-103)" do
    execute_search "Negatives"
    page.should_not have_content("Status:")
  end

  it "should seach the finding aid (BL-140)" do
    execute_search "rolling stones tour documents 1981"
    page.should have_content("1981 tour documents")
  end

  it "should use the title from the search reults in the finding aid (BL-148)" do
    execute_search "Johnny Otis"
    within(:css, "div#ARC-0060ref24") do
      within(:css, index_heading_selector) do
        page.should have_content("3rd Annual Long Beach Blues Festival: Taj Mahal, Little Milton, Ester Phillips, The Johnny Otis Show, Gatemouth Brown")
      end
    end
  end

  it "should not display series and subseries components in our search results (BL-224)" do
    execute_search "Series I: Flyers, 1980, 1989-1992"
    page.should_not have_css("div#ARC-0065ref42")
  end

  it "should not display titles for archival items in search results" do
    visit root_path
    click_link "Archival Item"
    within(:css, "div#RG-0008ref7") do
      page.should_not have_xpath('//dd', :text => '10,000 Maniacs', :visible => true)
    end
  end

end
