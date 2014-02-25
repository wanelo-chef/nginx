include_recipe 'nginx::source'

execute 'nginx should be the correct version' do
  command '[[ "$(nginx -v 2>&1)" == *nginx/1.4.5* ]]'
end
