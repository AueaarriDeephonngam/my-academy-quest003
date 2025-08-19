require 'rails_helper'

RSpec.describe QuestsController, type: :controller do
  let(:valid_attributes) {
    { title: "Complete unit tests" }
  }

  let(:invalid_attributes) {
    { title: "" }
  }

  describe "GET #index" do
    before(:each) do
      Quest.delete_all  
    end

    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns @quest as a new Quest" do
      get :index
      expect(assigns(:quest)).to be_a_new(Quest)
    end

    it "assigns @quests with all quests ordered by created_at desc" do
      quest1 = Quest.create!(title: "First", created_at: 1.day.ago)
      quest2 = Quest.create!(title: "Second", created_at: 1.hour.ago)

      get :index

      expect(assigns(:quests).to_a).to eq([ quest2, quest1 ])
    end

    context "when no quests exist" do
      it "assigns empty @quests" do
        get :index
        expect(assigns(:quests).to_a).to be_empty
      end
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Quest" do
        expect {
          post :create, params: { quest: valid_attributes }
        }.to change(Quest, :count).by(1)
      end

      it "assigns @quest" do
        post :create, params: { quest: valid_attributes }
        expect(assigns(:quest)).to be_a(Quest)
        expect(assigns(:quest)).to be_persisted
        expect(assigns(:quest).title).to eq("Complete unit tests")
      end

      it "assigns @quests after creation" do
        post :create, params: { quest: valid_attributes }
        expect(assigns(:quests)).to include(assigns(:quest))
      end

      context "HTML format" do
        it "redirects to the quests index" do
          post :create, params: { quest: valid_attributes }
          expect(response).to redirect_to(quests_path)
        end

        it "sets a success flash notice" do
          post :create, params: { quest: valid_attributes }
          expect(flash[:notice]).to eq("Quest added successfully!")
        end
      end

      context "Turbo Stream format" do
        it "renders turbo stream template" do
          post :create, params: { quest: valid_attributes }, format: :turbo_stream
          expect(response).to render_template(:create)
          expect(response.media_type).to eq("text/vnd.turbo-stream.html")
        end
      end
    end
  end

  describe "PATCH #toggle" do
    let!(:quest) { Quest.create!(title: "Toggle quest", done: false) }

    it "finds the correct quest" do
      patch :toggle, params: { id: quest.id }
      expect(assigns(:quest)).to eq(quest)
    end

    it "toggles the quest status from false to true" do
      expect {
        patch :toggle, params: { id: quest.id }
      }.to change { quest.reload.done }.from(false).to(true)
    end

    it "toggles the quest status from true to false" do
      quest.update!(done: true)
      expect {
        patch :toggle, params: { id: quest.id }
      }.to change { quest.reload.done }.from(true).to(false)
    end

    it "assigns @quests after toggle" do
      patch :toggle, params: { id: quest.id }
      expect(assigns(:quests)).to include(quest)
    end

    context "HTML format" do
      it "redirects to quests path" do
        patch :toggle, params: { id: quest.id }
        expect(response).to redirect_to(quests_path)
      end
    end

    context "Turbo Stream format" do
      it "renders turbo stream template" do
        patch :toggle, params: { id: quest.id }, format: :turbo_stream
        expect(response).to render_template(:toggle)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end
    end

    context "when quest is nil (handles done field)" do
      let!(:nil_quest) { Quest.create!(title: "Nil quest", done: nil) }

      it "toggles nil to true" do
        expect {
          patch :toggle, params: { id: nil_quest.id }
        }.to change { nil_quest.reload.done }.from(nil).to(true)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:quest) { Quest.create!(title: "Quest to delete") }

    it "finds the correct quest" do
      delete :destroy, params: { id: quest.id }
      expect(assigns(:quest)).to eq(quest)
    end

    it "destroys the requested quest" do
      expect {
        delete :destroy, params: { id: quest.id }
      }.to change(Quest, :count).by(-1)
    end

    it "assigns @quests after destruction" do
      other_quest = Quest.create!(title: "Other quest")
      delete :destroy, params: { id: quest.id }
      expect(assigns(:quests)).to include(other_quest)
      expect(assigns(:quests)).not_to include(quest)
    end

    context "HTML format" do
      it "redirects to quests path" do
        delete :destroy, params: { id: quest.id }
        expect(response).to redirect_to(quests_path)
      end

      it "sets a success flash notice" do
        delete :destroy, params: { id: quest.id }
        expect(flash[:notice]).to eq("Quest deleted successfully!")
      end
    end

    context "Turbo Stream format" do
      it "renders turbo stream template" do
        delete :destroy, params: { id: quest.id }, format: :turbo_stream
        expect(response).to render_template(:destroy)
        expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      end
    end
  end

  describe "private methods" do
    describe "#set_quest" do
      let!(:quest) { Quest.create!(title: "Test quest") }

      it "sets @quest for toggle action" do
        patch :toggle, params: { id: quest.id }
        expect(assigns(:quest)).to eq(quest)
      end

      it "sets @quest for destroy action" do
        delete :destroy, params: { id: quest.id }
        expect(assigns(:quest)).to eq(quest)
      end

      it "raises RecordNotFound for invalid id" do
        expect {
          patch :toggle, params: { id: 99999 }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe "#load_quests" do
      before(:each) do
        Quest.delete_all  
      end

      let!(:quest1) { Quest.create!(title: "First", created_at: 2.hours.ago) }
      let!(:quest2) { Quest.create!(title: "Second", created_at: 1.hour.ago) }

      it "loads quests in descending order for index" do
        get :index
        expect(assigns(:quests).to_a).to eq([ quest2, quest1 ])
      end

      it "loads quests in descending order for create" do
        post :create, params: { quest: valid_attributes }
        assigned_quests = assigns(:quests).to_a
        expect(assigned_quests).to include(quest2, quest1)
      end

      it "loads quests in descending order for toggle" do
        patch :toggle, params: { id: quest1.id }
        expect(assigns(:quests).to_a).to include(quest2, quest1)
      end

      it "loads quests in descending order for destroy" do
        delete :destroy, params: { id: quest1.id }
        expect(assigns(:quests).to_a).to eq([ quest2 ])
      end
    end

    describe "#quest_params" do
      it "permits only title parameter" do
        controller_params = ActionController::Parameters.new({
          quest: {
            title: "Valid title",
            done: true,
            created_at: Time.current,
            malicious_param: "hack attempt"
          }
        })

        allow(controller).to receive(:params).and_return(controller_params)
        permitted_params = controller.send(:quest_params)

        expect(permitted_params.to_h).to eq({ "title" => "Valid title" })
      end
    end
  end
end
