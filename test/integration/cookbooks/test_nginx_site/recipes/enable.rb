include_recipe 'nginx::common_configuration'

template "site.conf" do
  path "#{node['nginx']['dir']}/sites-available/site.conf"
  source 'site.conf.erb'
end

nginx_site 'site.conf' do
  enable true
end
