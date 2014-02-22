include_recipe 'nginx::package'

execute 'nginx should be the correct version' do
  command '[[ "$(nginx -v 2>&1)" == *nginx/1.4.2* ]]'
end
