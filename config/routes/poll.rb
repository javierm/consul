resources :polls, only: [:show, :index] do
  member do
    get :stats
    get :results
  end

  resources :questions, controller: "polls/questions", shallow: true do
    post :answer, on: :member
  end
end

resolve "Poll::Question" do |question|
  [:question, id: question]
end
