group node['nginx']['group'] do
  action :create
end

user node['nginx']['user'] do
  group node['nginx']['group']
  supports manage_home: false
end
