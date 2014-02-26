default['nginx']['source']['version'] = '1.4.5'
default['nginx']['source']['mirror'] = 'http://nginx.org/download'
default['nginx']['source']['url'] = "#{node['nginx']['source']['mirror']}/nginx-#{node['nginx']['source']['version']}.tar.gz"

default['nginx']['source']['dependencies'] = %w[
  openssl
  pcre
  zlib
]
