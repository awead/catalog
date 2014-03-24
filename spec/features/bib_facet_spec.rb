require 'spec_helper'

describe "Bib. facets" do

  it "should display links to facets in the index view (BL-265)" do
    visit root_path
    click_link("Website")
    within(:css, field_content_selector("ohlink_url")) { page.should have_content("Connect to Database Online")  }
  end

  it "should show facets for limiting search (BL-14, BL-137)" do
    visit root_path
    within(:css, facet_selector("format"))      { page.should have_content("Format") }
    within(:css, facet_selector("collection"))  { page.should have_content("Collection Name") }
    within(:css, facet_selector("material"))    { page.should have_content("Archival Material") }
    within(:css, facet_selector("name"))        { page.should have_content("Name") }
    within(:css, facet_selector("subject"))     { page.should have_content("Subject") }
    within(:css, facet_selector("genre"))       { page.should have_content("Genre") }
    within(:css, facet_selector("series"))      { page.should have_content("Event/Series") }
    within(:css, facet_selector("pub_date"))    { page.should have_content("Publication Date") }
    within(:css, facet_selector("language"))    { page.should have_content("Language") }
    page.should_not have_content("Call Number")
  end

  it "shows terms for facets (BL-15)" do
    visit root_path
    within(:css, facet_selector("format")) do
      page.should have_content("Book")
      page.should have_content("Score")
      page.should have_content("Website")
      page.should have_content("Periodical")
      page.should have_content("Video")
      page.should have_content("Audio")
      page.should have_content("CD/DVD-ROM")
      page.should have_content("Archival Item")
      page.should have_content("Archival Collection")
      page.should have_content("Theses/Dissertations")
    end

  end

  it "should display facets for format (BL-268,BL-153,BL-154)" do
    visit root_path
    within(:css, facet_selector("format")) do
      page.should have_content("Book")
      page.should have_content("Theses/Dissertations")
      page.should have_content("Audio")
      page.should have_content("Score")
      page.should have_content("Website")
      page.should have_content("CD/DVD-ROM")
      page.should have_content("Periodical")
      page.should have_content("Video")    
    end
  end

  it "displays facets for CD/DVD-ROM (BL-250)" do
    visit root_path
    click_link("CD/DVD-ROM")
    page.should have_content("77 million paintings [electronic resource] / by Brian Eno")
  end

  it "displays collection name facet (BL-14)" do
    visit root_path
    click_link "Art Collins Papers"
    within(:css, facet_selector("format")) do
      page.should have_content("Format")
      page.should have_content("Book")
    end
  end

  it "displays collection headings as name facet (BL-63)" do
    visit root_path
    page.should_not have_content("Jeff Gold Collection (Rock and Roll Hall of Fame and Museum. Library and Archives)")
  end

  it "displays subject headings for library materials are under the topic facet" do
    visit root_path
    click_link "Inductee"
    click_link "Book"
    page.should have_content("All you needed was love : the Beatles after the Beatles / John Blake")
  end

  it "includes a CD/DVD-ROM facet pulling in Enchanged music CDs (BL-268)" do
    visit root_path
    click_link "CD/DVD-ROM" 
    page.should have_content("77 million paintings [electronic resource] / by Brian Eno")
    page.should_not have_content("Viva Elvis [sound recording] : the album")
  end

  it "includes an audio facet for Enchanged music CDs (BL-268)" do
    visit root_path
    within(:css, facet_selector("format")) do
      click_link "Audio"
    end
    page.should have_content("Viva Elvis [sound recording] : the album")
    page.should_not have_content("The Pink Floyd encyclopedia / written & compiled by Vernon Fitch")
  end

  it "should link series headings (BL-100)" do
    pending "Link to facet is adding and extra ampersand"
    visit catalog_path("34407310")
    click_link "Atlantic & Atco remasters series"
    page.should have_content("I never loved a man the way I love you [sound recording] / Aretha Franklin")
  end

end
