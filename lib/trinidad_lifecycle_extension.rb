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
          listener_constants.map do |name|
            const = self.const_get(name)
            const.is_a?(Class) ? const.new : const
          end
        end
        
        def self.listener_constants
          listeners = self.constants - @@_constants
          listeners.map! do |name|
            const = self.const_get(name)
            if const.is_a?(Class) && const.included_modules.include?(Listener)
              name
            elsif const.is_a?(Listener)
              name
            else
              nil
            end
          end
          listeners.compact
        end
      end
    end
    
  end
  
  module Extensions
    module Lifecycle

      DEFAULT_LISTENERS_PATH = 'lib/lifecycle'
      
      protected
      
      def listeners_path(type = nil)
        options[:listeners_path] || options[:path] || DEFAULT_LISTENERS_PATH
      end
      
      private
      
      LOAD_METHOD = :load
      
      def init_listeners(base_mod, listeners_path, container)
        # allow listeners_path to be a glob itself :
        load_files = Dir.glob(listeners_path)
        if load_files.size == 0 || 
            ( load_files.size == 1 && File.directory?(load_files[0]) )
          load_files = Dir.glob(File.join(listeners_path, '*.rb'))
        end
        
        load_files.each { |rb_file| send LOAD_METHOD, rb_file }

        # e.g. Trinidad::Lifecycle::Server.listeners
        base_mod.listeners.each do |listener|
          container.add_lifecycle_listener listener
        end
      end
      
    end

    class LifecycleServerExtension < ServerExtension
      include Lifecycle

      def configure(tomcat)
        init_listeners(Trinidad::Lifecycle::Server, listeners_path(:server), tomcat.server)
      end
      
    end

    class LifecycleWebAppExtension < WebAppExtension
      include Lifecycle

      def configure(context)
        init_listeners(Trinidad::Lifecycle::WebApp, listeners_path(:webapp), context)
      end
      
    end
    
  end
end
