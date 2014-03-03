require 'chef/mixin/shell_out'

module Nginx
  class SourceChecks
    include Chef::Mixin::ShellOut

    attr_accessor :node

    def initialize(node)
      @node = node
    end

    def already_compiled?
      shell_out("[[ $(#{prefix}/nginx -v 2>&1) == *nginx/#{nginx_version}* ]]").status == 0
    end

    def skip_symlink?
      if node['nginx']['source']['skip_symlinking']
        true
      else
        shell_out("test -e #{symlink} && [[ $(#{symlink} -v 2>&1) == *nginx/#{nginx_version}* ]]").status == 0
      end
    end

    private

    def nginx_version
      node['nginx']['source']['version']
    end

    def prefix
      "/opt/nginx-#{nginx_version}"
    end

    def symlink
      node['nginx']['source']['symlink']
    end
  end
end
