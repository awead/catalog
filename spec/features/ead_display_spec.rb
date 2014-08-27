require 'spec_helper'

describe "EAD display", :type => :feature do

  it "should have biographical notes and administrative histoy (BL-5)" do
    visit catalog_path("ARC-0105")
    click_link "Description"
    expect(page).to have_content("1911 May 18")
    expect(page).to have_content("Born Joseph Vernon Turner, Jr. in Kansas City, Mo.")
    expect(page).to have_content("1939")
    expect(page).to have_content("Releases first single")
    expect(page).to have_content("With Albert Ammons and Meade Lux Lewis, begins a five-year residency at New York's Cafe Society")
    expect(page).to have_content("Big Joe Turner was among the first to mix R&B with boogie-woogie")
    expect(page).to have_content("In the 1960s, after the first wave of rock and roll had died down")
    expect(page).to have_content("Sources")
    expect(page).to have_content("Big Joe Turner Biography")
  end

  it "should have date expressions in the first component level (BL-9)" do
    visit catalog_path("ARC-0105")
    click_link "Contents"
    expect(page).to have_content("Oversize materials, 1977-1985, undated")
  end

  it "should have date expressions in sub component level (BL-9) and accession numbers" do
    visit catalog_path("ARC-0105/ref42")
    expect(page).to have_content("Awards and certificates")
    expect(page).to have_content("Awards and certificates, 1976-1986")
    expect(page).to have_content("Accession Numbers:")
    expect(page).to have_content("A1994.4.10-A1994.4.22")
  end

  it "should have names (BL-7, BL-147)" do
    visit catalog_path("ARC-0058")
    click_link "Find More"
    expect(page).to have_content("Alternative rock music")
  end

  it "should have a dimensions note (BL-124)" do
    skip "May need to add additional display field for ChromaDepth"
    visit catalog_path("ARC-0065/ref10")
    expect(page).to have_content("Limited Print Run")
    expect(page).to have_content("Non-numbered edition of 200")
    expect(page).to have_content("Dimensions:")
    expect(page).to have_content("ChromaDepth 3D image with required glass for viewing")
    expect(page).to have_content("23")
    expect(page).to have_content("29")
    expect(page).to have_content("Location:")
    expect(page).to have_content("Drawer-Folder: FF.1.4-7, Object: 1")
  end

  it "should display a component and its immediate parent" do
    visit catalog_path("ARC-0065/ref62")
    expect(page).to have_content("Series I: Flyers, 1980, 1989-1992")
    expect(page).to have_content("Ultras with Dick Dale, 1992 August 1")
  end

  it "should show accession numbers (BL-118)" do
    visit catalog_path("ARC-0058/ref62")
    expect(page).to have_content("A2005.31.15")
  end

  it "should display italics (BL-33)" do
    visit catalog_path("ARC-0058")
    expect(page).to have_xpath('//em', :text => 'New Musical Express', :visible => true)
    expect(page).to have_xpath('//em', :text => 'Esquire', :visible => true)
  end

  it "should show separated materials notes (BL-43)" do
    visit catalog_path("ARC-0105")
    click_link "Description"
    expect(page).to have_content("Separated Materials")
    expect(page).to have_content("Biographical Note")
  end

  it "should show accruals under Colection History (BL-418)" do
    visit catalog_path("ARC-0006")
    click_link "Collection History"
    expect(page).to have_content("Accruals to the collection are located in Series VII.")
  end

  it "should show separated materials within Collection History (BL-418)" do
    visit catalog_path("ARC-0003")
    click_link "Collection History"
    expect(page).to have_content("Some print and audiovisual materials have been transferred to the library collection.")
  end

  it "should show access restrictions within Access and Use" do
    visit catalog_path("ARC-0003")
    click_link "Access and Use"
    expect(page).to have_content("Collection is open for research")
  end

  it "should show existence and Location of Originals (BL-117)" do
    visit catalog_path("ARC-0006/ref641")
    expect(page).to have_content("original plaque")
  end

  it "should show physical description (BL-119)" do
    visit catalog_path("ARC-0006/ref725")
    expect(page).to have_content("Trimmed")
  end

  it "should show language of Materials, Museum Acc. #, Separated Materials (BL-118)" do
    visit catalog_path("ARC-0006/ref690")
    expect(page).to have_content("Language: French")
    expect(page).to have_content("A2010.1.18")
    expect(page).to have_content("Item on exhibit. Consult the Library and Archives staff in advance of your visit for additional information.")
  end

  it "should show custodial history (BL-120, BL-130)" do
    visit catalog_path("ARC-0037")
    click_link "Description"
    expect(page).to have_content("Custodial History")
    expect(page).to have_content("The Jeff Gold Collection was received by the Rock and Roll Hall of Fame Museum")
  end

  it "should show dates (BL-164) and accruals notes (BL-155)" do
    visit catalog_path("ARC-0037")
    within(:css, "span.unitdate") do
      expect(page).to have_content("Inclusive, 1938-2010, undated")
    end
    click_link "Description"
    expect(page).to have_content("Accruals")
  end

  it "should displaying multiple copies of an archival item (BL-202)" do
    visit catalog_path("ARC-0006/ref216")
    within(:css, field_content_selector("location")) do
      expect(page).to have_content("Box: 5, Folder: 1, Object: 4")
      expect(page).to have_content("Box: 1B, Folder: 22, Object: 4")
    end
    within(:css, field_content_selector("material")) do
      expect(page).to have_content("Original Copy")
      expect(page).to have_content("Access Copy")
    end
  end

  it "should show processing information note (BL-196)" do
    visit catalog_path("ARC-0003")
    expect(page).to have_content("Processing Information")
    expect(page).to have_content("Processed by Christine Borne, Project Archivist. Completed on June 1, 2010.")
  end

  it "should have AT genre facet display (BL-195)" do
    visit catalog_path("ARC-0005")
    click_link "Find More"
    expect(page).to have_content("Clippings (Books, newspapers, etc.)")
    expect(page).to have_content("Photographs")
  end

  it "should show Additional chronologies (BL-194)" do
    visit catalog_path("ARC-0005")
    click_link "Description"
    expect(page).to have_content("First meeting of the Organization")
    expect(page).to have_content("Incorporated as a Minnesota non-profit organization")
    expect(page).to have_content("Holds first annual Eddie Cochran Weekend in Alberta Lea, Minn")
  end

  it "should show title nodes in ead (BL-209)" do
    skip "AT not exporting XML correctly"
    visit catalog_path("ARC-0026")
    click_link "Description"
    expect(page).to have_xpath('//em', :text => 'Normal As The Next Guy', :visible => true)
  end

  it "should show items in the sidebar" do
    visit catalog_path("ARC-0037")
    within(:css, ".nav-stacked") do
      expect(page).to have_content("Summary")
      expect(page).to have_content("Description")
      expect(page).to have_content("Collection History")
      expect(page).to have_content("Access and Use")
      expect(page).to have_content("Find More")
      expect(page).to have_content("Contents")
      expect(page).to have_content("Search Collection")
    end
  end

  it "should show name Headings listed as 'Creator' (BL-294)" do
    visit catalog_path("ARC-0258")
    click_link "Find More"
    expect(page).to have_content("Diltz, Henry")
  end

  it "should include corpname and persname in the headings (BL-335)" do
    visit catalog_path("ARC-0058")
    click_link "Find More"
    expect(page).to have_content("Morrison, Jim, 1943-1971")
    expect(page).to have_content("Denali (Musical group)")
  end

  it "should display bibliographies from finding aids (BL-325)" do
    visit catalog_path("ARC-0161")
    click_link "Description"
    expect(page).to have_content("Bibliography")
    expect(page).to have_content("All Music Guide. Accessed February 4, 2013. http://www.allmusic.com/.")
    expect(page).to have_content("Doo-Wop: Biography, Groups and Discography. Accessed February 4, 2013. http://doo-wop.blogg.org/.")
  end

  it "should display summary information" do
    visit catalog_path("ARC-0003")
    expect(page).to have_content("Summary")
    within(:css, "dl#geninfo") do
      expect(page).to have_content("Dates:")
      expect(page).to have_content("Size:")
      expect(page).to have_content("Collection Number:")
      expect(page).to have_content("Language(s):")
      expect(page).to have_content("Abstract:")
      expect(page).to have_content("Finding Aid Permalink:")
    end
    expect(page).not_to have_content("Colletion Overview")
  end

  it "should display field in Description tab" do
    visit catalog_path("ARC-0064")
    click_link "Description"
    expect(page).to have_content("Administrative History")
    visit catalog_path("ARC-0161")
    click_link "Description"
    expect(page).to have_content("Biographical Note")
    expect(page).to have_content("Bibliography")
    visit catalog_path("ARC-0001")
    click_link "Description"
    expect(page).to have_content("Scope and Contents note")
  end

  it "should display fields in the Collection History tab" do
    visit catalog_path("ARC-0006")
    click_link "Collection History"
    expect(page).to have_content("Custodial History")
    expect(page).to have_content("Accruals")
    expect(page).to have_content("Separated Materials")
  end

  it "should display fields in the Access and Use tab" do
    visit catalog_path("ARC-0080")
    click_link "Access and Use"
    expect(page).to have_content("Access Restrictions")
    expect(page).to have_content("Use Restrictions")
  end

  it "should display headings" do
    visit catalog_path("ARC-0003")
    click_link "Find More"
    expect(page).to have_content("Names:")
    expect(page).to have_content("Subjects:")
    expect(page).to have_content("Formats:")
  end

  it "should have a tab for searchign within the collection" do
    visit catalog_path("ARC-0003")
    click_link "Search Collection"
    expect(page).to have_content("Search Collection")
  end

  it "should display a label for digital content" do
    visit catalog_path("RG-0010/ref42")
    expect(page).to have_content("Online")
  end

  it "should display the full finding aid" do
    visit catalog_path("ARC-0037", {:full => true})
    expect(page).to have_content("Color pinup")
  end

  it "should toggle the display between full and default finding aid views" do
    visit catalog_path("ARC-0037")
    within(:css, "#record_controls") do
      expect(page).to have_content("Full")
    end
    visit catalog_path("ARC-0037", {:full => true})
    within(:css, "#record_controls") do
      expect(page).to have_content("Default")
    end
  end

  it "should display the list view of components' archival material type in parenthesis" do
    visit catalog_path("ARC-0037/ref2214")
    expect(page).to have_content("(Moving Images)")
  end

  it "should display heading field for archival items (BL-422)" do
    visit catalog_path("ARC-0105/ref61")
    expect(page).to have_content("1985-1990")
  end

end
