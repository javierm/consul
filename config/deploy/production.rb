set :branch, :production
set :repo_url, "https://github.com/javierm/consul.git"

server deploysecret(:server), user: deploysecret(:user), roles: %w[web app db importer]
