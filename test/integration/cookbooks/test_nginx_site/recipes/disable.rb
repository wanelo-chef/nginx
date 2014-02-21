include_recipe 'nginx::common_configuration'

template "site.conf" do
  path "#{node['nginx']['dir']}/sites-available/site.conf"
  source 'site.conf.erb'
end

link "#{node['nginx']['dir']}/sites-enabled/site.conf" do
  to "#{node['nginx']['dir']}/sites-available/site.conf"
end

nginx_site 'site.conf' do
  enable false
end
