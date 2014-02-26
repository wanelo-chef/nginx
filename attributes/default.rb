default['nginx']['dir'] = "#{node['paths']['etc_dir']}/nginx"
default['nginx']['log_dir'] = '/var/log/nginx'

default['nginx']['user'] = "www"
default['nginx']['group'] = node['nginx']['user']

default['nginx']['worker_processes'] = node['cpu'] && node['cpu']['total'] ? node['cpu']['total'] : 1
default['nginx']['binary'] = "#{node['paths']['sbin_dir']}/nginx"
default['nginx']['sbin'] = node['paths']['sbin_dir']

default['nginx']['pid'] = '/var/run/nginx.pid'

default['nginx']['gzip']              = 'on'
default['nginx']['gzip_http_version'] = '1.0'
default['nginx']['gzip_comp_level']   = '2'
default['nginx']['gzip_proxied']      = 'any'
default['nginx']['gzip_vary']         = 'off'
default['nginx']['gzip_buffers']      = '32 4k'
default['nginx']['gzip_types']        = %w[
  text/plain
  text/css
  application/x-javascript
  text/xml
  application/xml
  application/xml+rss
  text/javascript
  application/javascript
  application/json
]

default['nginx']['keepalive']          = 'on'
default['nginx']['keepalive_timeout']  = 65
default['nginx']['worker_connections'] = 1024
default['nginx']['worker_rlimit_nofile'] = nil
default['nginx']['multi_accept']       = false
default['nginx']['event']              = nil
default['nginx']['server_names_hash_bucket_size'] = 64

default['nginx']['disable_access_log'] = false
default['nginx']['install_method'] = 'package'
default['nginx']['default_site_enabled'] = true
default['nginx']['types_hash_max_size'] = 2048
default['nginx']['types_hash_bucket_size'] = 64

default['nginx']['service']['name'] = 'nginx'
