namespace :legislation do
  resources :processes, only: [:index, :show] do
    member do
      get :debate
      get :draft_publication
      get :allegations
      get :result_publication
      get :proposals
      get :milestones
    end

    %i[questions legislation_questions].each do |name_convention|
      resources :questions, as: name_convention, only: [:show] do
        resources :answers, only: [:create]
      end
    end

    %i[proposals legislation_proposals].each do |name_convention|
      resources :proposals, as: name_convention do
        member do
          post :vote
          put :flag
          put :unflag
        end
        collection do
          get :map
          get :suggest
        end
      end
    end

    resources :draft_versions, only: [:show] do
      get :go_to_version, on: :collection
      get :changes

      %i[draft_version_annotations legislation_draft_version_legislation_annotation].each do |name_convention|
        resources :annotations, as: name_convention do
          get :search, on: :collection
          get :comments
          post :new_comment
        end
      end
    end
  end
end
