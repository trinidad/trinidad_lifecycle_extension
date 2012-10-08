require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'trinidad lifecycle extension' do
  
  before :all do
    @options = { :path => File.expand_path('../fixtures', __FILE__) }
  end

  let(:tomcat) { org.apache.catalina.startup.Tomcat.new }
  let(:context) { Trinidad::Tomcat::StandardContext.new }

  context "server" do
    
    subject { Trinidad::Extensions::LifecycleServerExtension.new(@options.dup) }

    it "adds the listener to the tomcat's server context" do
      subject.configure(tomcat)
      tomcat.server.findLifecycleListeners().should have(2).listener
    end
    
  end

  context "webapp" do
    
    subject { Trinidad::Extensions::LifecycleWebAppExtension.new(@options.dup) }

    it "adds the listener to the application context" do
      subject.configure(tomcat, context)
      context.findLifecycleListeners().should have(2).listener
    end
    
  end
  
end
