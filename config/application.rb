require_relative 'boot'
require_relative 'csp'
require 'rails/all'

Bundler.require(*Rails.groups)

module HDSkinsServer
  class Application < Rails::Application
    config.load_defaults 5.1

    #Disable asset generation
    config.generators do |g|
      g.assets false
    end
    
    # Special headers
    config.action_dispatch.default_headers = {
      'X-Frame-Options' => 'SAMEORIGIN',
      'X-XSS-Protection' => '1; mode=block',
      'X-Content-Type-Options' => 'nosniff',
      'Content-Security-Policy' => HDSkinsServer::Csp.headers[:default]
    }
    
    # Load libs
    config.autoload_paths += %W[#{config.root}/lib]
    config.eager_load_paths += %W[#{config.root}/lib]
    
    #Handle json like a sane person
    config.active_support.escape_html_entities_in_json = false
    config.active_record.belongs_to_required_by_default = false
    
    # Git
    config.after_initialize do
      ::Git_branch = `git rev-parse --abbrev-ref HEAD`.chomp
      ::Git_version = `git rev-parse --short HEAD`.chomp
    end
  end
end
