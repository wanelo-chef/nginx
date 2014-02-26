include_recipe 'resource-control::default'
include_recipe 'smf::default'

resource_control_project 'nginx' do
  comment 'nginx project'
  process_limits 'max-file-descriptor' => {
      'value' => 32768, 'deny' => true, 'level' => 'basic'
  }
end

service 'nginx'

smf 'pkgsrc/nginx' do
  action :delete
end

smf 'nginx' do
  project 'nginx'
  start_command "#{node['nginx']['sbin']}/nginx -c %{config/nginx_conf}"
  start_timeout 60
  stop_command ':kill'
  stop_timeout 60
  refresh_command ':kill -HUP'
  refresh_timeout 60

  ignore %w(core signal)
  environment 'LD_PRELOAD_32' => '/usr/lib/extendedFILE.so.1'
  property_groups 'config' => {
      'nginx_conf' => "#{node['nginx']['dir']}/nginx.conf"
  }
  notifies :enable, 'service[nginx]'
end
