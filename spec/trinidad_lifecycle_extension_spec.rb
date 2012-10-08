require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'trinidad lifecycle extension' do
  
  before :all do
    @options = { :path => File.expand_path('../lifecycle', __FILE__) }
  end

  after do
    Trinidad::Lifecycle::Server.listener_constants.each do |name|
      Trinidad::Lifecycle::Server.send :remove_const, name
    end
    Trinidad::Lifecycle::WebApp.listener_constants.each do |name|
      Trinidad::Lifecycle::WebApp.send :remove_const, name
    end
  end
  
  let(:tomcat) { org.apache.catalina.startup.Tomcat.new }
  let(:context) { Trinidad::Tomcat::StandardContext.new }

  context "server" do
    
    subject { Trinidad::Extensions::LifecycleServerExtension.new(@options.dup) }

    it "adds the listener to the tomcat's server context" do
      subject.configure(tomcat)
      tomcat.server.findLifecycleListeners.should have(2).listener
    end

    it "accepts a glob path" do
      subject.options.replace :path => 'spec/listeners/ser*.rb'
      subject.configure(tomcat)
      tomcat.server.findLifecycleListeners.should have(2).listener
      listeners = tomcat.server.findLifecycleListeners
      listeners[0].should be_a org.apache.catalina.security.SecurityListener
      listeners[1].should be_a org.apache.catalina.startup.EngineConfig
    end
    
  end

  context "webapp" do
    
    subject { Trinidad::Extensions::LifecycleWebAppExtension.new(@options.dup) }

    it "adds the listener to the application context" do
      subject.configure(context)
      context.findLifecycleListeners.should have(2).listener
    end

    it "allows the path to point to a ruby file" do
      subject.options.replace :listeners_path => 'spec/listeners/web_app.rb'
      subject.configure(context)
      context.findLifecycleListeners.should have(1).listener
      context.findLifecycleListeners[0].should be_a org.apache.catalina.startup.UserConfig
    end
    
  end
  
end
