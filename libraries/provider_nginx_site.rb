require 'chef/provider'

class Chef
  class Provider
    class NginxSite < Chef::Provider

      def load_current_resource
        @current_resource ||= Chef::Resource::NginxSite.new(new_resource.name, new_resource.run_context)
      end

      def action_run
        if new_resource.enable
          if @current_resource.enabled?
            Chef::Log.debug("Skipping enabling nginx site #{new_resource.name}")
            new_resource.updated_by_last_action(false)
          else
            Chef::Log.debug("Enabling nginx site #{new_resource.name}")
            ::File.symlink(new_resource.path, new_resource.symlink)
            new_resource.updated_by_last_action(true)
          end
        else
          if @current_resource.enabled?
            Chef::Log.debug("Disabling nginx site #{new_resource.name}")
            ::File.unlink(new_resource.symlink)
            new_resource.updated_by_last_action(true)
          else
            Chef::Log.debug("Skipping disabling nginx site #{new_resource.name}")
            new_resource.updated_by_last_action(false)
          end
        end
      end
    end
  end
end
