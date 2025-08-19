require 'rails_helper'

RSpec.describe "Quests", type: :request do
  before(:each) do
    Quest.delete_all
  end

  let(:valid_attributes) {
    { title: "Complete RSpec tests" }
  }

  let(:invalid_attributes) {
    { title: "" }
  }

  describe "GET /quests" do
    context "when quests exist" do
      let!(:quest1) { Quest.create!(title: "First quest", done: false) }
      let!(:quest2) { Quest.create!(title: "Second quest", done: true) }

      it "returns http success" do
        get quests_path
        expect(response).to have_http_status(:success)
      end

      it "displays all quests in descending order" do
        get quests_path
        expect(response.body).to include("Second quest")
        expect(response.body).to include("First quest")
      end

      it "shows quest count and completed count" do
        get quests_path
        expect(response.body).to include("2 quests")
        expect(response.body).to include("1 completed")
      end
    end

    context "when no quests exist" do
      it "shows empty state message" do
        get quests_path
        expect(response.body).to include("Ready to start your quest journey!")
        expect(response.body).to include("No quests yet!")
      end
    end
  end

  describe "POST /quests" do
    context "with valid parameters" do
      it "creates a new quest" do
        expect {
          post quests_path, params: { quest: valid_attributes }
        }.to change(Quest, :count).by(1)
      end

      context "HTML format" do
        it "redirects to quests path" do
          post quests_path, params: { quest: valid_attributes }
          expect(response).to redirect_to(quests_path)
        end

        it "sets a success flash message" do
          post quests_path, params: { quest: valid_attributes }
          expect(flash[:notice]).to eq("Quest added successfully!")
        end
      end

      context "Turbo Stream format" do
        it "renders turbo stream response" do
          post quests_path, params: { quest: valid_attributes },
               headers: { "Accept" => "text/vnd.turbo-stream.html" }
          expect(response.media_type).to eq("text/vnd.turbo-stream.html")
          expect(response).to have_http_status(:success)
        end
      end
    end

    context "with invalid parameters" do
      it "does not create a new quest" do
        expect {
          post quests_path, params: { quest: invalid_attributes }
        }.not_to change(Quest, :count)
      end

      context "HTML format" do
        it "renders index template with 200 status" do
          post quests_path, params: { quest: invalid_attributes }
          expect(response).to have_http_status(:ok)
          expect(response).to render_template(:index)
        end
      end

      context "Turbo Stream format" do
        it "renders turbo stream response with error" do
          post quests_path, params: { quest: invalid_attributes },
               headers: { "Accept" => "text/vnd.turbo-stream.html" }
          expect(response.media_type).to eq("text/vnd.turbo-stream.html")
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end

  describe "PATCH /quests/:id/toggle" do
    let!(:quest) { Quest.create!(title: "Test quest", done: false) }

    it "toggles the quest status" do
      expect {
        patch toggle_quest_path(quest)
      }.to change { quest.reload.done }.from(false).to(true)
    end

    context "HTML format" do
      it "redirects to quests path" do
        patch toggle_quest_path(quest)
        expect(response).to redirect_to(quests_path)
      end
    end

    context "Turbo Stream format" do
      it "renders turbo stream response" do
        patch toggle_quest_path(quest),
              headers: { "Accept" => "text/vnd.turbo-stream.html" }
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
        expect(response).to have_http_status(:success)
      end
    end

    context "when quest is already completed" do
      let!(:completed_quest) { Quest.create!(title: "Completed quest", done: true) }

      it "toggles back to incomplete" do
        expect {
          patch toggle_quest_path(completed_quest)
        }.to change { completed_quest.reload.done }.from(true).to(false)
      end
    end
  end

  describe "DELETE /quests/:id" do
    let!(:quest) { Quest.create!(title: "Quest to delete", done: false) }

    it "destroys the quest" do
      expect {
        delete quest_path(quest)
      }.to change(Quest, :count).by(-1)
    end

    it "removes the specific quest" do
      delete quest_path(quest)
      expect(Quest.find_by(id: quest.id)).to be_nil
    end

    context "HTML format" do
      it "redirects to quests path" do
        delete quest_path(quest)
        expect(response).to redirect_to(quests_path)
      end

      it "sets a success flash message" do
        delete quest_path(quest)
        expect(flash[:notice]).to eq("Quest deleted successfully!")
      end
    end

    context "Turbo Stream format" do
      it "renders turbo stream response" do
        delete quest_path(quest),
               headers: { "Accept" => "text/vnd.turbo-stream.html" }
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe "Error handling" do
    describe "PATCH /quests/:id/toggle" do
      it "handles non-existent quest gracefully" do
        patch toggle_quest_path(id: 99999)
        expect(response).to have_http_status(:not_found)
      end
    end

    describe "DELETE /quests/:id" do
      it "handles non-existent quest gracefully" do
        delete quest_path(id: 99999)
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe "Quest ordering" do
    let!(:older_quest) { Quest.create!(title: "Older quest", created_at: 1.day.ago) }
    let!(:newer_quest) { Quest.create!(title: "Newer quest", created_at: 1.hour.ago) }

    it "displays quests in descending order (newest first)" do
      get quests_path


      newer_position = response.body.index("Newer quest")
      older_position = response.body.index("Older quest")

      expect(newer_position).to be < older_position
    end
  end

  describe "Multiple quest operations" do
    let!(:quest1) { Quest.create!(title: "Quest 1", done: false) }
    let!(:quest2) { Quest.create!(title: "Quest 2", done: false) }
    let!(:quest3) { Quest.create!(title: "Quest 3", done: true) }

    it "correctly handles multiple toggles" do
      # Toggle quest1 to complete
      patch toggle_quest_path(quest1)
      expect(quest1.reload.done).to be true


      patch toggle_quest_path(quest3)
      expect(quest3.reload.done).to be false


      expect(quest2.reload.done).to be false
    end

    it "correctly handles partial deletions" do
      delete quest_path(quest2)

      expect(Quest.count).to eq(2)
      expect(Quest.find_by(id: quest2.id)).to be_nil
      expect(Quest.find_by(id: quest1.id)).to be_present
      expect(Quest.find_by(id: quest3.id)).to be_present
    end
  end
end
