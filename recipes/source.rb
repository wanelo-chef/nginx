
include_recipe 'build-essential::default'

remote_file "#{Chef::Config[:file_cache_path]}/nginx-1.4.5.tar.gz" do
  source "http://nginx.org/download/nginx-1.4.5.tar.gz"
end

execute "untar nginx source" do
  command "tar xzf #{Chef::Config[:file_cache_path]}/nginx-1.4.5.tar.gz"
  cwd Chef::Config[:file_cache_path]
end

nginx_user = node['nginx']['user']
nginx_group = node['nginx']['group']

modules = %w(
  mail_ssl
  http_ssl
  http_realip
  http_stub_status
)

module_flags = modules.inject("") { |memo, nginx_module| memo << "--with-#{nginx_module}_module " }

execute "configure nginx" do
  command %{
    ./configure --user=#{nginx_user} --group=#{nginx_group} \
      --with-ld-opt='-L/opt/local/lib -Wl,-R/opt/local/lib' \
      --prefix=#{node['paths']['prefix_dir']} \
      --sbin-path=#{node['nginx']['sbin']} \
      --conf-path=#{node['nginx']['dir']}/nginx.conf \
      --pid-path=#{node['nginx']['pid']} \
      --lock-path=/var/db/nginx/nginx.lock \
      --error-log-path=#{node['nginx']['log_dir']}/error.log \
      --http-log-path=#{node['nginx']['log_dir']}/access.log \
      --http-client-body-temp-path=/var/db/nginx/client_body_temp \
      --http-proxy-temp-path=/var/db/nginx/proxy_temp \
      --http-fastcgi-temp-path=/var/db/nginx/fstcgi_temp \
      #{module_flags}
  }
  cwd "#{Chef::Config[:file_cache_path]}/nginx-1.4.5"
end

execute "make nginx" do
  command %{
    make
    make install
  }
  cwd "#{Chef::Config[:file_cache_path]}/nginx-1.4.5"
  environment 'LDFLAGS' => '-L/opt/local/lib -Wl,-R/opt/local/lib'
end

include_recipe 'nginx::common_configuration'
