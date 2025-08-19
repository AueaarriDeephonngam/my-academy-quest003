require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the QuestsHelper. For example:
#
# describe QuestsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe QuestsHelper, type: :helper do
  describe "quest helper methods" do
    context "when helper methods exist in QuestsHelper" do
      it "includes QuestsHelper module" do
        expect(helper.class.included_modules).to include(QuestsHelper)
      end
    end

    # Since QuestsHelper is currently empty, we test that it's properly loaded
    it "can be instantiated without errors" do
      expect { helper }.not_to raise_error
    end
  end

  # Example helper methods that could be added to QuestsHelper
  # These are commented out as the methods don't exist yet
  # describe "#quest_status_class" do
  #   it "would return appropriate CSS class for quest status" do
  #     expect(helper.quest_status_class(true)).to eq("completed")
  #     expect(helper.quest_status_class(false)).to eq("pending")
  #   end
  # end
  #
  # describe "#quest_count_text" do
  #   it "would format quest count text properly" do
  #     expect(helper.quest_count_text(1, 0)).to eq("1 quest • 0 completed")
  #     expect(helper.quest_count_text(5, 3)).to eq("5 quests • 3 completed")
  #   end
  # end
  #
  # describe "#quest_completion_percentage" do
  #   it "would calculate completion percentage" do
  #     expect(helper.quest_completion_percentage(10, 7)).to eq(70)
  #     expect(helper.quest_completion_percentage(0, 0)).to eq(0)
  #   end
  # end
end
