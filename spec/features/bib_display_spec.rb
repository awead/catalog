require 'spec_helper'

describe "Bib. display", :type => :feature do

  it "displays the bib record (BL-10)" do
    visit catalog_path("5774581")
    within(:css, field_title_selector("title")  ) { expect(page).to have_content("Title:")  }
    within(:css, field_content_selector("title")) { expect(page).to have_content("ASCAP supplementary index of performed compositions")  }
    expect(page).not_to have_content("Music United States Bibliography, Music United States Indexes, Songs United States Bibliography")
  end

  it "has links to subject headings (BL-10, BL-249)" do
    visit catalog_path("60373433")
    click_link("History and criticism")
    expect(page).to have_content("African American music : an introduction")
    expect(page).to have_content("The country blues")
  end

  it "has contributors field links (BL-10, BL-76)" do
    visit catalog_path("5774581")
    click_link("Gabler, Lee, donor")
    expect(page).to have_content("ASCAP index of performed compositions")
  end

  it "has related works field links (BL-10)" do
    visit catalog_path("74495434")
    click_link("Inside the Beatles vaults")
    expect(page).to have_content("Lifting latches / John C. Winn")
  end

  it "has donor information and collection linkage (BL-39)" do
    visit catalog_path("45008581")
    within(:css, field_title_selector("donor")  ) { expect(page).to have_content("Donor:")  }
    within(:css, field_content_selector("donor")) { expect(page).to have_content("Gift: Nikki Collins; LA.2007.01.001")  }
    within(:css, field_title_selector("collection")  ) { expect(page).to have_content("Archival Collection:")  }
    within(:css, field_content_selector("collection")) do
      within(:css, "a") {  expect(page).to have_content("Art Collins Papers")  }
    end
  end

  it "does not display rhlocal (BL-40)" do
    visit catalog_path("477045389")
    expect(page).not_to have_content("rhlocal")
  end

  it "displays uniform title from 240 field (BL-48)" do
    visit catalog_path("3536869")
    expect(page).to have_content("Songs. Selections")
  end

  it "displays resource links and urls (BL-48/42)" do
    visit catalog_path("33827620")
    within(:css, field_title_selector("resource_url")  ) { expect(page).to have_content("Online Resource:")  }
    within(:css, field_content_selector("resource_url")) do
      within(:css, "a") {  expect(page).to have_content("http://rockhall.com")  }
    end
  end

  it "displays multiple collection headings in 541$3 (BL-59)" do
    visit catalog_path("663101343")
    within(:css, field_title_selector("collection")  ) { expect(page).to have_content("Archival Collection:")  }
    within(:css, field_content_selector("collection")) do
      expect(page).to have_content("Northeast Ohio Popular Music Archives")
      expect(page).to have_content("Terry Stewart Collection")
    end
  end

  it "displays series Index should include MARC field 811 (BL-104)" do
    visit catalog_path("754843822")
    within(:css, field_content_selector("series")) do
      expect(page).to have_content("Annual induction ceremony (Rock and Roll Hall of Fame Foundation). ; 2003")
    end
  end

  it "displays standard links in the bib record display (BL-136)" do
    visit catalog_path("663101343")
    expect(page).to have_content("Email")
    expect(page).to have_content("Print")
    expect(page).to have_content("Export")
    expect(page).to have_content("View")
  end

  it "displays contents Coded as Enhanced 505s (BL-106)" do
    visit catalog_path("37138367")
    within(:css, field_title_selector("contents")  ) { expect(page).to have_content("Contents:")  }
    within(:css, field_content_selector("contents")) { expect(page).to have_content("I looked away")  }
  end

  it "should display OCLC bib record numbers (BL-144)" do
    visit catalog_path("458698760")
    within(:css, field_title_selector("oclc")  ) { expect(page).to have_content("OCLC No:")  }
    within(:css, field_content_selector("oclc")) { expect(page).to have_content("458698760")  }
  end

  it "should display Thesis Notes (BL-157, BL-158)" do
    visit catalog_path("35618845")
    within(:css, field_title_selector("note")  ) { expect(page).to have_content("Notes:")  }
    within(:css, field_content_selector("note")) { expect(page).to have_content("Photocopy. Ann Arbor, Mich. : UMI Dissertation Services, 2012. iv, 695 p. ; 23 cm")  }
  end

  it "should display subject headings" do
    visit catalog_path("10483424")
    expect(page).to have_content("Dylan, Bob, 1941-")
    expect(page).to have_content("Singers--United States--Biography")
    expect(page).not_to have_content("Dylan,Bob,--1941-")
  end

  it "displays eras in genre headings (BL-176)" do
    visit catalog_path("668192442")
    within(:css, field_content_selector("genre")) { expect(page).to have_content("Biography--Juvenile literature")  }
    within(:css, field_content_selector("genre")) { expect(page).not_to have_content("Biography Juvenile literature")  }
  end

  it "should display the image of the format type when looking at an item (BL-111)" do
    visit catalog_path("668192442")
    expect(page).to have_xpath("//img[@alt='Book' and @src = '/assets/icons/book.png']")
  end

  it "displays names entered as main entries and subjects are displaying under Contributors in bibs (BL-199)" do
    visit catalog_path("773370191")
    within(:css, field_content_selector("contributors")) { expect(page).to have_content("Moonalice (Musical group)")  }
    within(:css, field_content_selector("contributors")) { expect(page).not_to have_content("Moonalice (Musical group)Posters")  }
  end

  it "displays OhlinLink urls (BL-257, BL-259)" do
    visit catalog_path("40393214")
    within(:css, field_title_selector("ohlink_url")  ) { expect(page).to have_content("OhioLink Resource:")  }
    within(:css, field_content_selector("ohlink_url")) do
      within(:css, "a") { expect(page).to have_content("Connect to Database Online") }
    end
  end

  it "displays bib record link display text (BL-258, BL-260)" do
    visit catalog_path("811563836")
    within(:css, field_title_selector("resource_url")  ) { expect(page).to have_content("Online Resource:")  }
    within(:css, field_content_selector("resource_url")) do
      within(:css, "a") { expect(page).to have_content("Connect to resource") }
    end
  end

  it "displays linked author fields in the bib record" do
    visit catalog_path("668192442")
    within(:css, field_content_selector("author")) do
      within(:css, "a") { expect(page).to have_content("Golio, Gary") }
    end
  end

  it "displays RRHoF as contributor (BL-256)" do
    visit catalog_path("729256165")
    within(:css, field_content_selector("contributors")) { expect(page).to have_content("Rock and Roll Hall of Fame and Museum")  }
  end

  it "should display multiple 956 fields (BL-269)" do
    visit catalog_path("743766582")
    within(:css, field_content_selector("resource_url")) do
      expect(page).to have_content("Connect to resource")
      expect(page).to have_content("Oral history videos")
    end
  end

  it "should display names in subject headings (BL-249)" do
    visit catalog_path("601137822")
    within(:css, field_content_selector("subject")) { expect(page).to have_content("Lennon, John, 1940-1980--Assassination")  }
    within(:css, field_content_selector("subject")) { expect(page).to have_content("Lennon, John, 1940-1980--Death and burial")  }
  end

  it "displays records with null ids in marc records" do
    visit catalog_path("35618845")
    expect(page).to have_content("a history of Louisiana country music")
    visit catalog_path("706740")
    expect(page).to have_content("Watch out kids")
    visit catalog_path("b3416516")
    expect(page).to have_content("Making a scene")
  end

end
