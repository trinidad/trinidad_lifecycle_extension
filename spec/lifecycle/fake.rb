module Trinidad
  module Lifecycle
    module Server
      ANSWER = 42
      class FakeStart < Base
        def start
          put "#{self.inspect} start"
        end
      end
    end
    module WebApp
      class HelperClass; end
      class FakeListener
        include Trinidad::Tomcat::LifecycleListener
        
        def lifecycleEvent(event)
          put "#{self.inspect} lifecycle event: #{event}"
        end
      end
    end
  end
end