namespace :admin do
  resources :legislators, only: [:index, :create, :destroy] do
    get :search, on: :collection
  end
  resources :budget_managers, only: [:index, :create, :destroy] do
    get :search, on: :collection
  end
end
