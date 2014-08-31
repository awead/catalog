require 'spec_helper'

describe BookmarksHelper, :type => :helper do

  include Devise::TestHelpers

  describe "#render_bookmarks_index_view" do

    it "shows no bookmarks for guest or current users" do
      expect(helper.render_bookmarks_index_view).to eq "<p>You have no bookmarks</p>"
    end

  end 

end
