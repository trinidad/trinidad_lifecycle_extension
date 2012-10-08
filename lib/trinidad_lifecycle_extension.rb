require 'trinidad'
require 'trinidad_lifecycle_extension/version'

module Trinidad
  module Lifecycle
    
    Listener = Trinidad::Tomcat::LifecycleListener
    
    module Server; end
    module WebApp; end
    
    [ Server, WebApp ].each do |mod|
      mod.module_eval do
        @@_constants = self.constants.dup

        def self.listeners
          listeners = self.constants - @@_constants
          listeners.map! do |name|
            const = self.const_get(name)
            if const.is_a?(Class) && const.included_modules.include?(Listener)
              const.new
            elsif const.is_a?(Listener)
              const
            end
          end
          listeners.compact
        end
      end
    end
    
  end
  
  module Extensions
    module Lifecycle

      private
      
      def init_listeners(container, path, base_mod)
        path ||= File.join('lib', 'lifecycle')

        Dir.glob("#{path}/*.rb").each { |rb| require rb }

        base_mod.listeners.each do |listener|
          container.add_lifecycle_listener listener
        end
      end
      
    end

    class LifecycleServerExtension < ServerExtension
      include Lifecycle

      def configure(tomcat)
        init_listeners(tomcat.server, @options[:path], Trinidad::Lifecycle::Server)
      end
      
    end

    class LifecycleWebAppExtension < WebAppExtension
      include Lifecycle

      def configure(tomcat, context)
        init_listeners(context, @options[:path], Trinidad::Lifecycle::WebApp)
      end
      
    end

    class LifecycleOptionsExtension < OptionsExtension
      def configure(parser, default_options)
        default_options[:extensions] ||= {}
        default_options[:extensions][:lifecycle] = {}
      end
    end
    
  end
end
