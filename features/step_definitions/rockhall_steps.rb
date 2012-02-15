Then /^I should see a facet for "([^"]*)"$/ do |arg1|
  regexp = Regexp.new(arg1)

  if page.respond_to? :should
    page.should have_xpath('//h3', :text => regexp)
  else
    assert page.has_xpath?('//h3', :text => regexp)
  end

end

Then /^I should not see a facet for "([^"]*)"$/ do |arg1|
  regexp = Regexp.new(arg1)

  if page.respond_to? :should
    page.should_not have_xpath('//h3', :text => regexp)
  else
    assert !page.has_xpath?('//h3', :text => regexp)
  end

end

Then /^I should see the facet term "([^"]*)"$/ do |arg1|
  regexp = Regexp.new(arg1)

  if page.respond_to? :should
    page.should have_xpath("//*/a[contains(@class, 'facet_select')]", :text => regexp)
  else
    assert page.has_xpath?("//*/a[contains(@class, 'facet_select')]", :text => regexp)
  end

end

Then /^I should see a link to "([^"]*)"$/ do |arg1|
  response.should have_selector("a", :href=>path_to(arg1))
end

Then /^I should not see a link to "([^\"]*)"$/ do |arg1|
  response.should_not have_selector("a", :href=>path_to(arg1))
end

Then /^I should be able to follow "([^"]*)"$/ do |link|
  click_link(link)
end

Then /^I should see the field title "([^"]*)" contain "([^"]*)"$/ do |arg1, arg2|
  page.should have_xpath("//*/dt[contains(@class, arg1)]", :text => arg2)
end

Then /^I should see the field content "([^"]*)" contain "([^"]*)"$/ do |arg1, arg2|
  page.should have_xpath("//*/dd[contains(@class, arg1)]", :text => arg2)
end

Then /^I should see the field content "([^"]*)" not contain "([^"]*)"$/ do |arg1, arg2|
  page.should_not have_xpath("//*/dd[contains(@class, arg1)]", :text => arg2)
end

Then /^I should see "([^"]*)" in italics$/ do |arg1|
  page.should have_xpath("//*/i", :text => arg1)
end

Then /^I should see the word "([^"]*)" highlighted$/ do |arg1|
  page.should have_xpath("//*/span[contains(@style, 'background-color:yellow')]", :text => arg1)
end

