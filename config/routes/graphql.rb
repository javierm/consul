get '/graphql', to: 'graphql#query'
post '/graphql', to: 'graphql#query'
mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: "#{Rails.configuration.relative_url_root}/graphql"
