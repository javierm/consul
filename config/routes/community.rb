resources :communities, only: [:show] do
  resources :topics
end

resolve("Topic") { |topic| [topic.community, topic] }
