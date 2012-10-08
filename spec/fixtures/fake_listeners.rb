module Trinidad
  module Lifecycle
    module Server
      
      CONSTANT = 42
      
      class FakeStart < Base
        
        def start
          put "#{self.inspect} start"
        end
        
      end
      
      USER_CONFIG = org.apache.catalina.startup.UserConfig
      
    end
    module WebApp
      
      class HelperClass; end
      
      class FakeListener
        include Trinidad::Tomcat::LifecycleListener
        
        def lifecycleEvent(event)
          put "#{self.inspect} lifecycle event: #{event}"
        end
        
      end
      
      SECURITY = org.apache.catalina.security.SecurityListener.new
      
    end
  end
end