require 'rails_helper'

RSpec.describe Quest, type: :model do
  describe "validations" do
    it "is valid with a title" do
      quest = Quest.new(title: "Complete the project")
      expect(quest).to be_valid
    end

    it "is invalid without a title" do
      quest = Quest.new(title: nil)
      expect(quest).not_to be_valid
      expect(quest.errors[:title]).to include("can't be blank")
    end

    it "is invalid with blank title" do
      quest = Quest.new(title: "")
      expect(quest).not_to be_valid
      expect(quest.errors[:title]).to include("can't be blank")
    end

    it "is invalid with only whitespace in title" do
      quest = Quest.new(title: "   ")
      expect(quest).not_to be_valid
      expect(quest.errors[:title]).to include("can't be blank")
    end
  end

  describe "default values" do
    it "allows done to be nil by default" do
      quest = Quest.new(title: "Test quest")
      expect(quest.done).to be_nil
    end

    it "can be created as completed" do
      quest = Quest.create!(title: "Completed quest", done: true)
      expect(quest.done).to be true
    end

    it "can be created as incomplete" do
      quest = Quest.create!(title: "Incomplete quest", done: false)
      expect(quest.done).to be false
    end
  end

  describe "scopes and ordering" do
    let!(:older_quest) { Quest.create!(title: "Older", created_at: 2.days.ago) }
    let!(:newer_quest) { Quest.create!(title: "Newer", created_at: 1.day.ago) }

    it "has completed scope" do
      completed_quest = Quest.create!(title: "Done", done: true)
      incomplete_quest = Quest.create!(title: "Not done", done: false)

      expect(Quest.completed).to include(completed_quest)
      expect(Quest.completed).not_to include(incomplete_quest)
    end

    it "has pending scope that includes false and nil values" do
      incomplete_quest = Quest.create!(title: "Not done", done: false)
      nil_quest = Quest.create!(title: "Nil done", done: nil)
      complete_quest = Quest.create!(title: "Done", done: true)

      expect(Quest.pending).to include(incomplete_quest, nil_quest)
      expect(Quest.pending).not_to include(complete_quest)
    end
  end

  describe "instance methods" do
    let(:incomplete_quest) { Quest.create!(title: "Incomplete quest", done: false) }
    let(:completed_quest) { Quest.create!(title: "Completed quest", done: true) }

    describe "#toggle!" do
      it "changes incomplete quest to complete" do
        expect {
          incomplete_quest.toggle!(:done)
        }.to change { incomplete_quest.done }.from(false).to(true)
      end

      it "changes complete quest to incomplete" do
        expect {
          completed_quest.toggle!(:done)
        }.to change { completed_quest.done }.from(true).to(false)
      end

      it "saves the record" do
        incomplete_quest.toggle!(:done)
        expect(incomplete_quest.reload.done).to be true
      end
    end
  end

  describe "database constraints" do
    it "persists to database correctly" do
      quest = Quest.create!(title: "Persistent quest", done: true)
      reloaded_quest = Quest.find(quest.id)

      expect(reloaded_quest.title).to eq("Persistent quest")
      expect(reloaded_quest.done).to be true
    end

    it "maintains data integrity after updates" do
      quest = Quest.create!(title: "Original title", done: false)
      quest.update!(title: "Updated title", done: true)

      reloaded_quest = Quest.find(quest.id)
      expect(reloaded_quest.title).to eq("Updated title")
      expect(reloaded_quest.done).to be true
    end
  end

  describe "edge cases" do
    it "handles long titles" do
      long_title = "A" * 255
      quest = Quest.new(title: long_title)
      expect(quest).to be_valid
    end

    it "handles special characters in title" do
      special_title = "Complete task #1 & write tests! 🚀"
      quest = Quest.create!(title: special_title)
      expect(quest.title).to eq(special_title)
    end
  end
end
