module Trinidad
  module Lifecycle
    module Server
      USER_CONFIG = org.apache.catalina.startup.UserConfig
    end
    module WebApp
      SECURITY = org.apache.catalina.security.SecurityListener.new
    end
  end
end