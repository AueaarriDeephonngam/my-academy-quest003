class QuestsController < ApplicationController
  before_action :set_quest, only: [ :destroy, :toggle ]
  before_action :load_quests, only: [ :index, :create, :toggle, :destroy ]

  def index
    @quest = Quest.new
  end

  def create
    @quest = Quest.new(quest_params)

    if @quest.save
      respond_to do |format|
        format.html { redirect_to quests_path, notice: "Quest added successfully!" }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { render :index }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("quest-list", partial: "quest_list") }
      end
    end
  end

  def toggle
    @quest.update(done: !@quest.done)
    respond_to do |format|
      format.html { redirect_to quests_path }
      format.turbo_stream
    end
  end

  def destroy
    @quest.destroy
    respond_to do |format|
      format.html { redirect_to quests_path, notice: "Quest deleted successfully!" }
      format.turbo_stream
    end
  end

  private

  def set_quest
    @quest = Quest.find(params[:id])
  end

  def load_quests
    @quests = Quest.order(created_at: :desc)
  end

  def quest_params
    params.require(:quest).permit(:title)
  end
end
