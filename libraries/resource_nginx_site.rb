require 'chef/resource'

class Chef
  class Resource
    class NginxSite < Chef::Resource

      def initialize(name, run_context = nil)
        super
        @resource_name = :nginx_site
        @provider = Chef::Provider::NginxSite
        @action = :run
        @allowed_action = [:run]

        @name = name
        @enable = false
      end

      def enable(arg=nil)
        set_or_return(:enable, arg, kind_of: [TrueClass, FalseClass])
      end

      def enabled?
        Chef::Log.debug("Nginx site is enabled: #{::File.symlink?(symlink)}")
        ::File.symlink?(symlink)
      end

      def path
        "#{available_sites}/#{@name}"
      end

      def symlink
        "#{enabled_sites}/#{@name}"
      end

      def available_sites
        "#{run_context.node['nginx']['dir']}/sites-available"
      end

      def enabled_sites
        "#{run_context.node['nginx']['dir']}/sites-enabled"
      end
    end
  end
end
