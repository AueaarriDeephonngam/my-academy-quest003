Rails.application.routes.draw do
  root 'quests#index'
  
  resources :quests, only: [:index, :create, :destroy] do
    member do
      patch :toggle
    end
  end
  
  get 'brag_document', to: 'brag_documents#show'
end