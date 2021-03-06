# Trinidad Lifecycle Extension

This extension allows you to add lifecycle listeners (written in ruby) to the 
[Trinidad](https://github.com/trinidad/trinidad/) server container as well as to
deployed web application contexts running on top of it.

This extension no longer bundles the **catalina-jmx-remote.jar** and thus for
configuring remote JMX monitoring capabilities using the `JmxRemoteLifecycleListener`
you will need to provide and load the Java class (e.g. by downloading and 
loading the .jar). Alternatively, there's a separate 
[trinidad_jmx_remote_extension](http://github.com/kares/trinidad_jmx_remote_extension)
for enabling JMX with SSH if that's all you're looking for here.

## Install

Install the gem or simply add it to you *Gemfile* along with Trinidad :

```
group :server do
  platform :jruby do
    gem 'trinidad', :require => false
    gem 'trinidad_lifecycle_extension', :require => false
  end
end
```

## Configuration

Add this extension into the Trinidad's configuration file and (optionally) set 
the path to the directory where the listener .rb files are located e.g. :

```
---
  # ...
  extensions:
    lifecycle:
      listeners_path: "lib/lifecycle" # defaults to lib/lifecycle
```

Trinidad will try to require the *.rb files from the lifecycle directory and 
will instantiate listener classes while adding them to the appropriate lifecycle
container based on whether the class is defined under the `Lifecycle::Server` or
the `Lifecycle::WebApp` module.

## How to write a Listener

### Server Lifecycle Listener

If the listener is for the server the class must be exported under the module
`Trinidad::Lifecycle::Server` the class is expected to "implement" the interface
[LifecycleListener](http://tomcat.apache.org/tomcat-7.0-doc/api/org/apache/catalina/LifecycleListener.html)
you do not need to worry about that if you extend from `Trinidad::Lifecycle::Base`
class. All [Lifecycle](http://tomcat.apache.org/tomcat-7.0-doc/api/org/apache/catalina/Lifecycle.html)
events are mapped to methods e.g. on an `AFTER_INIT_EVENT` `#after_init(event)`
gets invoked, it accepts a single argument the event object. 
Example :

```ruby
module Trinidad
  module Lifecycle
    module Server
      # for Trinidad::Lifecycle::Base
      # @see trinidad/lifecycle/base.rb
      class StartStop < Base

        def start(event)
          puts "starting server"
        end

        def stop(event)
          puts "stopping server"
        end

      end
    end
  end
end
```

You can as well export existing (Java classes) as nested module constants and
they will be instantiated and configured as listeners e.g. :

```ruby
module Trinidad
  module Lifecycle
    module Server
      SECURITY_SETUP = org.apache.catalina.security.SecurityListener
    end
  end
end
```

Of you may sub-class them and perform desired setup when instantiated :

```ruby
module Trinidad
  module Lifecycle
    module Server
      class UserSecurity < org.apache.catalina.security.SecurityListener
        def initialize
          setCheckedOsUsers('root,public,nobody')
        end
      end
    end
  end
end
```


### WebApp Lifecycle Listener

The very same rules apply as for the Server listeners above except that we add
listener classes under the `Trinidad::Lifecycle::WebApp` module e.g. :

```ruby
module Trinidad
  module Lifecycle
    module WebApp
      # not using Trinidad::Lifecycle::Base base class ...
      # but implementing Tomcat:LifecycleListener by hand
      class TheOldWayListener
        include Trinidad::Tomcat::LifecycleListener

        def lifecycleEvent(event)
          case event.type
          when Trinidad::Tomcat::Lifecycle::BEFORE_START_EVENT
            # do something before start the web application context
          end
        end

      end
    end
  end
end
```

Lifecycle listeners might be exported as (configured) instances as well e.g. :

```ruby
module Trinidad
  module Lifecycle
    module WebApp
      
      def self.configure_jre_memory_leak_prevention_listener
        listener = org.apache.catalina.core.JreMemoryLeakPreventionListener.new
        listener.setGcDaemonProtection(true)
        listener.setUrlCacheProtection(true)
        listener
      end

      MEMORY_LEAK_LISTENER = self.configure_jre_memory_leak_prevention_listener

    end
  end
end
```

## Copyright

Copyright (c) 2012 [Team Trinidad](https://github.com/trinidad). 
See LICENSE (http://en.wikipedia.org/wiki/MIT_License) for details.
