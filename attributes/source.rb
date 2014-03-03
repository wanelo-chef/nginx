default['nginx']['source']['version'] = '1.4.5'
default['nginx']['source']['mirror'] = 'http://nginx.org/download'
default['nginx']['source']['url'] = "#{node['nginx']['source']['mirror']}/nginx-#{node['nginx']['source']['version']}.tar.gz"

default['nginx']['source']['symlink'] = "#{node['nginx']['sbin']}/nginx"
default['nginx']['source']['skip_symlinking'] = false

default['nginx']['source']['dependencies'] = %w[
  openssl
  pcre
  zlib
]
