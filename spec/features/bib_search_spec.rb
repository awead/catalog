require 'spec_helper'

describe "Bib. searching" do

  it "should search rhlocal (BL-40)" do
    execute_search "rhlocal"
    page.should have_content("Lifting latches / John C. Winn")
  end

  it "should hightlight terms in facet names (BL-311)" do
    execute_search "Derek and the Dominos"
    within(:css, index_heading_selector) do
      page.should have_css("span.label-info")
    end
    within(:css, field_content_selector("author")) do
      page.should have_css("span.label-info")
    end
  end

  it "should serach for related works as titles (BL-64 and BL-65)" do
    execute_search "in my life", "Title"
    page.should have_content("Rubber soul [sound recording] / the Beatles")
  end

  it "should ignore stop words in searches (BL-82)" do
    execute_search "legalize it"
    page.should have_content("Legalize it [sound recording] / Peter Tosh")
  end

  it "should search for titles with special characters" do
    execute_search "Pere"
    page.should have_content("The modern dance [sound recording] / Père Ubu")
    execute_search "Père"
    page.should have_content("The modern dance [sound recording] / Père Ubu")
  end

  it "has searchable oclc bib record numbers (BL-145)" do
    execute_search "458698760", "Oclc No."
    page.should have_content("John Coltrane : his life and music / Lewis Porter")
  end

  it "has searchable contributor fields (BL-243)" do
    execute_search "Elvis Presley", "Name"
    page.should have_content("Shake, rattle & turn that noise down!")
  end

  it "has searchable call numbers (BL-327)" do
    execute_search "ML3534 .A48 1970", "Call No."
    page.should have_content("Altamont : death of innocence in the Woodstock nation")
  end

  it "seraching for resource links (BL-300)" do
    execute_search "covach"
    page.should have_content("Understanding rock : essays in musical analysis / edited by John Covach & Graeme M. Boone")
  end

  it "display holdings links in search results (BL-301)" do
    execute_search "2260489"
    page.should have_content("Click for Holdings")
  end
  
  it "should highlight search terms (BL-179)" do
    execute_search "Elvis"
    within(:css, "div#669770588") do
      within(:css, index_heading_selector) do
        within(:css, "span.label-info") { page.should have_content("Elvis") }
      end
    end
  end

end
