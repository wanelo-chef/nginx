name             'nginx'
maintainer       'Wanelo'
maintainer_email 'ops@wanelo.com'
license          'MIT'
description      'Installs/Configures nginx'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.4.3'

depends 'build-essential'
depends 'paths', '~> 0.3'
depends 'resource-control', '~> 0.1'
depends 'smf', '~> 2.1'
