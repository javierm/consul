set :deploy_to, deploysecret(:deploy_to)
set :server_name, deploysecret(:server_name)
set :db_server, deploysecret(:db_server)
set :branch, :master
set :ssh_options, port: deploysecret(:ssh_port)
set :stage, :production
set :rails_env, :production

set :default_env, {
#   'http_proxy' => 'http://192.168.1.1:8080',
#   'https_proxy' => 'http://192.168.1.1:8080'
    'HOSTALIASES' => '/home/instalador/.hosts'
}

server deploysecret(:server), user: deploysecret(:user), roles: %w(web app db importer cron background)
#server deploysecret(:server1), user: deploysecret(:user), roles: %w(web app db importer cron background)
#server deploysecret(:server2), user: deploysecret(:user), roles: %w(web app db importer cron background)
#server deploysecret(:server3), user: deploysecret(:user), roles: %w(web app db importer)
#server deploysecret(:server4), user: deploysecret(:user), roles: %w(web app db importer)
