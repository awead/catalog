require 'spec_helper'

describe "Bib. facets", :type => :feature do

  it "should display links to facets in the index view (BL-265)" do
    visit root_path
    click_link("Website")
    within(:css, field_content_selector("ohlink_url")) { expect(page).to have_content("Connect to Database Online")  }
  end

  it "should show facets for limiting search (BL-14, BL-137)" do
    visit root_path
    within(:css, facet_selector("format"))      { expect(page).to have_content("Format") }
    within(:css, facet_selector("collection"))  { expect(page).to have_content("Collection Name") }
    within(:css, facet_selector("material"))    { expect(page).to have_content("Archival Material") }
    within(:css, facet_selector("name"))        { expect(page).to have_content("Name") }
    within(:css, facet_selector("subject"))     { expect(page).to have_content("Subject") }
    within(:css, facet_selector("genre"))       { expect(page).to have_content("Genre") }
    within(:css, facet_selector("series"))      { expect(page).to have_content("Event/Series") }
    within(:css, facet_selector("pub_date"))    { expect(page).to have_content("Publication Date") }
    within(:css, facet_selector("language"))    { expect(page).to have_content("Language") }
    expect(page).not_to have_content("Call Number")
  end

  it "shows terms for facets (BL-15)" do
    visit root_path
    within(:css, facet_selector("format")) do
      expect(page).to have_content("Book")
      expect(page).to have_content("Score")
      expect(page).to have_content("Website")
      expect(page).to have_content("Periodical")
      expect(page).to have_content("Video")
      expect(page).to have_content("Audio")
      expect(page).to have_content("CD/DVD-ROM")
      expect(page).to have_content("Archival Item")
      expect(page).to have_content("Archival Collection")
      expect(page).to have_content("Theses/Dissertations")
    end

  end

  it "should display facets for format (BL-268,BL-153,BL-154)" do
    visit root_path
    within(:css, facet_selector("format")) do
      expect(page).to have_content("Book")
      expect(page).to have_content("Theses/Dissertations")
      expect(page).to have_content("Audio")
      expect(page).to have_content("Score")
      expect(page).to have_content("Website")
      expect(page).to have_content("CD/DVD-ROM")
      expect(page).to have_content("Periodical")
      expect(page).to have_content("Video")    
    end
  end

  it "displays facets for CD/DVD-ROM (BL-250)" do
    visit root_path
    click_link("CD/DVD-ROM")
    expect(page).to have_content("77 million paintings [electronic resource] / by Brian Eno")
  end

  it "displays collection name facet (BL-14)" do
    visit root_path
    click_link "Art Collins Papers"
    within(:css, facet_selector("format")) do
      expect(page).to have_content("Format")
      expect(page).to have_content("Book")
    end
  end

  it "displays collection headings as name facet (BL-63)" do
    visit root_path
    expect(page).not_to have_content("Jeff Gold Collection (Rock and Roll Hall of Fame and Museum. Library and Archives)")
  end

  it "displays subject headings for library materials are under the topic facet" do
    visit root_path
    click_link "Inductee"
    click_link "Book"
    expect(page).to have_content("All you needed was love : the Beatles after the Beatles / John Blake")
  end

  it "includes a CD/DVD-ROM facet pulling in Enchanged music CDs (BL-268)" do
    visit root_path
    click_link "CD/DVD-ROM" 
    expect(page).to have_content("77 million paintings [electronic resource] / by Brian Eno")
    expect(page).not_to have_content("Viva Elvis [sound recording] : the album")
  end

  it "includes an audio facet for Enchanged music CDs (BL-268)" do
    visit root_path
    within(:css, facet_selector("format")) do
      click_link "Audio"
    end
    expect(page).to have_content("Viva Elvis [sound recording] : the album")
    expect(page).not_to have_content("The Pink Floyd encyclopedia / written & compiled by Vernon Fitch")
  end

  it "should link series headings (BL-100)" do
    skip "Link to facet is adding and extra ampersand"
    visit catalog_path("34407310")
    click_link "Atlantic & Atco remasters series"
    expect(page).to have_content("I never loved a man the way I love you [sound recording] / Aretha Franklin")
  end

end
