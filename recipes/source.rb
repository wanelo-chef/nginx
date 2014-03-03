include_recipe 'paths::default'
include_recipe 'build-essential::default'
include_recipe 'nginx::user'

nginx_version = node['nginx']['source']['version']
prefix = "/opt/nginx-#{nginx_version}"

checks = Nginx::SourceChecks.new(node)

node['nginx']['source']['dependencies'].each do |pkg|
  package pkg
end

remote_file "#{Chef::Config[:file_cache_path]}/nginx-#{nginx_version}.tar.gz" do
  source node['nginx']['source']['url']
  not_if { checks.already_compiled? }
end

execute "untar nginx source" do
  command "tar xzf #{Chef::Config[:file_cache_path]}/nginx-#{nginx_version}.tar.gz"
  cwd Chef::Config[:file_cache_path]
  not_if { checks.already_compiled? }
end

nginx_user = node['nginx']['user']
nginx_group = node['nginx']['group']

modules = %w(
  mail_ssl
  http_gzip_static
  http_realip
  http_ssl
  http_stub_status
)

module_flags = modules.inject("") { |memo, nginx_module| memo << "--with-#{nginx_module}_module " }

execute "configure nginx" do
  command %{
    ./configure --user=#{nginx_user} --group=#{nginx_group} \
      --with-cc-opt='-L/opt/local/lib -Wl,-R/opt/local/lib' \
      --with-ld-opt='-L/opt/local/lib -Wl,-R/opt/local/lib' \
      --prefix=#{prefix} \
      --sbin-path=#{prefix}/nginx \
      --conf-path=#{node['nginx']['dir']}/nginx.conf \
      --pid-path=#{node['nginx']['pid']} \
      --lock-path=#{node['nginx']['lock_dir']}/nginx.lock \
      --error-log-path=#{node['nginx']['log_dir']}/error.log \
      --http-log-path=#{node['nginx']['log_dir']}/access.log \
      --http-client-body-temp-path=/var/db/nginx/client_body_temp \
      --http-proxy-temp-path=/var/db/nginx/proxy_temp \
      --http-fastcgi-temp-path=/var/db/nginx/fstcgi_temp \
      #{module_flags}
  }
  cwd "#{Chef::Config[:file_cache_path]}/nginx-#{nginx_version}"
  not_if { checks.already_compiled? }
end

execute "make nginx" do
  command %{
    make
    make install
  }
  cwd "#{Chef::Config[:file_cache_path]}/nginx-#{nginx_version}"
  not_if { checks.already_compiled? }
  environment 'LDFLAGS' => '-L/opt/local/lib -Wl,-R/opt/local/lib'
end

include_recipe 'nginx::common_configuration'
include_recipe 'nginx::service'

execute 'verify nginx binary against current configuration' do
  command "#{prefix}/nginx -t -c #{node['nginx']['dir']}/nginx.conf"
  not_if { checks.skip_symlink? }
  notifies :create, 'link[nginx]', :immediately
end

service node['nginx']['service']['name']

link "nginx" do
  target_file node['nginx']['source']['symlink']
  to "#{prefix}/nginx"
  action :nothing

  not_if { checks.skip_symlink? }
  notifies :restart, "service[#{node['nginx']['service']['name']}]", :immediately
end
