namespace :moderation do
  root to: "dashboard#index"

  resources :users, only: :index do
    get :index_for_geozone, on: :collection
    member do
      put :hide
      put :hide_in_moderation_screen
      put :verify_geozone_residence
    end
  end

  resources :debates, only: :index do
    put :hide, on: :member
    put :moderate, on: :collection
  end

  resources :proposals, only: :index do
    put :hide, on: :member
    put :moderate, on: :collection
  end

  resources :comments, only: :index do
    put :hide, on: :member
    put :moderate, on: :collection
  end

  resources :proposal_notifications, only: :index do
    put :hide, on: :member
    put :moderate, on: :collection
  end
end
