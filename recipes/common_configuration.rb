
directory node['nginx']['dir'] do
  owner 'root'
  group 'root'
  mode 0755
  recursive true
end

directory node['nginx']['log_dir'] do
  owner node['nginx']['user']
  mode 0755
  recursive true
end

%w(sites-available sites-enabled conf.d).each do |dir|
  directory File.join(node['nginx']['dir'], dir) do
    owner "root"
    group "root"
    mode 0755
  end
end

template "nginx.conf" do
  path "#{node['nginx']['dir']}/nginx.conf"
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 00644
end
