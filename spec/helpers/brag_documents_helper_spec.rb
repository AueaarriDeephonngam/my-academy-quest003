require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the BragDocumentsHelper. For example:
#
# describe BragDocumentsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe BragDocumentsHelper, type: :helper do
  describe "brag documents helper methods" do
    context "when helper methods exist in BragDocumentsHelper" do
      it "includes BragDocumentsHelper module" do
        expect(helper.class.included_modules).to include(BragDocumentsHelper)
      end
    end

    # Since BragDocumentsHelper is currently empty, we test that it's properly loaded
    it "can be instantiated without errors" do
      expect { helper }.not_to raise_error
    end
  end

  # Example helper methods that could be added to BragDocumentsHelper
  # These are commented out as the methods don't exist yet
  # describe "#format_achievement" do
  #   it "would format achievement text properly" do
  #     expect(helper.format_achievement("Completed project")).to include("✅")
  #   end
  # end
  #
  # describe "#brag_document_title" do
  #   it "would generate appropriate title" do
  #     expect(helper.brag_document_title("John")).to eq("John's Achievements")
  #   end
  # end
end
