require File.dirname(__FILE__) + '/../../spec_helper'

describe Blog::PostsHelper do
  
  #Delete this example and add some real ones or delete this file
  it "should include the Blog::PostsHelper" do
    included_modules = self.metaclass.send :included_modules
    included_modules.should include(Blog::PostsHelper)
  end
  
end
