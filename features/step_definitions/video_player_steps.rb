Then(/^I should see the video player$/) do
  page.should have_css('div#player')
end

Then(/^I should not see the video player$/) do
  page.should have_css('div#restricted')
end