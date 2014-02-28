include_recipe 'nginx::common_configuration'
include_recipe 'test_nginx_site::test_site'

package 'nginx' do
  action :remove
end

# Set up nginx with version from package tree (v 1.4.2)
#
include_recipe 'nginx::package'

service 'nginx' do
  action :restart
end

execute 'nginx should be the correct package version' do
  command '[[ "$(nginx -v 2>&1)" == *nginx/1.4.2* ]]'
end

execute 'nginx should be running the correct package version' do
  command 'curl --silent http://localhost/not_found | grep 1.4.2'
end

# Set up nginx with version from source (v 1.4.5)
#
include_recipe 'nginx::source'

execute 'nginx should be the correct source version' do
  command '[[ "$(nginx -v 2>&1)" == *nginx/1.4.5* ]]'
end

execute 'nginx should be running the correct source version' do
  command 'curl --silent http://localhost/not_found | grep 1.4.5'
  not_if 'test -e /var/tmp/already_run'
end
